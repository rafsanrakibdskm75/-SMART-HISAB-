/// Drift/SQLite collection repository — same interface and rules as the
/// verified in-memory implementation (Stage 3). Raw SQL mirrors
/// docs/schema.sql. Requires build_runner output (docs/BUILD.md).
library;

import 'package:drift/drift.dart';

import '../../core/dhaka_time.dart';
import '../../core/id_gen.dart';
import '../../domain/collection_engine.dart';
import '../../domain/collection_models.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/overdue.dart';
import '../../domain/schedule_service.dart';
import '../db/app_database.dart' hide CollectionObligation, CollectionSchedule, LedgerEntry, PaymentAllocation, Person;
import 'drift_repositories.dart';
import 'repositories.dart';

int _nowMs() => DateTime.now().toUtc().millisecondsSinceEpoch;

class DriftCollectionRepository implements CollectionRepository {
  final AppDatabase db;
  final String userId;
  DriftCollectionRepository(this.db, {required this.userId});

  @override
  Future<CollectionSchedule> saveSchedule(CollectionSchedule s) async {
    final sErr = validateSchedule(s);
    if (sErr != null) throw FormatException(sErr);
    final person = await db.customSelect('SELECT id FROM persons WHERE id = ?',
        variables: [Variable.withString(s.personId)]).get();
    if (person.isEmpty) throw FormatException('Person not found: ${s.personId}');
    await db.customInsert(
      'INSERT OR REPLACE INTO collection_schedules (id, user_id, person_id, expected_poisha, schedule_type, start_date, end_date, weekdays, day_of_month, grace_days, allow_advance, paused, effective_from, created_at, updated_at, sync_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable.withString(s.id), Variable.withString(userId), Variable.withString(s.personId),
        Variable.withInt(s.expectedPoisha), Variable.withString(s.type.name),
        Variable.withString(dateKey(s.startDate)),
        Variable.withString(s.endDate == null ? '' : dateKey(s.endDate!)),
        Variable.withString(s.weekdays.join(',')),
        Variable.withInt(s.dayOfMonth ?? 0), Variable.withInt(s.graceDays),
        Variable.withInt(s.allowAdvance ? 1 : 0), Variable.withInt(s.paused ? 1 : 0),
        Variable.withString(dateKey(s.effectiveFrom)),
        Variable.withInt(_nowMs()), Variable.withInt(_nowMs()),
        Variable.withString('pendingUpload'),
      ],
    );
    return s;
  }

  CollectionSchedule _scheduleFromRow(Map<String, Object?> d) => CollectionSchedule(
        id: d['id'] as String, personId: d['person_id'] as String,
        expectedPoisha: d['expected_poisha'] as int,
        type: ScheduleType.values.byName(d['schedule_type'] as String),
        startDate: parseDateKey(d['start_date'] as String),
        endDate: (d['end_date'] as String?)?.isEmpty ?? true ? null : parseDateKey(d['end_date'] as String),
        weekdays: ((d['weekdays'] as String?) ?? '').split(',').where((e) => e.isNotEmpty).map(int.parse).toSet(),
        dayOfMonth: (d['day_of_month'] as int?) == 0 ? null : d['day_of_month'] as int?,
        graceDays: d['grace_days'] as int? ?? 0,
        allowAdvance: (d['allow_advance'] as int? ?? 1) == 1,
        paused: (d['paused'] as int? ?? 0) == 1,
        effectiveFrom: parseDateKey(d['effective_from'] as String),
      );

  @override
  Future<List<CollectionSchedule>> schedulesFor(String personId) async {
    final rows = await db.customSelect(
        'SELECT * FROM collection_schedules WHERE person_id = ? ORDER BY effective_from',
        variables: [Variable.withString(personId)]).get();
    return rows.map((r) => _scheduleFromRow(r.data)).toList();
  }

  @override
  Future<void> setPaused(String scheduleId, {required bool paused}) async {
    await db.customUpdate('UPDATE collection_schedules SET paused = ?, updated_at = ? WHERE id = ?',
        variables: [Variable.withInt(paused ? 1 : 0), Variable.withInt(_nowMs()), Variable.withString(scheduleId)],
        updateKind: UpdateKind.update);
  }

  CollectionObligation _obligationFromRow(Map<String, Object?> d) => CollectionObligation(
        personId: d['person_id'] as String, scheduleId: d['schedule_id'] as String,
        date: parseDateKey(d['date'] as String), expectedPoisha: d['expected_poisha'] as int,
        paidPoisha: d['paid_poisha'] as int? ?? 0,
        isHoliday: (d['is_holiday'] as int? ?? 0) == 1,
        lastAllocationDate: (d['last_allocation_date'] as String?)?.isEmpty ?? true
            ? null : parseDateKey(d['last_allocation_date'] as String),
      );

  @override
  Future<List<CollectionObligation>> obligationsFor(String personId) async {
    final rows = await db.customSelect(
        'SELECT * FROM collection_obligations WHERE person_id = ? ORDER BY date',
        variables: [Variable.withString(personId)]).get();
    return rows.map((r) => _obligationFromRow(r.data)).toList();
  }

  @override
  Future<List<CollectionObligation>> ensureObligations(String personId, {required DateTime from, required DateTime to}) async {
    final versions = await schedulesFor(personId);
    final existing = {for (final o in await obligationsFor(personId)) o.id: o};
    final generated = generateForPerson(versions, from: from, to: to, existing: existing);
    for (final o in generated) {
      if (existing.containsKey(o.id)) continue;
      await db.customInsert(
        'INSERT OR IGNORE INTO collection_obligations (id, user_id, person_id, schedule_id, date, expected_poisha, paid_poisha, is_holiday, created_at, updated_at, sync_status) VALUES (?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?)',
        variables: [
          Variable.withString(o.id), Variable.withString(userId),
          Variable.withString(o.personId), Variable.withString(o.scheduleId),
          Variable.withString(dateKey(o.date)), Variable.withInt(o.expectedPoisha),
          Variable.withInt(_nowMs()), Variable.withInt(_nowMs()),
          Variable.withString('pendingUpload'),
        ],
      );
    }
    final all = await obligationsFor(personId);
    return all.where((o) => !o.date.isBefore(from) && !o.date.isAfter(to)).toList();
  }

  @override
  Future<ReceiveResult> receivePayment({
    required String personId,
    required int amountPoisha,
    required DateTime date,
    String method = 'cash',
    DateTime? targetDate,
    String? note,
    EntryModule ledgerModule = EntryModule.collection,
  }) =>
      // One transaction: v1.0.0 wrote payment, allocation, obligation and
      // ledger as four separate steps — a failure mid-way left the books
      // half-posted.
      db.transaction(() => _receivePaymentTx(
          personId: personId, amountPoisha: amountPoisha, date: date,
          method: method, targetDate: targetDate, note: note,
          ledgerModule: ledgerModule));

  Future<ReceiveResult> _receivePaymentTx({
    required String personId,
    required int amountPoisha,
    required DateTime date,
    String method = 'cash',
    DateTime? targetDate,
    String? note,
    EntryModule ledgerModule = EntryModule.collection,
  }) async {
    if (amountPoisha <= 0) throw const FormatException('Amount must be positive');
    final closedRow = await db.customSelect(
        'SELECT is_closed FROM daily_summaries WHERE date = ?',
        variables: [Variable.withString(dateKey(date))]).get();
    if (closedRow.isNotEmpty && (closedRow.first.data['is_closed'] as int) == 1) {
      throw StateError('Day ${dateKey(date)} is closed — reopen it with a reason first');
    }
    final target = targetDate ?? date;
    await ensureObligations(personId, from: target, to: target);
    final mine = await obligationsFor(personId);
    final payment = CollectionPayment(
        id: IdGen.next('pay'), personId: personId, amountPoisha: amountPoisha,
        date: date, method: method, note: note);
    final result = applyPayment(mine, payment, targetDate: targetDate);
    if (!result.ok) throw StateError(result.error!);
    final applied = result.allocations.isEmpty ? 0 : result.allocations.single.amountPoisha;
    // Ledger first inside the transaction: its closed-day guard is the
    // check most likely to reject, and now any failure rolls back all.
    await DriftLedgerRepository(db, userId: userId).addEntry(LedgerEntry(
      id: IdGen.next('entry'), date: date, direction: EntryDirection.in_,
      amountPoisha: amountPoisha, module: ledgerModule,
      personId: personId, note: note ?? 'Collection ${dateKey(target)} ($method)'));
    await db.customInsert(
      'INSERT INTO payments (id, user_id, person_id, amount_poisha, date, method, note, created_at, updated_at, sync_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable.withString(payment.id), Variable.withString(userId),
        Variable.withString(personId), Variable.withInt(amountPoisha),
        Variable.withString(dateKey(date)), Variable.withString(method),
        Variable.withString(note ?? ''), Variable.withInt(_nowMs()),
        Variable.withInt(_nowMs()), Variable.withString('pendingUpload'),
      ],
    );
    if (result.allocations.isNotEmpty) await db.customInsert(
      'INSERT INTO payment_allocations (id, user_id, payment_id, obligation_id, amount_poisha, created_at, updated_at, sync_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable.withString(IdGen.next('alloc')), Variable.withString(userId),
        Variable.withString(payment.id), Variable.withString(result.allocations.single.obligationId),
        Variable.withInt(result.allocations.single.amountPoisha), Variable.withInt(_nowMs()),
        Variable.withInt(_nowMs()), Variable.withString('pendingUpload'),
      ],
    );
    final obligation = mine.firstWhere((o) => dateKey(o.date) == dateKey(target));
    await db.customUpdate(
      'UPDATE collection_obligations SET paid_poisha = ?, last_allocation_date = ?, updated_at = ?, sync_status = ? WHERE id = ?',
      variables: [
        Variable.withInt(obligation.paidPoisha),
        Variable.withString(obligation.lastAllocationDate == null ? '' : dateKey(obligation.lastAllocationDate!)),
        Variable.withInt(_nowMs()), Variable.withString('pendingUpload'),
        Variable.withString(obligation.id),
      ],
      updateKind: UpdateKind.update,
    );
    return ReceiveResult(
      payment: payment, appliedPoisha: applied,
      advanceCreditPoisha: result.advanceCreditPoisha,
      statusAfter: obligation.status(today: date),
    );
  }

  @override
  Future<List<CollectionPayment>> paymentsFor(String personId) async {
    final rows = await db.customSelect(
        'SELECT * FROM payments WHERE person_id = ? ORDER BY date DESC',
        variables: [Variable.withString(personId)]).get();
    return rows.map((r) {
      final d = r.data;
      return CollectionPayment(
        id: d['id'] as String, personId: d['person_id'] as String,
        amountPoisha: d['amount_poisha'] as int, date: parseDateKey(d['date'] as String),
        method: d['method'] as String? ?? 'cash',
        note: (d['note'] as String?)?.isEmpty ?? true ? null : d['note'] as String,
      );
    }).toList();
  }

  @override
  Future<void> markHoliday(String personId, DateTime date, {required bool holiday}) async {
    final generated = await ensureObligations(personId, from: date, to: date);
    if (generated.isEmpty) throw StateError('No collection scheduled on ${dateKey(date)}');
    if (holiday && generated.first.paidPoisha > 0) {
      throw StateError('Cannot mark a day with payments as holiday');
    }
    await db.customUpdate(
      'UPDATE collection_obligations SET is_holiday = ?, updated_at = ? WHERE id = ?',
      variables: [Variable.withInt(holiday ? 1 : 0), Variable.withInt(_nowMs()), Variable.withString(generated.first.id)],
      updateKind: UpdateKind.update,
    );
  }

  @override
  Future<PersonCollectionSummary> summaryFor(String personId, {required DateTime today}) async =>
      summarizePerson(await obligationsFor(personId), today: today);

  Future<Map<String, List<CollectionObligation>>> _byPerson() async {
    final rows = await db.customSelect('SELECT * FROM collection_obligations ORDER BY date').get();
    final map = <String, List<CollectionObligation>>{};
    for (final r in rows) {
      final o = _obligationFromRow(r.data);
      (map[o.personId] ??= []).add(o);
    }
    return map;
  }

  @override
  Future<TodayDashboard> dashboard({required DateTime today}) async =>
      todayDashboard(await _byPerson(), today: today);

  @override
  Future<List<PersonOverdue>> overdue({required DateTime today}) async =>
      overdueReport(await _byPerson(), today: today);
}
