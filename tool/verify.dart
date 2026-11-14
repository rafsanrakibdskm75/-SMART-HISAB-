/// Plain-Dart verification of the Smart Hisab core rules (no packages needed):
///   dart run tool/verify.dart
/// Covers Master Prompt tests C (missed day), D (partial), H (daily rollover)
/// at unit level, plus money, schedules, advance colour, and sync idempotency.
import '../lib/core/money.dart';
import '../lib/core/dhaka_time.dart';
import '../lib/domain/collection_models.dart';
import '../lib/domain/collection_engine.dart';
import '../lib/domain/daily_ledger.dart';
import '../lib/domain/sync_queue.dart';

int _pass = 0, _fail = 0;
void check(String name, bool cond, [String detail = '']) {
  if (cond) { _pass++; print('PASS  $name'); }
  else { _fail++; print('FAIL  $name  $detail'); }
}
void eq(String name, Object? a, Object? b) => check(name, a == b, '(got $a, want $b)');

CollectionSchedule rahimDaily() => CollectionSchedule(
      id: 'sch_rahim', personId: 'rahim', expectedPoisha: takaToPoisha(200),
      type: ScheduleType.daily, startDate: dateOnly(2026, 11, 1),
      effectiveFrom: dateOnly(2026, 11, 1));

void main() {
  // ---- Money: exact parsing, no floats, lakh grouping, Bangla digits ----
  eq('money parse 200', takaStringToPoisha('200'), 20000);
  eq('money parse 0.10+0.20 exact', takaStringToPoisha('0.10') + takaStringToPoisha('0.20'), 30);
  eq('money parse bangla digits', takaStringToPoisha('২০০.৫০'), 20050);
  eq('money format lakh', formatBdt(10000000), '৳1,00,000');
  eq('money format frac', formatBdt(20050), '৳200.50');
  eq('money format bangla', formatBdt(30000, banglaDigits: true), '৳৩০০');

  // ---- Dhaka date bucketing ----
  eq('dhaka date UTC 19:30 -> next day', dateKey(dhakaDateOf(DateTime.utc(2026, 11, 12, 19, 30))), '2026-11-13');
  eq('dhaka date UTC 17:00 -> same day', dateKey(dhakaDateOf(DateTime.utc(2026, 11, 12, 17, 0))), '2026-11-12');

  final nov12 = dateOnly(2026, 11, 12), nov13 = dateOnly(2026, 11, 13);

  // ---- Test C: missed day is NEVER merged ----
  {
    final obs = generateObligations(rahimDaily(), from: nov12, to: nov13);
    eq('C obligations generated', obs.length, 2);
    final r = applyPayment(obs, CollectionPayment(id: 'p1', personId: 'rahim', amountPoisha: takaToPoisha(200), date: nov13));
    check('C payment ok', r.ok);
    final s = summarizePerson(obs, today: nov13);
    eq('C today received', s.todayReceivedPoisha, 20000);
    eq('C yesterday still overdue (separate)', s.overduePoisha, 20000);
    eq('C missed days', s.missedDays, 1);
    eq('C overdue listed per-date', s.overdueItems.length, 1);
    eq('C overdue date is 12 Nov', dateKey(s.overdueItems.first.date), '2026-11-12');
    // Settling the exact overdue date later (§4):
    final r2 = applyPayment(obs, CollectionPayment(id: 'p2', personId: 'rahim', amountPoisha: takaToPoisha(200), date: nov13), targetDate: nov12);
    check('C settle overdue ok', r2.ok);
    eq('C overdue cleared after targeted settle', summarizePerson(obs, today: nov13).overduePoisha, 0);
  }

  // ---- Test D: partial payments accumulate, originals kept ----
  {
    final obs = generateObligations(rahimDaily(), from: nov12, to: nov12);
    applyPayment(obs, CollectionPayment(id: 'p1', personId: 'rahim', amountPoisha: takaToPoisha(100), date: nov12));
    var s = summarizePerson(obs, today: nov12);
    eq('D remaining after 100', s.todayRemainingPoisha, 10000);
    eq('D status partial (YELLOW)', obs.first.status(today: nov12), CollectionStatus.partial);
    applyPayment(obs, CollectionPayment(id: 'p2', personId: 'rahim', amountPoisha: takaToPoisha(50), date: nov12));
    s = summarizePerson(obs, today: nov12);
    eq('D remaining after +50', s.todayRemainingPoisha, 5000);
    eq('D total received kept', obs.first.paidPoisha, 15000);
  }

  // ---- Advance: paying tomorrow today shows BLUE, excess is credit not merged ----
  {
    final obs = generateObligations(rahimDaily(), from: nov12, to: nov13);
    final r = applyPayment(obs, CollectionPayment(id: 'p9', personId: 'rahim', amountPoisha: takaToPoisha(250), date: nov12), targetDate: nov13);
    eq('advance applied to target day only', r.allocations.single.amountPoisha, 20000);
    eq('advance excess returned as credit', r.advanceCreditPoisha, 5000);
    eq('advance status BLUE', obs.last.status(today: nov12), CollectionStatus.advance);
    eq('today untouched by advance', obs.first.paidPoisha, 0);
  }

  // ---- Schedules: weekly / monthly clamping / holiday grey ----
  {
    final weekly = CollectionSchedule(id: 'w', personId: 'x', expectedPoisha: 10000, type: ScheduleType.weekly,
        startDate: dateOnly(2026, 11, 2), weekdays: {1}, effectiveFrom: dateOnly(2026, 11, 2)); // Mondays
    final obs = generateObligations(weekly, from: dateOnly(2026, 11, 1), to: dateOnly(2026, 11, 30));
    eq('weekly Mondays in Nov 2026', obs.length, 5);
    final monthly = CollectionSchedule(id: 'm', personId: 'x', expectedPoisha: 10000, type: ScheduleType.monthly,
        startDate: dateOnly(2026, 1, 31), dayOfMonth: 31, effectiveFrom: dateOnly(2026, 1, 31));
    final feb = generateObligations(monthly, from: dateOnly(2026, 2, 1), to: dateOnly(2026, 2, 28));
    eq('monthly 31st clamps to Feb 28', feb.length == 1 && dateKey(feb.first.date) == '2026-02-28', true);
    final h = generateObligations(rahimDaily(), from: nov12, to: nov12)..first.isHoliday = true;
    eq('holiday status GREY', h.first.status(today: nov12), CollectionStatus.notScheduled);
  }

  // ---- Test H: daily rollover — closing becomes opening, history kept ----
  {
    final entries = <LedgerEntry>[
      LedgerEntry(id: 'e1', date: nov12, direction: EntryDirection.in_, amountPoisha: takaToPoisha(5000), module: EntryModule.income),
      LedgerEntry(id: 'e2', date: nov12, direction: EntryDirection.out_, amountPoisha: takaToPoisha(1000), module: EntryModule.expense),
      LedgerEntry(id: 'e3', date: nov12, direction: EntryDirection.in_, amountPoisha: takaToPoisha(2000), module: EntryModule.collection),
    ];
    final day12 = summarizeDay(entries, nov12, openingPoisha: 0);
    eq('H 12 Nov income total', day12.totalInPoisha, 700000);
    eq('H 12 Nov closing', day12.closingPoisha, 600000);
    eq('H 13 Nov opening = 12 Nov closing', openingBalanceFor(entries, nov13), 600000);
    eq('H history still readable', entries.where((e) => dateKey(e.date) == '2026-11-12').length, 3);
  }

  // ---- Test I (logic level): sync retry can never duplicate ----
  {
    final q = SyncQueue();
    final a = q.enqueue(recordId: 'pay_1', localVersion: 1, entity: 'payments');
    final b = q.enqueue(recordId: 'pay_1', localVersion: 1, entity: 'payments');
    eq('I duplicate enqueue returns same op', a.opId, b.opId);
    eq('I queue holds one op', q.totalCount, 1);
    eq('validation rejects zero amount', q.validateFinancialRecord(amountPoisha: 0, userId: 'u1', date: nov12) != null, true);
    eq('validation accepts good record', q.validateFinancialRecord(amountPoisha: 100, userId: 'u1', date: nov12), null);
  }

  // ---- Today's Collection dashboard buckets (§7) ----
  {
    final karim = CollectionSchedule(id: 'sch_karim', personId: 'karim', expectedPoisha: takaToPoisha(300),
        type: ScheduleType.daily, startDate: dateOnly(2026, 11, 1), effectiveFrom: dateOnly(2026, 11, 1));
    final byPerson = <String, List<CollectionObligation>>{
      'rahim': generateObligations(rahimDaily(), from: nov12, to: nov13),
      'karim': generateObligations(karim, from: nov13, to: nov13),
    };
    applyPayment(byPerson['rahim']!, CollectionPayment(id: 'p1', personId: 'rahim', amountPoisha: takaToPoisha(200), date: nov13));
    applyPayment(byPerson['karim']!, CollectionPayment(id: 'p2', personId: 'karim', amountPoisha: takaToPoisha(100), date: nov13));
    final d = todayDashboard(byPerson, today: nov13);
    eq('dashboard expected', d.totalExpectedPoisha, 50000);
    eq('dashboard received', d.totalReceivedPoisha, 30000);
    eq('dashboard overdue separate', d.totalOverduePoisha, 20000);
    eq('dashboard paid list', d.paidPersonIds.join(','), 'rahim');
    eq('dashboard partial list', d.partialPersonIds.join(','), 'karim');
  }

  print('\n$_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('$_fail checks failed');
}
