/// Stage 6 verification (plain Dart):
///   dart run tool/verify_stage6.dart
/// Baki FIFO aging, period reports, CSV export, backup round-trip +
/// tamper rejection, settings persistence, reminder planning.
import '../lib/core/dhaka_time.dart';
import '../lib/core/money.dart';
import '../lib/data/repositories/in_memory_repositories.dart';
import '../lib/domain/daily_ledger.dart';
import '../lib/domain/overdue.dart';
import '../lib/domain/person.dart';
import '../lib/domain/stage6.dart';

int _pass = 0, _fail = 0;
void check(String name, bool cond, [String detail = '']) {
  if (cond) { _pass++; print('PASS  $name'); }
  else { _fail++; print('FAIL  $name  $detail'); }
}
void eq(String name, Object? a, Object? b) => check(name, a == b, '(got $a, want $b)');

DateTime d(int day) => dateOnly(2026, 11, day);

LedgerEntry baki(String id, String person, int taka, bool isPayment, DateTime date) => LedgerEntry(
    id: id, date: date, direction: isPayment ? EntryDirection.in_ : EntryDirection.out_,
    amountPoisha: takaToPoisha(taka), module: EntryModule.baki, personId: person);

Future<void> main() async {
  // ---------- Baki FIFO aging ----------
  final entries = [
    baki('b1', 'rahim', 500, false, d(1)),
    baki('b2', 'rahim', 300, false, d(5)),
    baki('b3', 'rahim', 600, true, d(10)),
    baki('b4', 'karim', 200, false, d(3)),
  ];
  final rahim = bakiBalanceFor(entries, 'rahim', today: d(12));
  eq('FIFO due = 500+300-600', rahim.duePoisha, takaToPoisha(200));
  eq('FIFO oldest unpaid is Nov 5 (Nov 1 covered first)', dateKey(rahim.oldestUnpaidDate!), '2026-11-05');
  eq('FIFO days overdue at Nov 12', rahim.daysOverdue, 7);
  final list = bakiDueList(entries, today: d(12));
  eq('due list has both customers', list.length, 2);
  check('due list contains both ids', list.map((b) => b.personId).toSet().containsAll({'rahim', 'karim'}));
  eq('total due across customers', list.fold<int>(0, (a, b) => a + b.duePoisha), takaToPoisha(400));
  final settled = [...entries, baki('b5', 'rahim', 200, true, d(12))];
  eq('full payment clears the due', bakiBalanceFor(settled, 'rahim', today: d(12)).duePoisha, 0);
  eq('cleared customer leaves the list', bakiDueList(settled, today: d(12)).length, 1);

  // ---------- Reports ----------
  final reportEntries = [
    LedgerEntry(id: 'r1', date: d(3), direction: EntryDirection.in_, amountPoisha: takaToPoisha(1000), module: EntryModule.income, category: 'বিক্রি'),
    LedgerEntry(id: 'r2', date: d(3), direction: EntryDirection.out_, amountPoisha: takaToPoisha(250), module: EntryModule.expense, category: 'ভাড়া'),
    LedgerEntry(id: 'r3', date: d(4), direction: EntryDirection.in_, amountPoisha: takaToPoisha(400), module: EntryModule.collection, personId: 'rahim'),
    LedgerEntry(id: 'r4', date: d(4), direction: EntryDirection.in_, amountPoisha: takaToPoisha(999), module: EntryModule.personal, category: 'বেতন'),
    LedgerEntry(id: 'r5', date: d(5), direction: EntryDirection.out_, amountPoisha: takaToPoisha(500), module: EntryModule.bkash, category: 'transfer'),
    LedgerEntry(id: 'r6', date: d(5), direction: EntryDirection.in_, amountPoisha: takaToPoisha(500), module: EntryModule.cash, category: 'transfer'),
    ...entries,
  ];
  final rep = buildReport(reportEntries, from: d(1), to: d(30));
  eq('report income excludes personal + transfers', rep.incomePoisha, takaToPoisha(1000));
  eq('report expense', rep.expensePoisha, takaToPoisha(250));
  eq('report profit', rep.profitPoisha, takaToPoisha(750));
  eq('report collection', rep.collectionPoisha, takaToPoisha(400));
  eq('report baki given', rep.bakiGivenPoisha, takaToPoisha(1000));
  eq('report baki received', rep.bakiReceivedPoisha, takaToPoisha(600));
  eq('expense category breakdown', rep.expenseByCategory['ভাড়া'], takaToPoisha(250));
  final repDay = buildReport(reportEntries, from: d(3), to: d(3));
  eq('single-day report only counts that day', repDay.collectionPoisha, 0);

  // ---------- CSV ----------
  final csv = entriesCsv(reportEntries, {'rahim': 'Rahim'});
  check('CSV starts with BOM for Excel Bangla', csv.startsWith('\uFEFF'));
  check('CSV has header', csv.contains('Date,Person,Module'));
  check('CSV carries person name', csv.contains('Rahim'));
  check('CSV amount in taka with 2 decimals', csv.contains('1000.00'));
  final rcsv = reportCsv(rep);
  check('report CSV has profit row', rcsv.contains('Profit (BDT),750.00'));

  // ---------- Repo-level baki ----------
  final store = InMemoryStore();
  final persons = InMemoryPersonRepository(store);
  final mod = InMemoryModuleRepository(store);
  await persons.create(const Person(id: 'cust1', name: 'Cust', type: PersonType.customer));
  await mod.addBakiCredit(personId: 'cust1', amountPoisha: takaToPoisha(700), date: d(2));
  await mod.addBakiPayment(personId: 'cust1', amountPoisha: takaToPoisha(200), date: d(6));
  eq('repo baki balance', (await mod.bakiFor('cust1', today: d(12))).duePoisha, takaToPoisha(500));
  eq('repo due list', (await mod.bakiDueList(today: d(12))).length, 1);

  // ---------- Backup round-trip + tamper ----------
  final backup = makeBackup(store.snapshot(), exportedAt: DateTime.utc(2026, 11, 13));
  final (data, err) = parseBackup(backup);
  eq('backup parses', err, null);
  final restored = InMemoryStore.restore(data!);
  eq('restored persons', restored.persons.length, 1);
  eq('restored baki still computes', (await InMemoryModuleRepository(restored).bakiDueList(today: d(12))).length, 1);
  final (badData, badErr) = parseBackup(backup.replaceAll('700', '900'));
  eq('tampered backup rejected', badData, null);
  check('tamper error mentions checksum', (badErr ?? '').contains('checksum'));
  final (junkData, _) = parseBackup('not json at all');
  eq('junk rejected', junkData, null);
  // replaceWith keeps the same store object live
  final live = InMemoryStore();
  live.replaceWith(restored);
  eq('replaceWith restores in place', live.persons.length, 1);

  // ---------- Settings ----------
  final settingsRepo = InMemorySettingsRepository(store);
  var st = await settingsRepo.load();
  eq('default business name', st.businessName, 'আমার দোকান');
  await settingsRepo.save(st.copyWith(businessName: 'রহিম স্টোর', lowStockThresholdPoisha: 30000));
  st = await settingsRepo.load();
  eq('settings saved', st.businessName, 'রহিম স্টোর');
  final store2 = InMemoryStore.restore(store.snapshot());
  eq('settings survive snapshot/restore', store2.settings.businessName, 'রহিম স্টোর');
  eq('settings JSON round-trip', AppSettings.fromJson(st.toJson()).lowStockThresholdPoisha, 30000);

  // ---------- Reminder plan ----------
  final plan = buildReminderPlan(
    today: d(12), yesterdayClosed: false,
    overdue: [const PersonOverdue(personId: 'x', items: [], totalPoisha: 10000, kind: OverdueKind.multiDay)],
    operatorBalances: {'Grameenphone': 20000, 'Robi': 90000},
    lowStockThresholdPoisha: 50000);
  eq('plan has closing + overdue + 1 low stock', plan.length, 3);
  check('plan mentions overdue count in Bangla digits', plan[1].body.contains('১'));
  final quiet = buildReminderPlan(
    today: d(12), yesterdayClosed: true, overdue: const [],
    operatorBalances: {'Robi': 90000}, lowStockThresholdPoisha: 50000);
  eq('no facts, no reminders', quiet.length, 0);

  print('\n$_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('$_fail checks failed');
}
