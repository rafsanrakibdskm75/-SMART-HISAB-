import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hisab/core/dhaka_time.dart';
import 'package:smart_hisab/data/db/app_database.dart' hide Person, LedgerEntry, DailySummary, TokriRental, CollectionSchedule, CollectionObligation, PaymentAllocation, FaceEnrollment;
import 'package:smart_hisab/data/repositories/drift_repositories.dart';
import 'package:smart_hisab/data/repositories/drift_collection_repository.dart';
import 'package:smart_hisab/data/repositories/drift_module_repository.dart';
import 'package:smart_hisab/domain/collection_models.dart';
import 'package:smart_hisab/data/repositories/drift_settings_repository.dart';
import 'package:smart_hisab/data/repositories/drift_face_repository.dart';
import 'package:smart_hisab/domain/face_recognition.dart';
import 'package:smart_hisab/domain/daily_ledger.dart';
import 'package:smart_hisab/domain/person.dart';
import 'package:smart_hisab/domain/stage6.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() async => db.close());

  test('all schema.sql tables are actually created', () async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .get();
    final names = rows.map((r) => r.data['name'] as String).toSet();
    for (final t in [
      'persons', 'collection_schedules', 'collection_obligations', 'payments',
      'payment_allocations', 'ledger_entries', 'accounts', 'daily_summaries',
      'audit_log', 'sync_queue', 'backups', 'operator_balances',
      'tokri_rentals', 'tokri_attendance', 'somity_members', 'app_settings',
      'face_enrollments',
    ]) {
      expect(names, contains(t), reason: 'missing table $t');
    }
  });

  test('face enrollments save/load/remove on the real table (local-only)', () async {
    final repo = DriftFaceEnrollmentRepository(db);
    expect(await repo.getFor('p1'), isNull);
    await repo.save(FaceEnrollment(
        personId: 'p1',
        samples: [FaceEmbedding(List.filled(192, 0.05))],
        updatedAtMs: 42));
    final loaded = await repo.getFor('p1');
    expect(loaded, isNotNull);
    expect(loaded!.samples.single.dim, 192);
    expect((await repo.all()).length, 1);
    await repo.remove('p1');
    expect(await repo.getFor('p1'), isNull);
  });

  test('a corrupt face_enrollments row never breaks loading', () async {
    final repo = DriftFaceEnrollmentRepository(db);
    await repo.save(FaceEnrollment(
        personId: 'good',
        samples: [FaceEmbedding(List.filled(192, 0.01))],
        updatedAtMs: 1));
    await db.customInsert(
        "INSERT INTO face_enrollments (person_id, json, updated_at) VALUES ('bad', 'not-json', 'x')");
    final all = await repo.all();
    expect(all.map((e) => e.personId), ['good']);
    expect(await repo.getFor('bad'), isNull);
  });

  test('daily close/reopen + settings + balances work on real tables', () async {
    final ledger = DriftLedgerRepository(db, userId: 'u1');
    final daily = DriftDailyRepository(db, ledger, userId: 'u1');
    final d = DateTime.utc(2026, 11, 12);
    await ledger.addEntry(LedgerEntry(
        id: 'e1', date: d, direction: EntryDirection.in_,
        amountPoisha: 10000, module: EntryModule.income));
    await daily.closeDay(d, closedBy: 'owner');
    expect(await daily.isClosed(d), isTrue);
    await expectLater(daily.closeDay(d, closedBy: 'owner'), throwsStateError);
    await expectLater(
        daily.reopenDay(d, by: 'o', reason: ''), throwsArgumentError);
    await daily.reopenDay(d, by: 'o', reason: 'fix');
    expect(await daily.isClosed(d), isFalse);

    final settings = DriftSettingsRepository(db, userId: 'u1');
    await settings.save(const AppSettings(businessName: 'Test Dokan'));
    expect((await settings.load()).businessName, 'Test Dokan');

    final modules = DriftModuleRepository(db, userId: 'u1');
    await modules.setOperatorBalance('Grameenphone', 5000);
    expect(await modules.operatorBalance('Grameenphone'), 5000);
    await expectLater(
        modules.addBakiCredit(personId: 'ghost', amountPoisha: 100),
        throwsArgumentError);
  });

  test('drift collection payment + advance-only + closed-day recharge', () async {
    final persons = DriftPersonRepository(db, userId: 'u1');
    await persons.create(const Person(id: 'p9', name: 'Karim'));
    final coll = DriftCollectionRepository(db, userId: 'u1');
    final d = DateTime.utc(2026, 11, 12);
    await coll.saveSchedule(CollectionSchedule(
        id: 's9', personId: 'p9', expectedPoisha: 20000,
        type: ScheduleType.daily, startDate: d, effectiveFrom: d));
    final r1 = await coll.receivePayment(
        personId: 'p9', amountPoisha: 20000, date: d, targetDate: d);
    expect(r1.appliedPoisha, 20000);
    final r2 = await coll.receivePayment(
        personId: 'p9', amountPoisha: 5000, date: d, targetDate: d);
    expect(r2.appliedPoisha, 0);
    expect(r2.advanceCreditPoisha, 5000);
    expect((await coll.paymentsFor('p9')).length, 2);
    final allocs = await db
        .customSelect('SELECT amount_poisha FROM payment_allocations')
        .get();
    expect(allocs.length, 1); // no zero-amount allocation row
    expect(allocs.single.data['amount_poisha'], 20000);

    // Recharge on a closed day must not eat operator stock (Drift side).
    final ledger = DriftLedgerRepository(db, userId: 'u1');
    final daily = DriftDailyRepository(db, ledger, userId: 'u1');
    final modules = DriftModuleRepository(db, userId: 'u1');
    await modules.setOperatorBalance('Grameenphone', 100000);
    await daily.closeDay(d, closedBy: 'owner');
    await expectLater(
        modules.recharge(
            operator: 'Grameenphone', number: '01712345678',
            amountPoisha: 10000, commissionBasisPoints: 280, date: d),
        throwsStateError);
    expect(await modules.operatorBalance('Grameenphone'), 100000);
  });

  test('person update validates and keeps photo; delete syncs', () async {
    final persons = DriftPersonRepository(db, userId: 'u1');
    await persons.create(const Person(
        id: 'p1', name: 'Rahim', mobile: '01712345678', photoPath: '/a.jpg'));
    final updated =
        await persons.update(const Person(id: 'p1', name: 'Rahim Uddin'));
    expect(updated.localVersion, 2);
    expect((await persons.getById('p1'))!.photoPath, '/a.jpg');
    await persons.softDelete('p1');
    final q = await db
        .customSelect('SELECT op_id FROM sync_queue ORDER BY op_id')
        .get();
    expect(q.map((r) => r.data['op_id']),
        containsAll(['p1_v1', 'p1_v2', 'p1_v3']));
    expect(dateKey(dhakaToday()).length, 10);
  });
}
