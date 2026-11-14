/// Reference repository implementation (pure Dart, verified by
/// tool/verify_stage2.dart). Holds the same state shape as the SQLite schema
/// and can snapshot/restore as JSON — the persistence contract that Test A
/// checks at logic level (on device, Drift provides the real durability).
library;

import 'dart:convert';

import '../../core/dhaka_time.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/ledger_service.dart';
import '../../domain/person.dart';
import '../../domain/face_recognition.dart';
import '../../domain/collection_models.dart';
import '../../domain/collection_engine.dart';
import '../../domain/modules.dart';
import '../../domain/overdue.dart';
import '../../domain/stage6.dart' as stage6;
import '../../domain/stage6.dart' show AppSettings, BakiBalance;
import '../../domain/schedule_service.dart';
import '../../core/id_gen.dart';
import '../../domain/sync_queue.dart';
import 'repositories.dart';

Map<String, Object?> entryToJson(LedgerEntry e) => {
      'id': e.id, 'date': dateKey(e.date), 'direction': e.direction.name,
      'amountPoisha': e.amountPoisha, 'module': e.module.name,
      'personId': e.personId, 'accountId': e.accountId, 'category': e.category,
      'note': e.note, 'isReversal': e.isReversal, 'reversesEntryId': e.reversesEntryId,
    };

LedgerEntry entryFromJson(Map<String, Object?> j) => LedgerEntry(
      id: j['id'] as String,
      date: parseDateKey(j['date'] as String),
      direction: EntryDirection.values.byName(j['direction'] as String),
      amountPoisha: j['amountPoisha'] as int,
      module: EntryModule.values.byName(j['module'] as String),
      personId: j['personId'] as String?,
      accountId: j['accountId'] as String?,
      category: j['category'] as String?,
      note: j['note'] as String?,
      isReversal: j['isReversal'] as bool? ?? false,
      reversesEntryId: j['reversesEntryId'] as String?,
    );

class InMemoryStore {
  final Map<String, Person> persons = {};
  final List<LedgerEntry> entries = [];
  final Map<String, CollectionSchedule> schedules = {}; // by schedule id (all versions)
  final Map<String, CollectionObligation> obligations = {}; // by deterministic id
  final List<CollectionPayment> payments = [];
  final List<PaymentAllocation> allocations = [];
  final Map<String, DayClosing> closings = {}; // by dateKey
  // Stage 4 module state
  final Map<String, int> operatorBalances = {}; // recharge stock per operator (poisha)
  final List<RechargeRecord> rechargeRecords = [];
  final Map<String, TokriRental> rentals = {};
  final List<TokriDay> tokriDays = [];
  final Set<String> somityMembers = {};
  AppSettings settings = const AppSettings(); // Stage 6
  final Map<String, FaceEnrollment> faceEnrollments = {}; // v1.1.0, local-only
  final SyncQueue syncQueue = SyncQueue();
  // Per-record version counters for MUTABLE entities (schedules, settings,
  // balances…). v1.0.0 enqueued every mutation as v1, so the sync queue's
  // putIfAbsent kept only the FIRST version — later edits never synced.
  final Map<String, int> syncVersions = {};

  /// Enqueue a mutation of a mutable entity with a fresh version number.
  void enqueueMutable(String entity, String recordId) {
    final key = '$entity:$recordId';
    final v = (syncVersions[key] ?? 0) + 1;
    syncVersions[key] = v;
    syncQueue.enqueue(recordId: recordId, localVersion: v, entity: entity);
  }
  final String userId;
  InMemoryStore({this.userId = 'local-user'});

  bool isClosed(DateTime date) {
    final c = closings[dateKey(date)];
    return c != null && !c.reopened;
  }

  String snapshot() => jsonEncode({
        'persons': persons.values.map((p) => p.toJson()).toList(),
        'entries': entries.map(entryToJson).toList(),
        'schedules': schedules.values.map((e) => e.toJson()).toList(),
        'obligations': obligations.values.map((e) => e.toJson()).toList(),
        'payments': payments.map((e) => e.toJson()).toList(),
        'allocations': allocations.map((a) => {'paymentId': a.paymentId, 'obligationId': a.obligationId, 'amountPoisha': a.amountPoisha}).toList(),
        'operatorBalances': operatorBalances,
        'rechargeRecords': rechargeRecords.map((r) => r.toJson()).toList(),
        'rentals': rentals.values.map((r) => r.toJson()).toList(),
        'tokriDays': tokriDays.map((t) => t.toJson()).toList(),
        'somityMembers': somityMembers.toList(),
        'settings': settings.toJson(),
        'syncVersions': syncVersions,
        'closings': closings.values.map((c) => {
              'date': dateKey(c.date), 'closedBy': c.closedBy,
              'closedAt': c.closedAtUtc.toIso8601String(), 'reopened': c.reopened,
              'auditLog': c.auditLog,
              'opening': c.summary.openingPoisha, 'in': c.summary.totalInPoisha,
              'out': c.summary.totalOutPoisha, 'collection': c.summary.collectionPoisha,
            }).toList(),
      });

  static InMemoryStore restore(String json, {String userId = 'local-user'}) {
    final j = jsonDecode(json) as Map<String, Object?>;
    final s = InMemoryStore(userId: userId);
    for (final p in (j['persons'] as List).cast<Map<String, Object?>>()) {
      final person = Person.fromJson(p);
      s.persons[person.id] = person;
    }
    for (final e in (j['entries'] as List).cast<Map<String, Object?>>()) {
      s.entries.add(entryFromJson(e));
    }
    for (final sc in ((j['schedules'] as List?) ?? const []).cast<Map<String, Object?>>()) {
      final schedule = CollectionScheduleJson.fromJson(sc);
      s.schedules[schedule.id] = schedule;
    }
    for (final o in ((j['obligations'] as List?) ?? const []).cast<Map<String, Object?>>()) {
      final obligation = CollectionObligationJson.fromJson(o);
      s.obligations[obligation.id] = obligation;
    }
    for (final pay in ((j['payments'] as List?) ?? const []).cast<Map<String, Object?>>()) {
      s.payments.add(CollectionPaymentJson.fromJson(pay));
    }
    for (final a in ((j['allocations'] as List?) ?? const []).cast<Map<String, Object?>>()) {
      s.allocations.add(PaymentAllocation(paymentId: a['paymentId'] as String, obligationId: a['obligationId'] as String, amountPoisha: a['amountPoisha'] as int));
    }
    s.operatorBalances.addAll(((j['operatorBalances'] as Map?) ?? const {}).map((k, v) => MapEntry(k as String, (v as num).toInt())));
    for (final r in ((j['rechargeRecords'] as List?) ?? const []).cast<Map<String, Object?>>()) {
      s.rechargeRecords.add(RechargeRecord.fromJson(r));
    }
    for (final r in ((j['rentals'] as List?) ?? const []).cast<Map<String, Object?>>()) {
      final rental = TokriRental.fromJson(r);
      s.rentals[rental.id] = rental;
    }
    for (final t in ((j['tokriDays'] as List?) ?? const []).cast<Map<String, Object?>>()) {
      s.tokriDays.add(TokriDay.fromJson(t));
    }
    s.somityMembers.addAll(((j['somityMembers'] as List?) ?? const []).cast<String>());
    final sj = j['settings'] as Map<String, Object?>?;
    if (sj != null) s.settings = AppSettings.fromJson(sj);
    s.syncVersions.addAll(((j['syncVersions'] as Map?) ?? const {})
        .map((k, v) => MapEntry(k as String, (v as num).toInt())));
    for (final c in (j['closings'] as List).cast<Map<String, Object?>>()) {
      final date = parseDateKey(c['date'] as String);
      final closing = DayClosing(
        date: date,
        summary: DailySummary(date: date, openingPoisha: c['opening'] as int,
            totalInPoisha: c['in'] as int, totalOutPoisha: c['out'] as int, collectionPoisha: c['collection'] as int),
        closedBy: c['closedBy'] as String,
        closedAtUtc: DateTime.parse(c['closedAt'] as String),
      );
      closing.reopened = c['reopened'] as bool? ?? false;
      closing.auditLog.addAll((c['auditLog'] as List).cast<String>());
      s.closings[dateKey(date)] = closing;
    }
    return s;
  }

  /// Replace ALL contents in place (backup restore): repository objects
  /// keep pointing at this store, so the whole app sees the restored data.
  void replaceWith(InMemoryStore other) {
    persons..clear()..addAll(other.persons);
    entries..clear()..addAll(other.entries);
    schedules..clear()..addAll(other.schedules);
    obligations..clear()..addAll(other.obligations);
    payments..clear()..addAll(other.payments);
    allocations..clear()..addAll(other.allocations);
    closings..clear()..addAll(other.closings);
    operatorBalances..clear()..addAll(other.operatorBalances);
    rechargeRecords..clear()..addAll(other.rechargeRecords);
    rentals..clear()..addAll(other.rentals);
    tokriDays..clear()..addAll(other.tokriDays);
    somityMembers..clear()..addAll(other.somityMembers);
    syncVersions..clear()..addAll(other.syncVersions);
    settings = other.settings;
  }
}

class InMemoryPersonRepository implements PersonRepository {
  final InMemoryStore store;
  InMemoryPersonRepository(this.store);

  @override
  Future<Person> create(Person person) async {
    final err = validatePerson(name: person.name, mobile: person.mobile);
    if (err != null) throw FormatException(err);
    if (store.persons.containsKey(person.id)) throw StateError('Person already exists: ${person.id}');
    store.persons[person.id] = person;
    store.syncQueue.enqueue(recordId: person.id, localVersion: person.localVersion, entity: 'persons');
    return person;
  }

  @override
  Future<Person> update(Person person) async {
    final err = validatePerson(name: person.name, mobile: person.mobile);
    if (err != null) throw FormatException(err);
    final stored = store.persons[person.id];
    if (stored == null) throw StateError('Person not found: ${person.id}');
    // Bump from the STORED version — a stale object passed twice used to
    // re-use the same version (and the same sync opId) for two edits.
    // Nullable fields the caller left null keep their stored values (an
    // edit form that does not touch the photo must not erase it).
    final updated = Person(
      id: person.id, name: person.name,
      mobile: person.mobile ?? stored.mobile,
      address: person.address ?? stored.address,
      photoPath: person.photoPath ?? stored.photoPath,
      type: person.type, isDeleted: person.isDeleted,
      localVersion: stored.localVersion + 1,
    );
    store.persons[person.id] = updated;
    store.syncQueue.enqueue(recordId: person.id, localVersion: updated.localVersion, entity: 'persons');
    return updated;
  }

  @override
  Future<void> softDelete(String personId) async {
    final p = store.persons[personId];
    if (p == null) return;
    final deleted = p.copyWith(isDeleted: true, localVersion: p.localVersion + 1);
    store.persons[personId] = deleted;
    store.syncQueue.enqueue(recordId: personId, localVersion: deleted.localVersion, entity: 'persons');
  }

  @override
  Future<Person?> getById(String personId) async => store.persons[personId];

  @override
  Future<List<Person>> list({String query = '', PersonType? type, bool includeDeleted = false}) async {
    final out = store.persons.values.where((p) {
      if (!includeDeleted && p.isDeleted) return false;
      if (type != null && p.type != type) return false;
      return personMatches(p, query);
    }).toList();
    out.sort((a, b) => a.name.compareTo(b.name));
    return out;
  }
}

class InMemoryLedgerRepository implements LedgerRepository {
  final InMemoryStore store;
  InMemoryLedgerRepository(this.store);

  @override
  Future<LedgerEntry> addEntry(LedgerEntry entry) async {
    final err = validateEntry(entry);
    if (err != null) throw FormatException(err);
    final vErr = store.syncQueue.validateFinancialRecord(
        amountPoisha: entry.amountPoisha, userId: store.userId, date: entry.date,
        personId: entry.personId,
        personExists: entry.personId == null || store.persons.containsKey(entry.personId));
    if (vErr != null) throw FormatException(vErr);
    if (store.isClosed(entry.date)) {
      throw StateError('Day ${dateKey(entry.date)} is closed — reopen it with a reason first');
    }
    if (store.entries.any((e) => e.id == entry.id)) {
      throw StateError('Duplicate entry ID: ${entry.id}');
    }
    store.entries.add(entry);
    store.syncQueue.enqueue(recordId: entry.id, localVersion: 1, entity: 'ledger_entries');
    return entry;
  }

  @override
  Future<LedgerEntry> reverseEntry(LedgerEntry original, {required DateTime date, String? note}) async {
    if (original.isReversal) throw StateError('A reversal entry cannot itself be reversed');
    if (!store.entries.any((e) => e.id == original.id)) {
      throw StateError('Original entry not found: ${original.id}');
    }
    if (store.entries.any((e) => e.isReversal && e.reversesEntryId == original.id)) {
      throw StateError('Entry already reversed: ${original.id}');
    }
    final reversal = makeReversal(original, date: date, note: note);
    return addEntry(reversal);
  }

  @override
  Future<List<LedgerEntry>> query(EntryFilter filter, {int pageIndex = 0, int pageSize = 50}) async {
    return page(filterEntries(store.entries, filter), pageIndex: pageIndex, pageSize: pageSize);
  }

  @override
  Future<List<LedgerEntry>> all() async => List.unmodifiable(store.entries);

  @override
  Future<int> personNet(String personId) async => personNetPoisha(store.entries, personId);
}

class InMemoryDailyRepository implements DailyRepository {
  final InMemoryStore store;
  InMemoryDailyRepository(this.store);

  @override
  Future<DailySummary> summaryFor(DateTime date) async {
    return summarizeDay(store.entries, date, openingPoisha: openingBalanceFor(store.entries, date));
  }

  @override
  Future<DayClosing> closeDay(DateTime date, {required String closedBy}) async {
    if (store.isClosed(date)) throw StateError('Day ${dateKey(date)} is already closed');
    final prior = store.closings[dateKey(date)];
    final summary = await summaryFor(date);
    final closing = DayClosing(date: date, summary: summary, closedBy: closedBy, closedAtUtc: DateTime.now().toUtc());
    if (prior != null) {
      // Re-closing after a reopen must NOT wipe the audit trail (v1.0.0 did).
      closing.auditLog.addAll(prior.auditLog);
      closing.auditLog.add('${dateKey(DateTime.now().toUtc())} re-closed by $closedBy');
    }
    store.closings[dateKey(date)] = closing;
    store.enqueueMutable('daily_summaries', 'closing_${dateKey(date)}');
    return closing;
  }

  @override
  Future<void> reopenDay(DateTime date, {required String by, required String reason}) async {
    if (reason.trim().isEmpty) throw ArgumentError('Reopen reason is required');
    final closing = store.closings[dateKey(date)];
    if (closing == null) throw StateError('Day ${dateKey(date)} was never closed');
    if (!store.isClosed(date)) throw StateError('Day ${dateKey(date)} is not closed');
    closing.reopen(by: by, reason: reason, atUtc: DateTime.now().toUtc());
    store.enqueueMutable('daily_summaries', 'closing_${dateKey(date)}');
  }

  @override
  Future<bool> isClosed(DateTime date) async => store.isClosed(date);

  @override
  Future<List<DailySummary>> history({required DateTime from, required DateTime to}) async {
    final out = <DailySummary>[];
    var d = from;
    while (!d.isAfter(to)) {
      final hasActivity = store.entries.any((e) => dateKey(e.date) == dateKey(d)) || store.closings.containsKey(dateKey(d));
      if (hasActivity) out.add(await summaryFor(d));
      d = addDays(d, 1);
    }
    return out.reversed.toList();
  }
}

class InMemoryCollectionRepository implements CollectionRepository {
  final InMemoryStore store;
  InMemoryCollectionRepository(this.store);

  @override
  Future<CollectionSchedule> saveSchedule(CollectionSchedule schedule) async {
    final sErr = validateSchedule(schedule);
    if (sErr != null) throw FormatException(sErr);
    if (!store.persons.containsKey(schedule.personId)) {
      throw FormatException('Person not found: ${schedule.personId}');
    }
    store.schedules[schedule.id] = schedule;
    store.enqueueMutable('collection_schedules', schedule.id);
    return schedule;
  }

  @override
  Future<List<CollectionSchedule>> schedulesFor(String personId) async {
    final out = store.schedules.values.where((s) => s.personId == personId).toList()
      ..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));
    return out;
  }

  @override
  Future<void> setPaused(String scheduleId, {required bool paused}) async {
    final s = store.schedules[scheduleId];
    if (s == null) return;
    store.schedules[scheduleId] = CollectionSchedule(
      id: s.id, personId: s.personId, expectedPoisha: s.expectedPoisha, type: s.type,
      startDate: s.startDate, endDate: s.endDate, weekdays: s.weekdays,
      dayOfMonth: s.dayOfMonth, graceDays: s.graceDays, allowAdvance: s.allowAdvance,
      paused: paused, effectiveFrom: s.effectiveFrom);
    store.enqueueMutable('collection_schedules', scheduleId);
  }

  @override
  Future<List<CollectionObligation>> ensureObligations(String personId, {required DateTime from, required DateTime to}) async {
    final versions = await schedulesFor(personId);
    if (versions.isNotEmpty) {
      final generated = generateForPerson(versions, from: from, to: to, existing: store.obligations);
      for (final o in generated) {
        store.obligations.putIfAbsent(o.id, () => o);
      }
    }
    final out = store.obligations.values
        .where((o) => o.personId == personId && !o.date.isBefore(from) && !o.date.isAfter(to))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return out;
  }

  @override
  Future<List<CollectionObligation>> obligationsFor(String personId) async {
    final out = store.obligations.values.where((o) => o.personId == personId).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return out;
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
  }) async {
    final vErr = store.syncQueue.validateFinancialRecord(
        amountPoisha: amountPoisha, userId: store.userId, date: date,
        personId: personId, personExists: store.persons.containsKey(personId));
    if (vErr != null) throw FormatException(vErr);
    if (store.isClosed(date)) {
      throw StateError('Day ${dateKey(date)} is closed — reopen it with a reason first');
    }
    final target = targetDate ?? date;
    await ensureObligations(personId, from: target, to: target);
    final mine = await obligationsFor(personId);
    // Validate the target BEFORE any money moves (v1.0.0 mutated the
    // obligation first, so a later failure left phantom paid amounts).
    CollectionObligation? targetOb;
    for (final o in mine) {
      if (dateKey(o.date) == dateKey(target)) { targetOb = o; break; }
    }
    if (targetOb == null) throw StateError('No collection scheduled for that date');
    if (targetOb.isHoliday) throw StateError('That date is marked as a holiday');
    // Post the cash to the daily ledger first (§19): if this throws (closed
    // day, duplicate), the obligation stays untouched.
    await InMemoryLedgerRepository(store).addEntry(LedgerEntry(
      id: IdGen.next('entry'), date: date, direction: EntryDirection.in_,
      amountPoisha: amountPoisha, module: ledgerModule,
      personId: personId, note: note ?? 'Collection ${dateKey(target)} ($method)'));
    final payment = CollectionPayment(
        id: IdGen.next('pay'), personId: personId, amountPoisha: amountPoisha,
        date: date, method: method, note: note);
    final result = applyPayment(mine, payment, targetDate: targetDate);
    if (!result.ok) throw StateError(result.error!);
    store.payments.add(payment);
    store.allocations.addAll(result.allocations);
    store.syncQueue.enqueue(recordId: payment.id, localVersion: 1, entity: 'payments');
    final applied = result.allocations.isEmpty ? 0 : result.allocations.single.amountPoisha;
    return ReceiveResult(
      payment: payment,
      appliedPoisha: applied,
      advanceCreditPoisha: result.advanceCreditPoisha,
      statusAfter: targetOb.status(today: date),
    );
  }

  @override
  Future<List<CollectionPayment>> paymentsFor(String personId) async {
    final out = store.payments.where((p) => p.personId == personId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return out;
  }

  @override
  Future<void> markHoliday(String personId, DateTime date, {required bool holiday}) async {
    final generated = await ensureObligations(personId, from: date, to: date);
    if (generated.isEmpty) throw StateError('No collection scheduled on ${dateKey(date)}');
    if (holiday && generated.first.paidPoisha > 0) {
      throw StateError('Cannot mark a day with payments as holiday');
    }
    generated.first.isHoliday = holiday;
    store.enqueueMutable('collection_obligations', generated.first.id);
  }

  @override
  Future<PersonCollectionSummary> summaryFor(String personId, {required DateTime today}) async {
    return summarizePerson(await obligationsFor(personId), today: today);
  }

  Map<String, List<CollectionObligation>> _byPerson() {
    final map = <String, List<CollectionObligation>>{};
    for (final o in store.obligations.values) {
      (map[o.personId] ??= []).add(o);
    }
    return map;
  }

  @override
  Future<TodayDashboard> dashboard({required DateTime today}) async =>
      todayDashboard(_byPerson(), today: today);

  @override
  Future<List<PersonOverdue>> overdue({required DateTime today}) async =>
      overdueReport(_byPerson(), today: today);
}

/// In-memory Stage 4 modules (unit-verified in tool/verify_stage4.dart).
class InMemoryModuleRepository implements ModuleRepository {
  final InMemoryStore store;
  final DateTime Function() _clock;
  InMemoryModuleRepository(this.store, {DateTime Function()? clock}) : _clock = clock ?? dhakaToday;

  InMemoryLedgerRepository get _ledger => InMemoryLedgerRepository(store);

  Future<void> _post(LedgerEntry e) async {
    final vErr = store.syncQueue.validateFinancialRecord(
        amountPoisha: e.amountPoisha, userId: store.userId, date: e.date,
        personId: e.personId, personExists: e.personId == null || store.persons.containsKey(e.personId));
    if (vErr != null) throw ArgumentError(vErr);
    await _ledger.addEntry(e);
  }

  @override
  Future<Map<EntryModule, int>> mfsBalances() async {
    final entries = await _ledger.all();
    return {for (final p in mfsProviders.keys) p: accountBalancePoisha(entries, p)};
  }

  @override
  Future<void> addMfsTransaction({
    required EntryModule provider, required MfsTxType type, required int amountPoisha,
    int feePoisha = 0, int commissionPoisha = 0, DateTime? date, String? note,
  }) async {
    if (amountPoisha <= 0) throw ArgumentError('পরিমাণ ০-এর বেশি হতে হবে');
    final d = date ?? _clock();
    final inTypes = {MfsTxType.cashIn, MfsTxType.receive};
    await _post(LedgerEntry(
      id: IdGen.next('entry'), date: d,
      direction: inTypes.contains(type) ? EntryDirection.in_ : EntryDirection.out_,
      amountPoisha: amountPoisha, module: provider, category: 'mfs_${type.name}', note: note));
    if (feePoisha > 0) {
      await _post(LedgerEntry(
        id: IdGen.next('entry'), date: d, direction: EntryDirection.out_,
        amountPoisha: feePoisha, module: provider, category: 'mfs_fee', note: 'MFS fee (${type.name})'));
    }
    if (commissionPoisha > 0) {
      await _post(LedgerEntry(
        id: IdGen.next('entry'), date: d, direction: EntryDirection.in_,
        amountPoisha: commissionPoisha, module: EntryModule.income,
        category: 'MFS commission', note: 'Commission (${type.name})'));
    }
  }

  @override
  Future<void> transfer({required EntryModule from, required EntryModule to, required int amountPoisha, DateTime? date, String? note}) async {
    if (from == to) throw ArgumentError('একই অ্যাকাউন্টে ট্রান্সফার হয় না');
    if (amountPoisha <= 0) throw ArgumentError('পরিমাণ ০-এর বেশি হতে হবে');
    final pair = makeTransfer(groupId: IdGen.next('g'), from: from, to: to,
        amountPoisha: amountPoisha, date: date ?? _clock(), note: note);
    await _post(pair.outEntry);
    await _post(pair.inEntry);
  }

  @override
  Future<int> operatorBalance(String operator) async => store.operatorBalances[operator] ?? 0;

  @override
  Future<void> setOperatorBalance(String operator, int poisha) async {
    if (poisha < 0) throw ArgumentError('ব্যালেন্স ঋণাত্মক হতে পারে না');
    store.operatorBalances[operator] = poisha;
    store.enqueueMutable('operator_balances', operator);
  }

  @override
  Future<RechargeRecord> recharge({
    required String operator, required String number, required int amountPoisha,
    required int commissionBasisPoints, DateTime? date,
  }) async {
    if (amountPoisha <= 0) throw ArgumentError('পরিমাণ ০-এর বেশি হতে হবে');
    if (!telecomOperators.contains(operator)) throw ArgumentError('অজানা অপারেটর: $operator');
    if (!isValidBdMobile(number)) throw ArgumentError('সঠিক মোবাইল নম্বর দিন (01XXXXXXXXX)');
    if (commissionBasisPoints < 0 || commissionBasisPoints > 10000) {
      throw ArgumentError('কমিশন ০–১০০% এর মধ্যে হতে হবে');
    }
    final balance = store.operatorBalances[operator] ?? 0;
    if (balance < amountPoisha) throw StateError('অপারেটর ব্যালেন্স অপর্যাপ্ত: আছে ৳${(balance / 100).toStringAsFixed(2)}');
    final d = date ?? _clock();
    if (store.isClosed(d)) {
      throw StateError('Day ${dateKey(d)} is closed — reopen it with a reason first');
    }
    final commission = commissionFor(amountPoisha, commissionBasisPoints);
    // Ledger first, stock LAST: v1.0.0 deducted stock before posting, so a
    // rejected post (e.g. closed day) silently ate the operator balance.
    await _post(LedgerEntry(
      id: IdGen.next('entry'), date: d, direction: EntryDirection.in_,
      amountPoisha: amountPoisha, module: EntryModule.recharge, note: 'Recharge $number ($operator)'));
    if (commission > 0) {
      await _post(LedgerEntry(
        id: IdGen.next('entry'), date: d, direction: EntryDirection.in_,
        amountPoisha: commission, module: EntryModule.income,
        category: 'Recharge commission', note: 'Recharge commission $number'));
    }
    final record = RechargeRecord(id: IdGen.next('rch'), operator: operator, number: number,
        amountPoisha: amountPoisha, commissionPoisha: commission, date: d);
    store.operatorBalances[operator] = balance - amountPoisha;
    store.rechargeRecords.add(record);
    store.syncQueue.enqueue(recordId: record.id, localVersion: 1, entity: 'recharges');
    return record;
  }

  @override
  Future<List<RechargeRecord>> recharges({int limit = 30}) async =>
      store.rechargeRecords.reversed.take(limit).toList();

  @override
  Future<PersonalSummary> personalSummaryFor({required DateTime from, required DateTime to}) async {
    final entries = await _ledger.all();
    return personalSummary(entries, from: from, to: to);
  }

  @override
  Future<List<TokriRental>> rentals() async => store.rentals.values.toList();

  @override
  Future<void> saveRental(TokriRental rental) async {
    if (rental.tokriCount <= 0) throw ArgumentError('টোকরির সংখ্যা ০-এর বেশি হতে হবে');
    if (rental.dailyRatePoisha < 0) throw ArgumentError('ভাড়া ঋণাত্মক হতে পারে না');
    store.rentals[rental.id] = rental;
    store.enqueueMutable('tokri_rentals', rental.id);
  }

  @override
  Future<void> markAttendance(String rentalId, DateTime date, AttendanceStatus status) async {
    if (!store.rentals.containsKey(rentalId)) throw StateError('Rental not found: $rentalId');
    store.tokriDays.removeWhere((t) => t.rentalId == rentalId && dateKey(t.date) == dateKey(date));
    final day = TokriDay(rentalId: rentalId, date: date, status: status);
    store.tokriDays.add(day);
    store.enqueueMutable('tokri_attendance', '${rentalId}_${dateKey(date)}');
  }

  @override
  Future<TokriDay?> attendanceOf(String rentalId, DateTime date) async {
    for (final t in store.tokriDays) {
      if (t.rentalId == rentalId && dateKey(t.date) == dateKey(date)) return t;
    }
    return null;
  }

  @override
  Future<int> tokriDue(String rentalId, {required DateTime from, required DateTime to}) async {
    final rental = store.rentals[rentalId];
    if (rental == null) return 0;
    final charged = tokriDuePoisha(rental, store.tokriDays, from: from, to: to);
    final entries = await _ledger.all();
    final collected = tokriCollectedPoisha(entries, rental.personId, from: from, to: to);
    final due = charged - collected;
    return due < 0 ? 0 : due;
  }

  @override
  Future<void> collectRent({required String rentalId, required String personId, required int amountPoisha, DateTime? date}) async {
    await _post(LedgerEntry(
      id: IdGen.next('entry'), date: date ?? _clock(), direction: EntryDirection.in_,
      amountPoisha: amountPoisha, module: EntryModule.tokriVara,
      personId: personId, note: 'Tokri rent ($rentalId)'));
  }

  @override
  Future<void> addBakiCredit({required String personId, required int amountPoisha, DateTime? date, String? note}) async {
    await _post(LedgerEntry(
      id: IdGen.next('entry'), date: date ?? _clock(), direction: EntryDirection.out_,
      amountPoisha: amountPoisha, module: EntryModule.baki, personId: personId,
      category: 'বাকি বিক্রি', note: note));
  }

  @override
  Future<void> addBakiPayment({required String personId, required int amountPoisha, DateTime? date, String? note}) async {
    await _post(LedgerEntry(
      id: IdGen.next('entry'), date: date ?? _clock(), direction: EntryDirection.in_,
      amountPoisha: amountPoisha, module: EntryModule.baki, personId: personId,
      category: 'বাকি পরিশোধ', note: note));
  }

  @override
  Future<List<BakiBalance>> bakiDueList({required DateTime today}) async =>
      stage6.bakiDueList(await _ledger.all(), today: today);

  @override
  Future<BakiBalance> bakiFor(String personId, {required DateTime today}) async =>
      stage6.bakiBalanceFor(await _ledger.all(), personId, today: today);

  @override
  Future<List<String>> somityMemberIds() async => store.somityMembers.toList();

  @override
  Future<void> addSomityMember(String personId) async {
    store.somityMembers.add(personId);
    store.enqueueMutable('somity_members', personId);
  }

  @override
  Future<void> removeSomityMember(String personId) async {
    store.somityMembers.remove(personId);
    store.enqueueMutable('somity_members', personId);
  }
}

/// Stage 6 settings (in-memory).
class InMemorySettingsRepository implements SettingsRepository {
  final InMemoryStore store;
  InMemorySettingsRepository(this.store);
  @override
  Future<AppSettings> load() async => store.settings;
  @override
  Future<void> save(AppSettings settings) async {
    store.settings = settings;
    store.enqueueMutable('app_settings', 'settings');
  }
}

/// In-memory face enrollments (v1.1.0). Deliberately NOT part of the
/// store snapshot: backups must never carry biometric data.
class InMemoryFaceEnrollmentRepository implements FaceEnrollmentRepository {
  final InMemoryStore store;
  InMemoryFaceEnrollmentRepository(this.store);

  @override
  Future<FaceEnrollment?> getFor(String personId) async => store.faceEnrollments[personId];

  @override
  Future<List<FaceEnrollment>> all() async =>
      store.faceEnrollments.values.toList(growable: false);

  @override
  Future<void> save(FaceEnrollment enrollment) async {
    store.faceEnrollments[enrollment.personId] = enrollment;
  }

  @override
  Future<void> remove(String personId) async {
    store.faceEnrollments.remove(personId);
  }
}
