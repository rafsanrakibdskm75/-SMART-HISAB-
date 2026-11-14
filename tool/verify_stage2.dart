/// Stage 2 verification (plain Dart, no packages):
///   dart run tool/verify_stage2.dart
/// Covers Test A at logic level (offline write → snapshot → restore → data
/// intact), person search/validation/tombstone, ledger immutability via
/// reversal, closed-day guard + audited reopen, monthly/yearly summaries.
import '../lib/core/dhaka_time.dart';
import '../lib/core/id_gen.dart';
import '../lib/core/money.dart';
import '../lib/data/repositories/in_memory_repositories.dart';
import '../lib/domain/daily_ledger.dart';
import '../lib/domain/ledger_service.dart';
import '../lib/domain/person.dart';

int _pass = 0, _fail = 0;
void check(String name, bool cond, [String detail = '']) {
  if (cond) { _pass++; print('PASS  $name'); }
  else { _fail++; print('FAIL  $name  $detail'); }
}
void eq(String name, Object? a, Object? b) => check(name, a == b, '(got $a, want $b)');

Future<void> main() async {
  final nov12 = dateOnly(2026, 11, 12);
  final nov13 = dateOnly(2026, 11, 13);

  // ---- Person management ----
  var store = InMemoryStore();
  var persons = InMemoryPersonRepository(store);
  var ledger = InMemoryLedgerRepository(store);
  var daily = InMemoryDailyRepository(store);

  final rahim = await persons.create(const Person(id: 'p_rahim', name: 'Rahim Uddin', mobile: '01712345678'));
  await persons.create(const Person(id: 'p_karim', name: 'Karim Ali', mobile: '01898765432', type: PersonType.somityMember));
  eq('search by name', (await persons.list(query: 'rahim')).length, 1);
  eq('search by mobile', (await persons.list(query: '01898')).single.id, 'p_karim');
  eq('search by id', (await persons.list(query: 'p_rahim')).single.name, 'Rahim Uddin');
  var threw = false;
  try {
    await persons.create(const Person(id: 'p_bad', name: 'Bad', mobile: '12345'));
  } on FormatException { threw = true; }
  check('bad BD mobile rejected', threw);
  await persons.softDelete('p_karim');
  eq('soft-deleted hidden from list', (await persons.list()).length, 1);
  eq('tombstone kept', (await persons.list(includeDeleted: true)).length, 2);

  // ---- Test A (logic): offline expense survives a restart ----
  await ledger.addEntry(LedgerEntry(id: 'e_a1', date: nov12, direction: EntryDirection.out_,
      amountPoisha: takaToPoisha(1000), module: EntryModule.expense, note: 'Shop rent part'));
  final snapshot = store.snapshot();
  store = InMemoryStore.restore(snapshot); // simulated app restart / new device state
  persons = InMemoryPersonRepository(store);
  ledger = InMemoryLedgerRepository(store);
  daily = InMemoryDailyRepository(store);
  eq('A person survived restore', (await persons.list()).length, 1);
  final restored = await ledger.all();
  eq('A expense survived restore', restored.length, 1);
  eq('A expense amount intact', restored.single.amountPoisha, 100000);
  check('A restored person is Rahim', (await persons.getById(rahim.id))?.name == 'Rahim Uddin');

  // ---- Ledger immutability: fix by reversal, original untouched ----
  await ledger.addEntry(LedgerEntry(id: 'e_in1', date: nov12, direction: EntryDirection.in_,
      amountPoisha: takaToPoisha(5000), module: EntryModule.income, personId: 'p_rahim'));
  final before = (await ledger.all()).firstWhere((e) => e.id == 'e_a1');
  await ledger.reverseEntry(before, date: nov13);
  final all = await ledger.all();
  eq('reversal added as new entry', all.length, 3);
  final original = all.firstWhere((e) => e.id == 'e_a1');
  eq('original entry unchanged', original.amountPoisha, 100000);
  final rev = all.firstWhere((e) => e.isReversal);
  eq('reversal linked to original', rev.reversesEntryId, 'e_a1');
  eq('reversal opposite direction', rev.direction, EntryDirection.in_);
  final day12 = await daily.summaryFor(nov12);
  eq('day12 in (income only)', day12.totalInPoisha, 500000);
  eq('day12 out (expense)', day12.totalOutPoisha, 100000);

  // duplicate ID can never enter twice (§12)
  threw = false;
  try {
    await ledger.addEntry(LedgerEntry(id: 'e_in1', date: nov12, direction: EntryDirection.in_,
        amountPoisha: 100, module: EntryModule.income));
  } on StateError { threw = true; }
  check('duplicate entry ID rejected', threw);

  // ---- Daily closing: closed day blocks entries, reopen is audited ----
  final closing = await daily.closeDay(nov12, closedBy: 'owner');
  eq('closing balance = 5000-1000', closing.summary.closingPoisha, 400000);
  eq('next day opening = closing', (await daily.summaryFor(nov13)).openingPoisha, 400000);
  threw = false;
  try {
    await ledger.addEntry(LedgerEntry(id: 'e_late', date: nov12, direction: EntryDirection.in_,
        amountPoisha: 100, module: EntryModule.income));
  } on StateError { threw = true; }
  check('closed day rejects new entry', threw);
  await daily.reopenDay(nov12, by: 'owner', reason: 'ভুল এন্ট্রি ঠিক করতে');
  final reopened = store.closings[dateKey(nov12)]!;
  check('reopen is audited with reason', reopened.auditLog.any((l) => l.contains('ভুল এন্ট্রি')));
  await ledger.addEntry(LedgerEntry(id: 'e_late', date: nov12, direction: EntryDirection.in_,
      amountPoisha: 100, module: EntryModule.income));
  check('entry allowed after reopen', (await ledger.all()).any((e) => e.id == 'e_late'));

  // ---- Person statement + monthly/yearly ----
  final statement = personStatement(await ledger.all(), 'p_rahim');
  eq('statement lines for Rahim', statement.length, 1);
  eq('statement running balance', statement.single.runningPoisha, 500000);
  eq('person net', await ledger.personNet('p_rahim'), 500000);
  final month = monthlySummary(await ledger.all(), 2026, 11);
  eq('monthly in', month.totalInPoisha, 500100 + 100000); // income 5000 + late 1 + reversal in 1000
  final year = yearlySummary(await ledger.all(), 2026);
  eq('yearly count matches month', year.entryCount, month.entryCount);

  // ---- Pagination (§16) ----
  final store2 = InMemoryStore();
  final ledger2 = InMemoryLedgerRepository(store2);
  for (var i = 0; i < 60; i++) {
    await ledger2.addEntry(LedgerEntry(id: IdGen.next('bulk'), date: nov12,
        direction: EntryDirection.in_, amountPoisha: 100, module: EntryModule.income));
  }
  eq('page 0 size', (await ledger2.query(const EntryFilter())).length, 50);
  eq('page 1 size', (await ledger2.query(const EntryFilter(), pageIndex: 1)).length, 10);

  // ---- Sync queue grows with mutations, versions are distinct ops ----
  // Note: the queue is per-session here — snapshot/restore rebuilds business
  // data; the Drift store persists the queue table itself on device.
  check('sync ops queued', store.syncQueue.totalCount >= 3, '(got ${store.syncQueue.totalCount})');

  print('\n$_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('$_fail checks failed');
}
