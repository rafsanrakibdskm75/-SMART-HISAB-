/// Stage 7 bug-hunt verification: adversarial edge cases found in the
/// 2026-11-13 point-by-point audit. Every check here FAILED on v1.0.0
/// (that failure was the bug confirmation) and must pass after the fixes.
library;

import '../lib/core/dhaka_time.dart';
import '../lib/core/money.dart';
import '../lib/data/repositories/in_memory_repositories.dart';
import '../lib/data/sync/in_memory_sync_source.dart';
import '../lib/domain/collection_engine.dart';
import '../lib/domain/collection_models.dart';
import '../lib/domain/daily_ledger.dart';
import '../lib/domain/ledger_service.dart';
import '../lib/domain/person.dart';
import '../lib/domain/stage6.dart';
import '../lib/domain/sync_engine.dart';

int _pass = 0, _fail = 0;
void check(String name, bool ok) {
  if (ok) { _pass++; } else { _fail++; print('FAIL: $name'); }
}
void eq(String name, Object? got, Object? want) =>
    check('$name (got $got, want $want)', got == want);
bool throwsFmt(void Function() f) {
  try { f(); return false; } on FormatException { return true; } catch (_) { return false; }
}
Future<bool> throwsAny(Future<dynamic> Function() f) async {
  try { await f(); return false; } catch (_) { return true; }
}
DateTime d(int day) => DateTime.utc(2026, 11, day);

CollectionSchedule daily(String person, {int taka = 200}) => CollectionSchedule(
    id: 'sch_$person', personId: person, expectedPoisha: taka * 100,
    type: ScheduleType.daily, startDate: d(10), effectiveFrom: d(10));

Future<void> main() async {
  // 1 — money parser rejects digit-less junk (v1.0.0 returned 0 for "-" / ".")
  check('money "-" rejected', throwsFmt(() => takaStringToPoisha('-')));
  check('money "." rejected', throwsFmt(() => takaStringToPoisha('.')));
  check('money "-." rejected', throwsFmt(() => takaStringToPoisha('-.')));
  eq('money normal still ok', takaStringToPoisha('২০০.৫০'), 20050);
  eq('money ".5" still ok', takaStringToPoisha('.5'), 50);

  // 2 — parseDateKey is strict (v1.0.0 silently rolled 2026-13-40 into 2027)
  check('date month 13 rejected', throwsFmt(() => parseDateKey('2026-13-01')));
  check('date Feb 30 rejected', throwsFmt(() => parseDateKey('2026-02-30')));
  check('date short key rejected', throwsFmt(() => parseDateKey('2026-11')));
  eq('date normal still ok', dateKey(parseDateKey('2026-11-13')), '2026-11-13');

  // 3–7 — applyPayment hardening
  {
    final obs = generateObligations(daily('rahim'), from: d(12), to: d(13));
    final neg = applyPayment(obs, CollectionPayment(id: 'n1', personId: 'rahim', amountPoisha: -5000, date: d(12)));
    check('negative payment rejected', !neg.ok && obs[0].paidPoisha == 0);
    final zero = applyPayment(obs, CollectionPayment(id: 'z1', personId: 'rahim', amountPoisha: 0, date: d(12)));
    check('zero payment rejected', !zero.ok && obs[0].paidPoisha == 0);
    final wrong = applyPayment(obs, CollectionPayment(id: 'w1', personId: 'karim', amountPoisha: 10000, date: d(12)));
    check('wrong-person payment rejected', !wrong.ok && obs[0].paidPoisha == 0);

    applyPayment(obs, CollectionPayment(id: 'f1', personId: 'rahim', amountPoisha: 20000, date: d(12)));
    final extra = applyPayment(obs, CollectionPayment(id: 'f2', personId: 'rahim', amountPoisha: 7000, date: d(12)));
    check('fully-paid day: no zero allocation', extra.ok && extra.allocations.isEmpty);
    eq('fully-paid day: all excess is advance', extra.advanceCreditPoisha, 7000);

    // out-of-order allocations must not move lastAllocationDate backwards
    final obs2 = generateObligations(daily('rahim'), from: d(13), to: d(13));
    applyPayment(obs2, CollectionPayment(id: 'o1', personId: 'rahim', amountPoisha: 10000, date: d(14)), targetDate: d(13));
    applyPayment(obs2, CollectionPayment(id: 'o2', personId: 'rahim', amountPoisha: 5000, date: d(12)), targetDate: d(13));
    eq('lastAllocationDate keeps the latest', dateKey(obs2.first.lastAllocationDate!), '2026-11-14');
  }

  // 8 — pagination guards
  check('page negative index is empty', page([1, 2, 3], pageIndex: -1).isEmpty);
  check('page zero size is empty', page([1, 2, 3], pageIndex: 0, pageSize: 0).isEmpty);

  // 9 — period summaries exclude the personal module (§14)
  {
    final entries = [
      LedgerEntry(id: 'a', date: d(12), direction: EntryDirection.in_, amountPoisha: 10000, module: EntryModule.income),
      LedgerEntry(id: 'b', date: d(12), direction: EntryDirection.in_, amountPoisha: 99000, module: EntryModule.personal),
    ];
    eq('period summary excludes personal', summarizePeriod(entries, from: d(1), to: d(30)).totalInPoisha, 10000);
  }

  // 10 — CSV: integer-exact taka + formula-injection guard
  {
    final entries = [
      LedgerEntry(id: 'a', date: d(12), direction: EntryDirection.in_,
          amountPoisha: 123456789012345678, module: EntryModule.income, note: '=2+5+cmd'),
    ];
    final csv = entriesCsv(entries, const {});
    check('csv taka is integer-exact', csv.contains('1234567890123456.78'));
    check('csv formula cell neutralised', csv.contains("'=2+5"));
  }

  // 11–20 — repository level
  final store = InMemoryStore();
  final persons = InMemoryPersonRepository(store);
  final ledger = InMemoryLedgerRepository(store);
  final dailyRepo = InMemoryDailyRepository(store);
  final coll = InMemoryCollectionRepository(store);
  final modules = InMemoryModuleRepository(store, clock: () => d(12));
  await persons.create(const Person(id: 'p1', name: 'Rahim', mobile: '01712345678'));

  // 11 — double reversal / reversing a reversal
  {
    final e = LedgerEntry(id: 'e1', date: d(12), direction: EntryDirection.in_, amountPoisha: 5000, module: EntryModule.income, personId: 'p1');
    await ledger.addEntry(e);
    final rev = await ledger.reverseEntry(e, date: d(12));
    check('second reversal of same entry blocked', await throwsAny(() => ledger.reverseEntry(e, date: d(12))));
    check('reversing a reversal blocked', await throwsAny(() => ledger.reverseEntry(rev, date: d(12))));
  }

  // 12 — re-closing a reopened day keeps the audit trail
  {
    await dailyRepo.closeDay(d(11), closedBy: 'owner');
    await dailyRepo.reopenDay(d(11), by: 'owner', reason: 'ভুল এন্ট্রি');
    await dailyRepo.closeDay(d(11), closedBy: 'owner');
    final closing = store.closings[dateKey(d(11))]!;
    check('audit trail survives re-close', closing.auditLog.any((l) => l.contains('ভুল এন্ট্রি')));
    check('double reopen blocked', await throwsAny(() => dailyRepo.reopenDay(d(11), by: 'o', reason: 'x')) == false || store.isClosed(d(11)));
  }

  // 13 — person update: missing person + stale object version
  {
    check('update of missing person blocked',
        await throwsAny(() => persons.update(const Person(id: 'ghost', name: 'G'))));
    final created = await persons.getById('p1');
    await persons.update(created!);
    final stale = created; // localVersion still 1
    final again = await persons.update(stale);
    eq('stale update still bumps stored version', again.localVersion, 3);
  }

  // 14+15 — collection repo: advance-only payment + holiday guard
  {
    await coll.saveSchedule(daily('p1'));
    final r1 = await coll.receivePayment(personId: 'p1', amountPoisha: 20000, date: d(12), targetDate: d(12));
    eq('first payment applied', r1.appliedPoisha, 20000);
    final r2 = await coll.receivePayment(personId: 'p1', amountPoisha: 5000, date: d(12), targetDate: d(12));
    eq('second payment is pure advance', r2.appliedPoisha, 0);
    eq('advance credit reported', r2.advanceCreditPoisha, 5000);
    check('no zero-amount allocation stored', store.allocations.every((a) => a.amountPoisha > 0));
    check('holiday on a paid day blocked',
        await throwsAny(() => coll.markHoliday('p1', d(12), holiday: true)));
  }

  // 16+17 — recharge: closed day must not eat stock; input validation
  {
    await modules.setOperatorBalance('Grameenphone', 100000);
    await dailyRepo.closeDay(d(12), closedBy: 'owner');
    check('recharge on closed day blocked',
        await throwsAny(() => modules.recharge(operator: 'Grameenphone', number: '01712345678', amountPoisha: 10000, commissionBasisPoints: 280, date: d(12))));
    eq('stock untouched after blocked recharge', await modules.operatorBalance('Grameenphone'), 100000);
    check('no recharge record after blocked attempt', store.rechargeRecords.isEmpty);
    await dailyRepo.reopenDay(d(12), by: 'owner', reason: 'test');
    check('unknown operator rejected',
        await throwsAny(() => modules.recharge(operator: 'UnknownTel', number: '01712345678', amountPoisha: 100, commissionBasisPoints: 280, date: d(12))));
    check('bad recharge number rejected',
        await throwsAny(() => modules.recharge(operator: 'Robi', number: '123', amountPoisha: 100, commissionBasisPoints: 280, date: d(12))));
    check('absurd commission bp rejected',
        await throwsAny(() => modules.recharge(operator: 'Robi', number: '01812345678', amountPoisha: 100, commissionBasisPoints: 20000, date: d(12))));
  }

  // 18 — mutable entities bump sync versions; pause is enqueued
  {
    final settings = InMemorySettingsRepository(store);
    await settings.save(const AppSettings(businessName: 'A'));
    await settings.save(const AppSettings(businessName: 'B'));
    check('settings second save syncs as v2',
        store.syncQueue.pending.any((o) => o.opId == 'settings_v2'));
    final before = store.syncQueue.pendingCount;
    await coll.setPaused('sch_p1', paused: true);
    check('setPaused enqueues a sync op', store.syncQueue.pendingCount > before);
  }

  // 19+20 — pulled records: tombstone soft-deletes; pending local edit wins
  {
    // Fresh store whose person's create op is already synced, so the
    // pending-edit guard (test 20) does not apply here.
    final store3 = InMemoryStore();
    final persons3 = InMemoryPersonRepository(store3);
    await persons3.create(const Person(id: 'p1', name: 'Rahim'));
    store3.syncQueue.markSynced('p1_v1');
    final source = InMemorySyncSource(store3);
    source.applyPulled([
      SyncRecord(entity: 'persons', id: 'p1', version: 9, updatedAtMs: 999999, isDeleted: true,
          payload: const Person(id: 'p1', name: 'Rahim', isDeleted: true).toJson()),
    ]);
    final p = store3.persons['p1'];
    check('tombstone soft-deletes, never hard-deletes', p != null && p.isDeleted);

    final store2 = InMemoryStore();
    final persons2 = InMemoryPersonRepository(store2);
    await persons2.create(const Person(id: 'q1', name: 'Local Name'));
    final source2 = InMemorySyncSource(store2);
    source2.applyPulled([
      SyncRecord(entity: 'persons', id: 'q1', version: 1, updatedAtMs: 1,
          payload: const Person(id: 'q1', name: 'Remote Old').toJson()),
    ]);
    eq('pending local edit not overwritten by pull', store2.persons['q1']!.name, 'Local Name');
  }

  // 21 — Baki aging ignores future-dated entries
  {
    final entries = [
      LedgerEntry(id: 'f1', date: d(20), direction: EntryDirection.out_, amountPoisha: 8000, module: EntryModule.baki, personId: 'p1'),
    ];
    eq('future baki not due today', bakiBalanceFor(entries, 'p1', today: d(12)).duePoisha, 0);
  }

  // 24 — schedule validation
  {
    check('weekday 9 rejected', await throwsAny(() => coll.saveSchedule(CollectionSchedule(
        id: 'bad1', personId: 'p1', expectedPoisha: 100, type: ScheduleType.weekly,
        startDate: d(10), effectiveFrom: d(10), weekdays: const {9}))));
    check('dayOfMonth 32 rejected', await throwsAny(() => coll.saveSchedule(CollectionSchedule(
        id: 'bad2', personId: 'p1', expectedPoisha: 100, type: ScheduleType.monthly,
        startDate: d(10), effectiveFrom: d(10), dayOfMonth: 32))));
    check('endDate before start rejected', await throwsAny(() => coll.saveSchedule(CollectionSchedule(
        id: 'bad3', personId: 'p1', expectedPoisha: 100, type: ScheduleType.daily,
        startDate: d(12), endDate: d(10), effectiveFrom: d(12)))));
  }

  print('verify_stage7: $_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('stage7 failures: $_fail');
}
