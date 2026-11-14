/// Drift/SQLite implementation of Stage 4 modules. Money goes through
/// DriftLedgerRepository; module state uses the Stage-4 tables in
/// docs/schema.sql (operator_balances, tokri_rentals, tokri_attendance,
/// somity_members). Apply those CREATE TABLEs in the v2 migration.
library;

import 'package:drift/drift.dart';

import '../../core/dhaka_time.dart';
import '../../core/id_gen.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/modules.dart';
import '../../domain/person.dart' show isValidBdMobile;
import '../../domain/stage6.dart' as stage6;
import '../../domain/sync_queue.dart'; // SyncQueue validation only; outbox arrives with the Stage 5 sync engine
import '../db/app_database.dart' hide CollectionObligation, CollectionSchedule, LedgerEntry, PaymentAllocation, Person, TokriRental;
import 'drift_repositories.dart';
import 'repositories.dart';

class DriftModuleRepository implements ModuleRepository {
  final AppDatabase db;
  final String userId;
  final DateTime Function() _clock;
  DriftModuleRepository(this.db, {required this.userId, DateTime Function()? clock})
      : _clock = clock ?? dhakaToday;

  DriftLedgerRepository get _ledger => DriftLedgerRepository(db, userId: userId);

  Future<List<LedgerEntry>> _allEntries() => _ledger.all();

  Future<void> _post(LedgerEntry e) async {
    var personExists = true;
    if (e.personId != null) {
      final rows = await db.customSelect('SELECT id FROM persons WHERE id = ?',
          variables: [Variable.withString(e.personId!)]).get();
      personExists = rows.isNotEmpty;
    }
    final vErr = SyncQueue().validateFinancialRecord(
        amountPoisha: e.amountPoisha, userId: userId, date: e.date,
        personId: e.personId, personExists: personExists);
    if (vErr != null) throw ArgumentError(vErr);
    await _ledger.addEntry(e);
  }

  @override
  Future<Map<EntryModule, int>> mfsBalances() async {
    final entries = await _allEntries();
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
  Future<int> operatorBalance(String operator) async {
    final rows = await db.customSelect('SELECT balance_poisha FROM operator_balances WHERE operator = ?',
        variables: [Variable.withString(operator)]).get();
    return rows.isEmpty ? 0 : rows.first.read<int>('balance_poisha');
  }

  @override
  Future<void> setOperatorBalance(String operator, int poisha) async {
    if (poisha < 0) throw ArgumentError('ব্যালেন্স ঋণাত্মক হতে পারে না');
    await db.customInsert(
        'INSERT INTO operator_balances (operator, balance_poisha, updated_at) VALUES (?, ?, ?) ON CONFLICT(operator) DO UPDATE SET balance_poisha = excluded.balance_poisha, updated_at = excluded.updated_at',
        variables: [Variable.withString(operator), Variable.withInt(poisha), Variable.withString(_clock().toIso8601String())]);
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
    final balance = await operatorBalance(operator);
    if (balance < amountPoisha) throw StateError('অপারেটর ব্যালেন্স অপর্যাপ্ত');
    final d = date ?? _clock();
    final commission = commissionFor(amountPoisha, commissionBasisPoints);
    final record = RechargeRecord(id: IdGen.next('rch'), operator: operator, number: number,
        amountPoisha: amountPoisha, commissionPoisha: commission, date: d);
    // Ledger first, stock deduction LAST (a rejected post — e.g. closed
    // day — used to eat the operator balance silently).
    await _post(LedgerEntry(
      id: IdGen.next('entry'), date: d, direction: EntryDirection.in_,
      amountPoisha: amountPoisha, module: EntryModule.recharge, note: 'Recharge $number ($operator)'));
    if (commission > 0) {
      await _post(LedgerEntry(
        id: IdGen.next('entry'), date: d, direction: EntryDirection.in_,
        amountPoisha: commission, module: EntryModule.income,
        category: 'Recharge commission', note: 'Recharge commission $number'));
    }
    await setOperatorBalance(operator, balance - amountPoisha);
    return record;
  }

  @override
  Future<List<RechargeRecord>> recharges({int limit = 30}) async {
    // History is reconstructed from recharge ledger entries (operator and
    // number are in the note). Commission per record lives on its income
    // entry; a dedicated recharges table is a v2.1 migration candidate.
    final entries = await _allEntries();
    final out = <RechargeRecord>[];
    for (final e in entries.reversed) {
      if (e.module == EntryModule.recharge && e.direction == EntryDirection.in_) {
        final note = e.note ?? '';
        final m = RegExp(r'Recharge (\S+) \((.+)\)').firstMatch(note);
        final number = m?.group(1) ?? '';
        // Commission lives on its own income entry ('Recharge commission
        // <number>', same date) — v1.0.0 always reported 0 here.
        var commission = 0;
        for (final c in entries) {
          if (c.module == EntryModule.income && c.category == 'Recharge commission' &&
              dateKey(c.date) == dateKey(e.date) && (c.note ?? '').contains(number)) {
            commission += c.amountPoisha;
          }
        }
        out.add(RechargeRecord(
          id: e.id, operator: m?.group(2) ?? '', number: number,
          amountPoisha: e.amountPoisha, commissionPoisha: commission, date: e.date));
        if (out.length >= limit) break;
      }
    }
    return out;
  }

  @override
  Future<PersonalSummary> personalSummaryFor({required DateTime from, required DateTime to}) async =>
      personalSummary(await _allEntries(), from: from, to: to);

  @override
  Future<List<TokriRental>> rentals() async {
    final rows = await db.customSelect(
        'SELECT * FROM tokri_rentals WHERE user_id = ?', variables: [Variable.withString(userId)]).get();
    return rows.map((r) => TokriRental(
        id: r.read<String>('id'), personId: r.read<String>('person_id'),
        tokriCount: r.read<int>('tokri_count'), dailyRatePoisha: r.read<int>('daily_rate_poisha'))).toList();
  }

  @override
  Future<void> saveRental(TokriRental rental) async {
    if (rental.tokriCount <= 0) throw ArgumentError('টোকরির সংখ্যা ০-এর বেশি হতে হবে');
    if (rental.dailyRatePoisha < 0) throw ArgumentError('ভাড়া ঋণাত্মক হতে পারে না');
    await db.customInsert(
        'INSERT INTO tokri_rentals (id, user_id, person_id, tokri_count, daily_rate_poisha, created_at) VALUES (?, ?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET tokri_count = excluded.tokri_count, daily_rate_poisha = excluded.daily_rate_poisha',
        variables: [
          Variable.withString(rental.id), Variable.withString(userId), Variable.withString(rental.personId),
          Variable.withInt(rental.tokriCount), Variable.withInt(rental.dailyRatePoisha),
          Variable.withString(_clock().toIso8601String()),
        ]);
  }

  Future<List<TokriDay>> _daysFor(String rentalId) async {
    final rows = await db.customSelect(
        'SELECT * FROM tokri_attendance WHERE rental_id = ?', variables: [Variable.withString(rentalId)]).get();
    return rows.map((r) => TokriDay(
        rentalId: rentalId, date: parseDateKey(r.read<String>('business_date')),
        status: AttendanceStatus.values.byName(r.read<String>('status')))).toList();
  }

  @override
  Future<void> markAttendance(String rentalId, DateTime date, AttendanceStatus status) async {
    final exists = await db.customSelect('SELECT id FROM tokri_rentals WHERE id = ?',
        variables: [Variable.withString(rentalId)]).get();
    if (exists.isEmpty) throw StateError('Rental not found: $rentalId');
    await db.customInsert(
        'INSERT INTO tokri_attendance (user_id, rental_id, business_date, status) VALUES (?, ?, ?, ?) ON CONFLICT(rental_id, business_date) DO UPDATE SET status = excluded.status',
        variables: [Variable.withString(userId), Variable.withString(rentalId), Variable.withString(dateKey(date)), Variable.withString(status.name)]);
  }

  @override
  Future<TokriDay?> attendanceOf(String rentalId, DateTime date) async {
    final days = await _daysFor(rentalId);
    for (final t in days) {
      if (dateKey(t.date) == dateKey(date)) return t;
    }
    return null;
  }

  @override
  Future<int> tokriDue(String rentalId, {required DateTime from, required DateTime to}) async {
    final all = await rentals();
    final rental = all.where((r) => r.id == rentalId).firstOrNull;
    if (rental == null) return 0;
    final charged = tokriDuePoisha(rental, await _daysFor(rentalId), from: from, to: to);
    final collected = tokriCollectedPoisha(await _allEntries(), rental.personId, from: from, to: to);
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
  Future<List<stage6.BakiBalance>> bakiDueList({required DateTime today}) async =>
      stage6.bakiDueList(await _allEntries(), today: today);

  @override
  Future<stage6.BakiBalance> bakiFor(String personId, {required DateTime today}) async =>
      stage6.bakiBalanceFor(await _allEntries(), personId, today: today);

  @override
  Future<List<String>> somityMemberIds() async {
    final rows = await db.customSelect('SELECT person_id FROM somity_members WHERE user_id = ?',
        variables: [Variable.withString(userId)]).get();
    return rows.map((r) => r.read<String>('person_id')).toList();
  }

  @override
  Future<void> addSomityMember(String personId) async {
    await db.customInsert('INSERT OR IGNORE INTO somity_members (user_id, person_id) VALUES (?, ?)',
        variables: [Variable.withString(userId), Variable.withString(personId)]);
  }

  @override
  Future<void> removeSomityMember(String personId) async {
    await db.customStatement('DELETE FROM somity_members WHERE user_id = ? AND person_id = ?',
        [userId, personId]);
  }
}
