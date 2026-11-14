/// Stage 9 verification — the owner's follow-up (2026-11-13): BOTH devices
/// enter data at the SAME time under the SAME NAME. At the end of the day,
/// which data is dropped and which is kept?
library;

import '../lib/core/id_gen.dart';
import '../lib/data/repositories/in_memory_repositories.dart';
import '../lib/data/sync/in_memory_sync_source.dart';
import '../lib/domain/daily_ledger.dart';
import '../lib/domain/person.dart';
import '../lib/domain/sync_engine.dart';

int _pass = 0, _fail = 0;
void check(String name, bool ok) {
  if (ok) { _pass++; } else { _fail++; print('FAIL: $name'); }
}
void eq(String name, Object? got, Object? want) =>
    check('$name (got $got, want $want)', got == want);

SyncRecord bal(String id, int poisha, int ms, {bool deleted = false}) => SyncRecord(
    entity: 'operator_balances', id: id, version: 1, updatedAtMs: ms,
    isDeleted: deleted, payload: {'operator': id, 'balancePoisha': poisha});

Future<void> main() async {
  final sameMs = DateTime(2026, 11, 13, 10, 0).millisecondsSinceEpoch;
  final day = DateTime.utc(2026, 11, 13);

  // ---- 1) Same time, same NAME, NEW person on both devices → BOTH kept ----
  {
    final storeA = InMemoryStore();
    final storeB = InMemoryStore();
    // Exactly what PersonController does on each phone:
    await InMemoryPersonRepository(storeA)
        .create(Person(id: IdGen.next('person'), name: 'Rahim', mobile: '01712345678'));
    await InMemoryPersonRepository(storeB)
        .create(Person(id: IdGen.next('person'), name: 'Rahim', mobile: '01712345678'));
    final idA = storeA.persons.keys.single;
    final idB = storeB.persons.keys.single;
    check('same name+mobile still gets different IDs per device', idA != idB);

    // Both sync; A pulls B's person afterwards.
    final srcA = InMemorySyncSource(storeA);
    final dirtyB = InMemorySyncSource(storeB).dirtyRecords(nowMs: 0);
    final plan = planSync(srcA.dirtyRecords(nowMs: 0), dirtyB);
    eq('A keeps its own Rahim (pushes)', plan.toPush.length, 1);
    eq('A also takes B\'s Rahim (applies)', plan.toApply.length, 1);
    check('nothing is dropped', plan.superseded.isEmpty);
    srcA.markPushed(plan.toPush);
    srcA.applyPulled(plan.toApply);
    eq('at day end A shows BOTH Rahims', storeA.persons.length, 2);
    check('both carry the same name',
        storeA.persons.values.every((p) => p.name == 'Rahim'));
    // The app deliberately does NOT merge people by name: two real
    // customers can share a name, and merging money by name would be
    // dangerous. The owner deletes a true duplicate manually (soft delete).
  }

  // ---- 2) SAME record, SAME millisecond, different values → first sync wins ----
  {
    final a = bal('Grameenphone', 19000, sameMs);
    final b = bal('Grameenphone', 20000, sameMs);
    // A syncs first: server takes A. B syncs next and meets A's copy.
    final planB = planSync([b], [a]);
    check('second syncer: its edit is dropped (superseded)',
        planB.superseded.single == b && planB.toPush.isEmpty);
    eq('second syncer ends with the first syncer\'s value',
        planB.toApply.single.payload['balancePoisha'], 19000);
    // Reverse the order and the winner reverses — the rule is purely
    // "exact tie → the copy already on the server wins".
    final planA = planSync([a], [b]);
    eq('if B had synced first, 200 would win',
        planA.toApply.single.payload['balancePoisha'], 20000);
  }

  // ---- 3) SAME record, SAME time, SAME value → kept once ----
  {
    final plan = planSync(
        [bal('Grameenphone', 20000, sameMs)], [bal('Grameenphone', 20000, sameMs)]);
    check('same value tie: nothing pushed', plan.toPush.isEmpty);
    eq('same value tie: one copy applied', plan.toApply.length, 1);
  }

  // ---- 4) SAME time, one side DELETES → delete wins from both sides ----
  {
    final edit = bal('Grameenphone', 20000, sameMs);
    final tomb = bal('Grameenphone', 0, sameMs, deleted: true);
    final p1 = planSync([edit], [tomb]);
    check('edit meets tombstone: tombstone applied', p1.toApply.single.isDeleted);
    final p2 = planSync([tomb], [edit]);
    check('tombstone meets edit: tombstone pushed',
        p2.toPush.single.isDeleted && p2.toApply.isEmpty);
  }

  // ---- 5) দিন শেষে: both devices close the same day ----
  {
    // Money ENTRIES from both devices always all survive (different IDs),
    // and day totals are recomputed from entries — so the day-end total
    // is the two devices combined, whichever closing snapshot won.
    final storeA = InMemoryStore();
    final storeB = InMemoryStore();
    final ledgerA = InMemoryLedgerRepository(storeA);
    final ledgerB = InMemoryLedgerRepository(storeB);
    await ledgerA.addEntry(LedgerEntry(
        id: IdGen.next('entry'), date: day, direction: EntryDirection.in_,
        amountPoisha: 19000, module: EntryModule.income));
    await ledgerB.addEntry(LedgerEntry(
        id: IdGen.next('entry'), date: day, direction: EntryDirection.in_,
        amountPoisha: 20000, module: EntryModule.income));
    await InMemoryDailyRepository(storeA).closeDay(day, closedBy: 'deviceA');
    await InMemoryDailyRepository(storeB).closeDay(day, closedBy: 'deviceB');

    // A pulls B's records: B's entry applies; B's closing snapshot is the
    // same record id as A's (closing_<date>) so it is not blindly applied —
    // and it does not need to be, because summaries are recomputed live.
    final srcA = InMemorySyncSource(storeA);
    srcA.markPushed(srcA.dirtyRecords(nowMs: 0));
    final pulled = InMemorySyncSource(storeB).dirtyRecords(nowMs: 0);
    srcA.applyPulled(pulled);
    eq('both devices\' entries survive on A', storeA.entries.length, 2);
    final summary = await InMemoryDailyRepository(storeA).summaryFor(day);
    eq('day-end total = 190 + 200 combined', summary.totalInPoisha, 39000);
  }

  print('verify_stage9: $_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('stage9 failures: $_fail');
}
