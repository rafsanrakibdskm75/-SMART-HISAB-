/// Stage 3 verification (plain Dart):
///   dart run tool/verify_stage3.dart
/// Covers Test B (offline collection + daily balance), schedule versioning
/// (§6), targeted overdue settlement (§4), holiday (§3 GREY), pause (§6),
/// advance payment, snapshot/restore of collection state, closed-day guard.
import '../lib/core/dhaka_time.dart';
import '../lib/core/money.dart';
import '../lib/data/repositories/in_memory_repositories.dart';
import '../lib/domain/collection_models.dart';
import '../lib/domain/person.dart';

int _pass = 0, _fail = 0;
void check(String name, bool cond, [String detail = '']) {
  if (cond) { _pass++; print('PASS  $name'); }
  else { _fail++; print('FAIL  $name  $detail'); }
}
void eq(String name, Object? a, Object? b) => check(name, a == b, '(got $a, want $b)');

DateTime d(int day) => dateOnly(2026, 11, day);

Future<void> main() async {
  var store = InMemoryStore();
  var persons = InMemoryPersonRepository(store);
  var coll = InMemoryCollectionRepository(store);
  var daily = InMemoryDailyRepository(store);

  await persons.create(const Person(id: 'rahim', name: 'Rahim', mobile: '01712345678'));
  await persons.create(const Person(id: 'karim', name: 'Karim', mobile: '01898765432'));

  await coll.saveSchedule(CollectionSchedule(
    id: 'sch_r1', personId: 'rahim', expectedPoisha: takaToPoisha(200),
    type: ScheduleType.daily, startDate: d(1), effectiveFrom: d(1)));
  await coll.saveSchedule(CollectionSchedule(
    id: 'sch_k1', personId: 'karim', expectedPoisha: takaToPoisha(500),
    type: ScheduleType.weekly, startDate: d(2), weekdays: {1}, effectiveFrom: d(2)));

  // Generation is idempotent
  var obs = await coll.ensureObligations('rahim', from: d(10), to: d(13));
  eq('generated Nov10-13', obs.length, 4);
  obs = await coll.ensureObligations('rahim', from: d(10), to: d(13));
  eq('regeneration adds nothing', (await coll.obligationsFor('rahim')).length, 4);
  final karimObs = await coll.ensureObligations('karim', from: d(1), to: d(30));
  eq('Karim Mondays in Nov', karimObs.length, 5);

  // Test B: offline collection lands in the daily ledger balance
  final rB = await coll.receivePayment(personId: 'rahim', amountPoisha: takaToPoisha(200), date: d(12));
  eq('B applied fully', rB.appliedPoisha, 20000);
  eq('B status paid', rB.statusAfter, CollectionStatus.paid);
  eq('B daily collection total', (await daily.summaryFor(d(12))).collectionPoisha, 20000);
  final dash12 = await coll.dashboard(today: d(12));
  eq('B dashboard paid list', dash12.paidPersonIds.join(','), 'rahim');
  eq('B dashboard expected (Karim not scheduled Thu)', dash12.totalExpectedPoisha, 20000);

  // Partial payments via the repository (Test D at repo level)
  await coll.receivePayment(personId: 'rahim', amountPoisha: takaToPoisha(100), date: d(14));
  final rD = await coll.receivePayment(personId: 'rahim', amountPoisha: takaToPoisha(50), date: d(14));
  eq('D status partial', rD.statusAfter, CollectionStatus.partial);
  final pays = await coll.paymentsFor('rahim');
  eq('D payment records kept separately', pays.length, 3);
  eq('D original amounts kept', pays.map((p) => p.amountPoisha).toSet().containsAll({20000, 10000, 5000}), true);

  // Missed days stay separate: Nov 10, 11 and 13 are each their own due (§4)
  var summary14 = await coll.summaryFor('rahim', today: d(14));
  eq('missed Nov10+11+13 overdue, each separate', summary14.overduePoisha, 60000);
  eq('missed Nov14 partial remaining also counted', summary14.todayRemainingPoisha, 5000);
  final rSettle = await coll.receivePayment(personId: 'rahim', amountPoisha: takaToPoisha(200), date: d(14), targetDate: d(13));
  eq('settle applied to Nov13 obligation', rSettle.appliedPoisha, 20000);
  check('allocation points at Nov13', store.allocations.any((a) => a.paymentId == rSettle.payment.id && a.obligationId == 'rahim_2026-11-13'));
  summary14 = await coll.summaryFor('rahim', today: d(14));
  eq('Nov13 cleared; Nov10+11 still overdue', summary14.overduePoisha, 40000);

  // Schedule change applies forward only (§6)
  await coll.saveSchedule(CollectionSchedule(
    id: 'sch_r2', personId: 'rahim', expectedPoisha: takaToPoisha(300),
    type: ScheduleType.daily, startDate: d(1), effectiveFrom: d(15)));
  final obs2 = await coll.ensureObligations('rahim', from: d(14), to: d(16));
  eq('Nov14 keeps old amount 200', obs2.firstWhere((o) => o.date == d(14)).expectedPoisha, 20000);
  eq('Nov15 uses new amount 300', obs2.firstWhere((o) => o.date == d(15)).expectedPoisha, 30000);
  eq('Nov16 uses new amount 300', obs2.firstWhere((o) => o.date == d(16)).expectedPoisha, 30000);

  // Holiday = GREY and never overdue
  await coll.markHoliday('rahim', d(16), holiday: true);
  final nov16 = (await coll.obligationsFor('rahim')).firstWhere((o) => o.date == d(16));
  eq('holiday status GREY', nov16.status(today: d(17)), CollectionStatus.notScheduled);

  // Advance payment + overpay credit
  await coll.ensureObligations('rahim', from: d(17), to: d(19));
  final rAdv = await coll.receivePayment(personId: 'rahim', amountPoisha: takaToPoisha(300), date: d(17), targetDate: d(18));
  eq('advance status BLUE', rAdv.statusAfter, CollectionStatus.advance);
  final rOver = await coll.receivePayment(personId: 'rahim', amountPoisha: takaToPoisha(350), date: d(17), targetDate: d(19));
  eq('overpay applied capped at the day', rOver.appliedPoisha, 30000);
  eq('overpay excess is advance credit', rOver.advanceCreditPoisha, 5000);

  // Overdue report at Nov 17: Nov10 200 + Nov11 200 + Nov14 partial 50 + Nov15 300;
  // Nov13 settled, Nov16 holiday — neither appears.
  final report = await coll.overdue(today: d(17));
  final rahimReport = report.firstWhere((r) => r.personId == 'rahim');
  eq('overdue total 200+200+50+300', rahimReport.totalPoisha, 75000);
  eq('overdue dates separate', rahimReport.items.map((o) => dateKey(o.date)).join(','), '2026-11-10,2026-11-11,2026-11-14,2026-11-15');
  eq('overdue kind = partial present', rahimReport.kind.name, 'partial');

  // Pause stops future generation; resume restores it
  await coll.setPaused('sch_k1', paused: true);
  await coll.ensureObligations('karim', from: dateOnly(2026, 12, 1), to: dateOnly(2026, 12, 31));
  eq('paused: no December obligations', (await coll.obligationsFor('karim')).length, 5);
  await coll.setPaused('sch_k1', paused: false);

  // Snapshot / restore keeps collection state
  final snap = store.snapshot();
  final restored = InMemoryStore.restore(snap);
  final coll2 = InMemoryCollectionRepository(restored);
  eq('restore obligations', (await coll2.obligationsFor('rahim')).length, (await coll.obligationsFor('rahim')).length);
  eq('restore payments', (await coll2.paymentsFor('rahim')).length, (await coll.paymentsFor('rahim')).length);
  eq('restore overdue total', (await coll2.summaryFor('rahim', today: d(17))).overduePoisha, 75000);

  // Closed day blocks collection posting too
  await daily.closeDay(d(12), closedBy: 'owner');
  var threw = false;
  try {
    await coll.receivePayment(personId: 'rahim', amountPoisha: 100, date: d(12), targetDate: d(15));
  } on StateError { threw = true; }
  check('closed day blocks payment posting', threw);

  print('\n$_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('$_fail checks failed');
}
