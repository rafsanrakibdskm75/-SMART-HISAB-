/// Stage 4 verification (plain Dart):
///   dart run tool/verify_stage4.dart
/// MFS balances + transfer neutrality, recharge stock/commission, personal
/// separation from the business books (§14), Tokri attendance billing,
/// Somity money kept in its own module, snapshot/restore of module state.
import '../lib/core/dhaka_time.dart';
import '../lib/core/money.dart';
import '../lib/data/repositories/in_memory_repositories.dart';
import '../lib/domain/collection_models.dart';
import '../lib/domain/daily_ledger.dart';
import '../lib/domain/modules.dart';
import '../lib/domain/person.dart';

int _pass = 0, _fail = 0;
void check(String name, bool cond, [String detail = '']) {
  if (cond) { _pass++; print('PASS  $name'); }
  else { _fail++; print('FAIL  $name  $detail'); }
}
void eq(String name, Object? a, Object? b) => check(name, a == b, '(got $a, want $b)');

DateTime d(int day) => dateOnly(2026, 11, day);
DateTime get nov1 => d(1);
DateTime get nov30 => d(30);

Future<void> main() async {
  var store = InMemoryStore();
  var persons = InMemoryPersonRepository(store);
  var ledger = InMemoryLedgerRepository(store);
  var daily = InMemoryDailyRepository(store);
  var coll = InMemoryCollectionRepository(store);
  var mod = InMemoryModuleRepository(store);

  // ---------- MFS ----------
  await mod.addMfsTransaction(provider: EntryModule.bkash, type: MfsTxType.cashIn, amountPoisha: takaToPoisha(10000), date: d(12));
  await mod.addMfsTransaction(provider: EntryModule.bkash, type: MfsTxType.cashOut, amountPoisha: takaToPoisha(3000), feePoisha: takaToPoisha(15), commissionPoisha: takaToPoisha(20), date: d(12));
  var balances = await mod.mfsBalances();
  eq('bkash balance = 10000-3000-15', balances[EntryModule.bkash], takaToPoisha(6985));
  final allEntries = await ledger.all();
  eq('MFS commission is income, not sale', commissionTotalPoisha(allEntries, category: 'MFS commission', from: nov1, to: nov30), takaToPoisha(20));

  await mod.transfer(from: EntryModule.bkash, to: EntryModule.nagad, amountPoisha: takaToPoisha(2000), date: d(12));
  balances = await mod.mfsBalances();
  eq('transfer out of bkash', balances[EntryModule.bkash], takaToPoisha(4985));
  eq('transfer into nagad', balances[EntryModule.nagad], takaToPoisha(2000));
  final totalAccounts = balances.values.fold<int>(0, (a, b) => a + b);
  eq('transfer never changes total money', totalAccounts, takaToPoisha(6985));

  // ---------- Recharge ----------
  await mod.setOperatorBalance('Grameenphone', takaToPoisha(5000));
  final r = await mod.recharge(operator: 'Grameenphone', number: '01712345678', amountPoisha: takaToPoisha(100), commissionBasisPoints: 280, date: d(12));
  eq('recharge stock deducted', await mod.operatorBalance('Grameenphone'), takaToPoisha(4900));
  eq('recharge commission 2.8% of 100', r.commissionPoisha, 280); // ৳2.80
  final entries2 = await ledger.all();
  eq('recharge commission booked as income', commissionTotalPoisha(entries2, category: 'Recharge commission', from: nov1, to: nov30), 280);
  eq('recharge sale booked under recharge module', entries2.where((e) => e.module == EntryModule.recharge).length, 1);
  var insufficient = false;
  try {
    await mod.recharge(operator: 'Robi', number: '01800000000', amountPoisha: takaToPoisha(50), commissionBasisPoints: 280, date: d(12));
  } on StateError { insufficient = true; }
  check('recharge without stock is refused', insufficient);

  // ---------- Personal separation (§14) ----------
  await persons.create(const Person(id: 'wife', name: 'Family', type: PersonType.family));
  final closingBefore = (await daily.summaryFor(d(12))).closingPoisha;
  await ledger.addEntry(LedgerEntry(id: 'pers1', date: d(12), direction: EntryDirection.out_,
      amountPoisha: takaToPoisha(500), module: EntryModule.personal, category: 'বাজার'));
  await ledger.addEntry(LedgerEntry(id: 'pers2', date: d(12), direction: EntryDirection.in_,
      amountPoisha: takaToPoisha(1000), module: EntryModule.personal, category: 'বেতন'));
  eq('personal entries do NOT move business closing', (await daily.summaryFor(d(12))).closingPoisha, closingBefore);
  final ps = personalSummary(await ledger.all(), from: nov1, to: nov30);
  eq('personal income', ps.incomePoisha, takaToPoisha(1000));
  eq('personal expense', ps.expensePoisha, takaToPoisha(500));
  eq('personal category breakdown', ps.expenseByCategory['বাজার'], takaToPoisha(500));
  await ledger.addEntry(LedgerEntry(id: 'fam1', date: d(12), direction: EntryDirection.out_,
      amountPoisha: takaToPoisha(1000), module: EntryModule.familyTransfer, personId: 'wife'));
  final bs = summarizeDay(await ledger.all(), d(12), openingPoisha: 0);
  eq('family transfer IS a business outflow', bs.totalOutPoisha >= takaToPoisha(1000), true);

  // ---------- Tokri Vara ----------
  await persons.create(const Person(id: 'jamal', name: 'Jamal', type: PersonType.renter));
  await mod.saveRental(const TokriRental(id: 'tok1', personId: 'jamal', tokriCount: 10, dailyRatePoisha: 4000)); // ৳40/tokri
  await mod.markAttendance('tok1', d(12), AttendanceStatus.present);
  await mod.markAttendance('tok1', d(13), AttendanceStatus.absent);
  await mod.markAttendance('tok1', d(14), AttendanceStatus.leave);
  eq('only the present day charges (10 x 40)', await mod.tokriDue('tok1', from: nov1, to: nov30), takaToPoisha(400));
  await mod.collectRent(rentalId: 'tok1', personId: 'jamal', amountPoisha: takaToPoisha(400), date: d(15));
  eq('rent collected, due zero', await mod.tokriDue('tok1', from: nov1, to: nov30), 0);
  eq('attendance re-mark overwrites', (await mod.attendanceOf('tok1', d(13)))?.status, AttendanceStatus.absent);
  await mod.markAttendance('tok1', d(13), AttendanceStatus.present);
  eq('re-marked day now charges too', await mod.tokriDue('tok1', from: nov1, to: nov30), takaToPoisha(400));

  // ---------- Somity separation ----------
  await persons.create(const Person(id: 'sita', name: 'Sita', type: PersonType.somityMember));
  await mod.addSomityMember('sita');
  eq('somity member registered', (await mod.somityMemberIds()).join(','), 'sita');
  await coll.saveSchedule(CollectionSchedule(
    id: 'sch_s1', personId: 'sita', expectedPoisha: takaToPoisha(100),
    type: ScheduleType.daily, startDate: d(1), effectiveFrom: d(1)));
  final before = await ledger.all();
  final collCountBefore = before.where((e) => e.module == EntryModule.collection).length;
  await coll.receivePayment(personId: 'sita', amountPoisha: takaToPoisha(100), date: d(12), ledgerModule: EntryModule.somity);
  final after = await ledger.all();
  eq('somity money booked as somity', after.where((e) => e.module == EntryModule.somity).length, 1);
  eq('shop collection module untouched', after.where((e) => e.module == EntryModule.collection).length, collCountBefore);
  eq('daily collection total includes somity (§14 view)', (await daily.summaryFor(d(12))).collectionPoisha >= takaToPoisha(100), true);

  // ---------- Snapshot / restore of module state ----------
  final restored = InMemoryStore.restore(store.snapshot());
  final mod2 = InMemoryModuleRepository(restored);
  eq('restore operator balance', await mod2.operatorBalance('Grameenphone'), takaToPoisha(4900));
  eq('restore rentals', (await mod2.rentals()).length, 1);
  eq('restore somity members', (await mod2.somityMemberIds()).join(','), 'sita');
  eq('restore recharge history', (await mod2.recharges()).length, 1);
  eq('restore tokri due (re-marked day)', await mod2.tokriDue('tok1', from: nov1, to: nov30), takaToPoisha(400));

  print('\n$_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('$_fail checks failed');
}
