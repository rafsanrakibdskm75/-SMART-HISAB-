/// Stage 5 verification (plain Dart):
///   dart run tool/verify_stage5.dart
/// Tests E (offline data syncs when back online), F (interrupted sync
/// retries safely), I (a record can never upload twice) at the engine
/// level with an in-memory fake remote, plus the conflict policy and
/// backoff schedule. Live Firestore transport needs the owner's own
/// Firebase project (docs/FIREBASE_SETUP.md) and is verified on device.
import '../lib/domain/sync_engine.dart';

int _pass = 0, _fail = 0;
void check(String name, bool cond, [String detail = '']) {
  if (cond) { _pass++; print('PASS  $name'); }
  else { _fail++; print('FAIL  $name  $detail'); }
}
void eq(String name, Object? a, Object? b) => check(name, a == b, '(got $a, want $b)');

SyncRecord rec(String entity, String id, int version, int t, {bool deleted = false}) =>
    SyncRecord(entity: entity, id: id, version: version, updatedAtMs: t, isDeleted: deleted, payload: {'id': id});

/// In-memory stand-in for Firestore: stores records and remembers every
/// applied opId, exactly like the real adapter's idempotent writes.
class FakeRemote {
  final Map<String, SyncRecord> records = {};
  final Set<String> appliedOpIds = {};
  int failAfter = -1; // -1 = never fail; otherwise throw after N pushes
  int _pushedThisRun = 0;

  void beginRun() => _pushedThisRun = 0;

  void push(SyncRecord op) {
    if (failAfter >= 0 && _pushedThisRun >= failAfter) {
      throw StateError('network lost');
    }
    _pushedThisRun++;
    if (!appliedOpIds.add(op.opId)) {
      // Re-applying the same op must be a no-op, never a duplicate.
      return;
    }
    final key = '${op.entity}:${op.id}';
    final existing = records[key];
    records[key] = existing == null ? op : resolveConflict(existing, op).record;
  }
}

/// One sync session: plan from dirty records + what the remote already
/// applied, push in order; returns how many ops were pushed.
int runSync(List<SyncRecord> dirty, FakeRemote remote) {
  remote.beginRun();
  final plan = planPush(dirty, remote.appliedOpIds);
  var pushed = 0;
  for (final op in plan) {
    remote.push(op);
    pushed++;
  }
  return pushed;
}

void main() {
  // ---------- Deterministic push order: parents before children ----------
  final dirty = [
    rec('collection_payments', 'pay1', 1, 300),
    rec('persons', 'p1', 1, 500),
    rec('collection_obligations', 'ob1', 1, 100),
    rec('ledger_entries', 'e1', 1, 200),
    rec('collection_schedules', 's1', 1, 400),
  ];
  final plan = planPush(dirty, {});
  eq('push order is parents-first',
      plan.map((r) => r.entity).join(','),
      'persons,collection_schedules,ledger_entries,collection_obligations,collection_payments');

  // ---------- Test E: offline work syncs when back online ----------
  final remote = FakeRemote();
  eq('E: all offline records pushed', runSync(dirty, remote), 5);
  eq('E: remote holds every record', remote.records.length, 5);
  eq('E: second sync has nothing to do', runSync(dirty, remote), 0);

  // ---------- Test F + I: interrupted sync retries without duplicates ----------
  final remote2 = FakeRemote()..failAfter = 2;
  var crashed = false;
  try {
    runSync(dirty, remote2);
  } on StateError {
    crashed = true;
  }
  check('F: sync interrupted mid-way', crashed);
  eq('F: two ops landed before the crash', remote2.appliedOpIds.length, 2);
  remote2.failAfter = -1; // network is back
  eq('F: retry pushes only the remaining three', runSync(dirty, remote2), 3);
  eq('I: every op applied exactly once', remote2.appliedOpIds.length, 5);
  eq('I: remote record count exact, no duplicates', remote2.records.length, 5);
  eq('F: plan after success is empty', planPush(dirty, remote2.appliedOpIds).length, 0);

  // An edit bumps the version -> a NEW op, applied once, wins remotely.
  final edited = rec('persons', 'p1', 2, 900);
  eq('edit creates a new op', runSync([edited], remote2), 1);
  eq('remote sees the newer version', remote2.records['persons:p1']!.version, 2);
  eq('re-running the same edit is a no-op', runSync([edited], remote2), 0);

  // ---------- Backoff schedule ----------
  eq('backoff attempt 0', backoffMs(0), 1000);
  eq('backoff attempt 1', backoffMs(1), 2000);
  eq('backoff attempt 3', backoffMs(3), 8000);
  eq('backoff capped at 5 min', backoffMs(30), 300000);

  // ---------- Conflict policy ----------
  final older = rec('persons', 'x', 1, 100);
  final newer = rec('persons', 'x', 1, 200);
  eq('newer local wins', resolveConflict(newer, older).winner, ConflictWinner.local);
  eq('newer remote wins', resolveConflict(older, newer).winner, ConflictWinner.remote);
  final v2 = rec('persons', 'x', 2, 100);
  eq('same time, higher version wins', resolveConflict(v2, older).winner, ConflictWinner.local);
  final tomb = rec('persons', 'x', 1, 100, deleted: true);
  eq('exact tie: tombstone wins', resolveConflict(older, tomb).winner, ConflictWinner.remote);
  eq('exact tie: local tombstone wins', resolveConflict(tomb, older).winner, ConflictWinner.local);
  final resurrect = rec('persons', 'x', 2, 300);
  final tombResult = resolveConflict(resurrect, tomb);
  eq('newer edit resurrects a deleted record', tombResult.winner, ConflictWinner.local);
  eq('resurrected record is not deleted', tombResult.record.isDeleted, false);

  // ---------- Pull merge ----------
  final local = [rec('persons', 'a', 1, 100), rec('persons', 'b', 1, 100)];
  final pulled = [rec('persons', 'b', 1, 500), rec('persons', 'c', 1, 50)];
  final merged = mergePulled(local, pulled);
  eq('merge keeps all records', merged.length, 3);
  eq('merge takes the newer remote copy', merged.firstWhere((r) => r.id == 'b').updatedAtMs, 500);
  eq('merge keeps untouched local record', merged.firstWhere((r) => r.id == 'a').updatedAtMs, 100);

  print('\n$_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('$_fail checks failed');
}
