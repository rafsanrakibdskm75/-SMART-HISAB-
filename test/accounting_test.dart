import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hisab/data/db/app_database.dart'
    hide CollectionObligation, CollectionSchedule, LedgerEntry,
        PaymentAllocation, Person;
import 'package:smart_hisab/data/repositories/drift_collection_repository.dart';
import 'package:smart_hisab/data/repositories/drift_repositories.dart';
import 'package:smart_hisab/domain/collection_models.dart';
import 'package:smart_hisab/domain/person.dart';

void main() {
  late AppDatabase database;
  late DriftCollectionRepository collections;
  final day = DateTime.utc(2026, 11, 14);

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    final yesterday = day.subtract(const Duration(days: 1));
    await DriftPersonRepository(database, userId: 'test-user')
        .create(const Person(id: 'rahim', name: 'Rahim'));
    collections = DriftCollectionRepository(database, userId: 'test-user');
    await collections.saveSchedule(CollectionSchedule(
      id: 'rahim-daily',
      personId: 'rahim',
      expectedPoisha: 20000,
      type: ScheduleType.daily,
      startDate: yesterday,
      effectiveFrom: yesterday,
    ));
  });

  tearDown(() async => database.close());

  test('partial payments accumulate against the selected obligation', () async {
    await collections.ensureObligations('rahim', from: day, to: day);
    await collections.receivePayment(
        personId: 'rahim', amountPoisha: 10000, date: day, targetDate: day);
    await collections.receivePayment(
        personId: 'rahim', amountPoisha: 5000, date: day, targetDate: day);

    final payments = await collections.paymentsFor('rahim');
    final obligations = await collections.obligationsFor('rahim');
    expect(payments.map((payment) => payment.amountPoisha), [10000, 5000]);
    expect(obligations.single.paidPoisha, 15000);
    expect(obligations.single.expectedPoisha - obligations.single.paidPoisha,
        5000);
  });

  test('a payment allocated today leaves the previous day due', () async {
    final yesterday = day.subtract(const Duration(days: 1));
    await collections.ensureObligations(
        'rahim', from: yesterday, to: day);
    await collections.receivePayment(
        personId: 'rahim', amountPoisha: 20000, date: day, targetDate: day);

    final obligations = await collections.obligationsFor('rahim');
    final previous = obligations.firstWhere((o) => o.date == yesterday);
    final today = obligations.firstWhere((o) => o.date == day);
    expect(previous.paidPoisha, 0);
    expect(today.paidPoisha, 20000);
  });

  test('ensuring the same obligation twice is idempotent', () async {
    final first = await collections.ensureObligations('rahim', from: day, to: day);
    final second = await collections.ensureObligations('rahim', from: day, to: day);

    expect(first, hasLength(1));
    expect(second, hasLength(1));
    expect(second.single.id, first.single.id);
    expect((await collections.obligationsFor('rahim')), hasLength(1));
  });
}
