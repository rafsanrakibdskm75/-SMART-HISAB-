/// Stage 8 verification — the owner's two-device question (2026-11-13):
/// both devices save the SAME record with DIFFERENT values at different
/// times (9:50 → ৳190, 10:50 → ৳200): which one is kept? And if the value
/// is the SAME at different times, what happens?
/// Plus the three sync bugs the question exposed in v1.0.1 (see
/// docs/SYNC_CONFLICTS.md).
library;

import '../lib/data/repositories/in_memory_repositories.dart';
import '../lib/data/sync/in_memory_sync_source.dart';
import '../lib/domain/sync_engine.dart';

int _pass = 0, _fail = 0;
void check(String name, bool ok) {
  if (ok) { _pass++; } else { _fail++; print('FAIL: $name'); }
}
void eq(String name, Object? got, Object? want) =>
    check('$name (got $got, want $want)', got == want);

int at(int h, int m) => DateTime(2026, 11, 13, h, m).millisecondsSinceEpoch;

SyncRecord balance(int poisha, int ms, {int version = 1, bool deleted = false}) =>
    SyncRecord(
      entity: 'operator_balances', id: 'Grameenphone', version: version,
      updatedAtMs: ms, isDeleted: deleted,
      payload: {'operator': 'Grameenphone', 'balancePoisha': poisha},
    );

Future<void> main() async {
  // ---- The owner's exact case: 9:50 → ৳190 vs 10:50 → ৳200, same record ----
  {
    // This device has the 9:50 edit (190) pending; the server has 10:50 (200).
    final plan = planSync([balance(19000, at(9, 50))], [balance(20000, at(10, 50))]);
    check('later edit wins: 190 is NOT pushed', plan.toPush.isEmpty);
    eq('later edit wins: 200 is applied', plan.toApply.single.payload['balancePoisha'], 20000);
    eq('losing edit leaves the queue', plan.superseded.single.payload['balancePoisha'], 19000);
  }
  {
    // Same facts, seen from the OTHER device (it holds the 10:50 edit).
    final plan = planSync([balance(20000, at(10, 50))], [balance(19000, at(9, 50))]);
    eq('other device: its 200 is pushed', plan.toPush.single.payload['balancePoisha'], 20000);
    check('other device: nothing overwritten locally', plan.toApply.isEmpty);
  }

  // ---- Same value, different times ----
  {
    final plan = planSync([balance(20000, at(9, 50))], [balance(20000, at(10, 50))]);
    check('same value: no push needed', plan.toPush.isEmpty);
    eq('same value: value stays 200', plan.toApply.single.payload['balancePoisha'], 20000);
    // Net effect is a no-op: applying the winner changes nothing, and the
    // deterministic op ids mean it can never be stored twice.
  }

  // ---- Tie rules, stated precisely ----
  {
    // Exactly the same time, same version, different values → remote
    // (the shared server copy) wins, so both devices converge identically.
    final plan = planSync([balance(19000, at(9, 50))], [balance(20000, at(9, 50))]);
    eq('exact tie: server copy wins', plan.toApply.single.payload['balancePoisha'], 20000);
  }
  {
    // Same time but this device edited TWICE (version 2) → local wins.
    final plan = planSync(
        [balance(19000, at(9, 50), version: 2)], [balance(20000, at(9, 50), version: 1)]);
    eq('tie + higher version wins', plan.toPush.single.payload['balancePoisha'], 19000);
  }
  {
    // Exact tie against a delete → the tombstone wins.
    final plan = planSync(
        [balance(19000, at(9, 50))], [balance(0, at(9, 50), deleted: true)]);
    check('exact tie: delete wins', plan.toApply.single.isDeleted);
  }
  {
    // But a strictly NEWER edit resurrects a record deleted earlier.
    final plan = planSync(
        [balance(19000, at(11, 0))], [balance(0, at(9, 50), deleted: true)]);
    eq('newer edit resurrects', plan.toPush.single.payload['balancePoisha'], 19000);
  }

  // ---- Different records are NOT a conflict: both survive ----
  {
    SyncRecord entry(String id, int poisha) => SyncRecord(
        entity: 'ledger_entries', id: id, version: 1, updatedAtMs: at(9, 50),
        payload: {'id': id, 'amountPoisha': poisha});
    final plan = planSync([entry('entry_A', 19000)], [entry('entry_B', 20000)]);
    eq('my new entry still pushes', plan.toPush.single.id, 'entry_A');
    eq('their new entry is applied too', plan.toApply.single.id, 'entry_B');
  }

  // ---- Bug: pushed ops never left the queue (opId format mismatch) ----
  {
    final store = InMemoryStore();
    final modules = InMemoryModuleRepository(store);
    await modules.setOperatorBalance('Grameenphone', 19000);
    final source = InMemorySyncSource(store);
    eq('one op pending', store.syncQueue.pendingCount, 1);
    source.markPushed(source.dirtyRecords(nowMs: 1));
    eq('markPushed actually clears it', store.syncQueue.pendingCount, 0);
  }

  // ---- Bug: records were stamped with SYNC time, not EDIT time ----
  {
    final store = InMemoryStore();
    final modules = InMemoryModuleRepository(store);
    await modules.setOperatorBalance('Robi', 5000);
    final source = InMemorySyncSource(store);
    final dirty = source.dirtyRecords(nowMs: 424242); // sync "happens" at a fake time
    check('stamp is the edit time, not the sync time',
        dirty.single.updatedAtMs != 424242 && dirty.single.updatedAtMs > 0);
    final op = store.syncQueue.pending.single;
    eq('stamp equals the op edit time', dirty.single.updatedAtMs, op.enqueuedAtMs);
  }

  // ---- Two real stores, end to end: later edit wins ----
  {
    final storeA = InMemoryStore();
    await InMemoryModuleRepository(storeA).setOperatorBalance('Grameenphone', 19000);
    // wait for the clock to tick so device B's edit is strictly later
    final tA = InMemorySyncSource(storeA).dirtyRecords(nowMs: 0).single.updatedAtMs;
    while (DateTime.now().toUtc().millisecondsSinceEpoch <= tA) {}
    final storeB = InMemoryStore();
    await InMemoryModuleRepository(storeB).setOperatorBalance('Grameenphone', 20000);
    final dirtyB = InMemorySyncSource(storeB).dirtyRecords(nowMs: 0);
    final dirtyA = InMemorySyncSource(storeA).dirtyRecords(nowMs: 0);
    final planFromA = planSync(dirtyA, dirtyB); // A syncs, sees B's record
    eq('end-to-end: B (later, 200) is the winner',
        planFromA.toApply.single.payload['balancePoisha'], 20000);
  }

  // ---- Settings records are part of sync at all (pull coverage) ----
  check('app_settings syncs', entityPushOrder.containsKey('app_settings'));

  print('verify_stage8: $_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('stage8 failures: $_fail');
}
