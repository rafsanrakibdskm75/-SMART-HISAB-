/// Transport-independent sync engine (§10–§12 of the master prompt).
/// Pure Dart and unit-verified (tool/verify_stage5.dart): push planning,
/// idempotency, retry backoff and the conflict policy live here; the
/// Firestore adapter only moves bytes.
///
/// Policies:
///  * One operation per (entity, recordId, version) — opId is deterministic,
///    so retrying an interrupted sync re-uses the SAME op ids and a record
///    can never be uploaded twice (Test I).
///  * Push order is deterministic: parents before children (persons →
///    schedules → ledger → obligations → payments → module state), then by
///    updatedAt, then id — a fresh device restore replays in a safe order.
///  * Conflicts: last-write-wins on updatedAtMs; tie → higher version wins;
///    still tied → the tombstone (delete) wins, because resurrecting data
///    the owner deleted is worse than losing an edit. A strictly NEWER edit
///    does resurrect a record deleted earlier (the edit happened after the
///    delete on some device, so it is the latest truth).
library;

class SyncRecord {
  final String entity;
  final String id;
  final int version;
  final int updatedAtMs; // epoch milliseconds (device clock at write time)
  final bool isDeleted; // tombstone
  final Map<String, Object?> payload;
  const SyncRecord({
    required this.entity, required this.id, required this.version,
    required this.updatedAtMs, this.isDeleted = false, this.payload = const {},
  });
  String get opId => '$entity:$id:v$version';
  SyncRecord copyWith({int? version, int? updatedAtMs, bool? isDeleted, Map<String, Object?>? payload}) =>
      SyncRecord(entity: entity, id: id, version: version ?? this.version,
          updatedAtMs: updatedAtMs ?? this.updatedAtMs, isDeleted: isDeleted ?? this.isDeleted,
          payload: payload ?? this.payload);
}

const entityPushOrder = <String, int>{
  'persons': 0,
  'collection_schedules': 1,
  'ledger_entries': 2,
  'daily_summaries': 3,
  'collection_obligations': 4,
  'collection_payments': 5,
  'payments': 5,
  'operator_balances': 6,
  'recharges': 7,
  'tokri_rentals': 8,
  'tokri_attendance': 9,
  'somity_members': 10,
  'app_settings': 11,
};

/// The operations still to push: dirty records whose opId has not already
/// been applied remotely. Planning twice with the same inputs yields the
/// same plan (safe to recompute after a crash).
List<SyncRecord> planPush(List<SyncRecord> dirty, Set<String> appliedOpIds) {
  final ops = dirty.where((r) => !appliedOpIds.contains(r.opId)).toList();
  ops.sort((a, b) {
    final ea = entityPushOrder[a.entity] ?? 99, eb = entityPushOrder[b.entity] ?? 99;
    if (ea != eb) return ea.compareTo(eb);
    if (a.updatedAtMs != b.updatedAtMs) return a.updatedAtMs.compareTo(b.updatedAtMs);
    return a.opId.compareTo(b.opId);
  });
  return ops;
}

/// Exponential backoff for retries: 1s, 2s, 4s … capped at 5 minutes.
/// Deterministic so tests can pin it; the transport may add jitter.
int backoffMs(int attempt) {
  if (attempt <= 0) return 1000;
  final ms = 1000 << attempt; // 1000 * 2^attempt
  return ms > 300000 ? 300000 : ms;
}

enum ConflictWinner { local, remote }

class ConflictResult {
  final ConflictWinner winner;
  final SyncRecord record; // the winning record to keep/apply
  final String reason;
  const ConflictResult(this.winner, this.record, this.reason);
}

/// Last-write-wins with tombstone preference on exact ties (see header).
ConflictResult resolveConflict(SyncRecord local, SyncRecord remote) {
  assert(local.entity == remote.entity && local.id == remote.id);
  if (local.updatedAtMs != remote.updatedAtMs) {
    return local.updatedAtMs > remote.updatedAtMs
        ? ConflictResult(ConflictWinner.local, local, 'local is newer')
        : ConflictResult(ConflictWinner.remote, remote, 'remote is newer');
  }
  if (local.version != remote.version) {
    return local.version > remote.version
        ? ConflictResult(ConflictWinner.local, local, 'same time, local version higher')
        : ConflictResult(ConflictWinner.remote, remote, 'same time, remote version higher');
  }
  if (local.isDeleted != remote.isDeleted) {
    return local.isDeleted
        ? ConflictResult(ConflictWinner.local, local, 'exact tie — tombstone wins')
        : ConflictResult(ConflictWinner.remote, remote, 'exact tie — tombstone wins');
  }
  return ConflictResult(ConflictWinner.remote, remote, 'identical stamps — remote is the shared truth');
}

/// Merge a pulled remote set into local state: returns the records to
/// store locally (winners), keyed against what is already there.
List<SyncRecord> mergePulled(List<SyncRecord> local, List<SyncRecord> remote) {
  final byKey = <String, SyncRecord>{for (final r in local) '${r.entity}:${r.id}': r};
  for (final r in remote) {
    final key = '${r.entity}:${r.id}';
    final existing = byKey[key];
    byKey[key] = existing == null ? r : resolveConflict(existing, r).record;
  }
  return byKey.values.toList();
}

/// The result of reconciling what this device wants to push with what the
/// server already has — the two-device question: the same record edited on
/// both devices with different values at different times.
class SyncPlan {
  /// Local records that WIN their conflict (or have no conflict): push them.
  final List<SyncRecord> toPush;

  /// Remote records that win (or do not exist locally): store them locally.
  final List<SyncRecord> toApply;

  /// Local records that LOSE: never push them, and clear their pending op
  /// so the device stops trying — their remote winner is in [toApply].
  final List<SyncRecord> superseded;

  const SyncPlan({required this.toPush, required this.toApply, required this.superseded});
}

/// Reconcile local dirty records against a pulled remote set, one winner
/// per record, decided by resolveConflict (edit-time LWW, then version,
/// then tombstone). Records that exist on only one side simply cross over:
/// two DIFFERENT records (e.g. two ledger entries with different ids) are
/// not a conflict at all — both survive.
SyncPlan planSync(List<SyncRecord> localDirty, List<SyncRecord> pulled) {
  final remoteByKey = <String, SyncRecord>{
    for (final r in pulled) '${r.entity}:${r.id}': r,
  };
  final toPush = <SyncRecord>[];
  final toApply = <SyncRecord>[];
  final superseded = <SyncRecord>[];
  final seen = <String>{};
  for (final local in localDirty) {
    final key = '${local.entity}:${local.id}';
    seen.add(key);
    final remote = remoteByKey[key];
    if (remote == null) {
      toPush.add(local);
    } else if (resolveConflict(local, remote).winner == ConflictWinner.local) {
      toPush.add(local);
    } else {
      superseded.add(local);
      toApply.add(remote);
    }
  }
  for (final remote in pulled) {
    if (!seen.contains('${remote.entity}:${remote.id}')) toApply.add(remote);
  }
  return SyncPlan(
    toPush: planPush(toPush, const {}),
    toApply: toApply,
    superseded: superseded,
  );
}
