/// Offline-first sync queue (§10–§12). Pure logic, verified by tool/verify.dart.
/// Idempotency rule: one operation per (recordId, localVersion). Retrying an
/// interrupted upload re-uses the same operation, so a financial record can
/// never be uploaded twice (Test I).
library;

enum SyncStatus { localOnly, pendingUpload, uploading, synced, conflict, failed, needsReview }

class SyncOp {
  final String opId; // deterministic: recordId + localVersion
  final String recordId;
  final int localVersion;
  final String entity; // persons / ledger_entries / obligations / payments ...
  /// When the local edit happened (epoch ms). Conflict resolution compares
  /// EDIT times across devices — v1.0.1 stamped records with the SYNC time,
  /// so "whoever synced last" won instead of "whoever edited last".
  final int enqueuedAtMs;
  SyncStatus status;
  int attempts;
  String? lastError;
  SyncOp({required this.recordId, required this.localVersion, required this.entity,
      this.status = SyncStatus.pendingUpload, this.attempts = 0, int? enqueuedAtMs})
      : opId = '${recordId}_v$localVersion',
        enqueuedAtMs = enqueuedAtMs ?? DateTime.now().toUtc().millisecondsSinceEpoch;
}

class SyncQueue {
  final Map<String, SyncOp> _ops = {};
  List<SyncOp> get pending =>
      _ops.values.where((o) => o.status == SyncStatus.pendingUpload || o.status == SyncStatus.failed).toList()
        ..sort((a, b) => a.opId.compareTo(b.opId));
  int get pendingCount => pending.length;
  int get totalCount => _ops.length;

  /// Returns the existing op when the same record+version is enqueued again.
  SyncOp enqueue({required String recordId, required int localVersion, required String entity}) {
    final probe = SyncOp(recordId: recordId, localVersion: localVersion, entity: entity);
    return _ops.putIfAbsent(probe.opId, () => probe);
  }

  void markSynced(String opId) {
    final op = _ops[opId];
    if (op != null) op.status = SyncStatus.synced;
  }

  void markFailed(String opId, String error) {
    final op = _ops[opId];
    if (op != null) { op.status = SyncStatus.failed; op.attempts++; op.lastError = error; }
  }

  /// Pre-upload validation (§11). A failing record is kept locally and marked
  /// Needs Review — it is never silently discarded.
  String? validateFinancialRecord({required int amountPoisha, required String userId, required DateTime date, String? personId, bool personExists = true}) {
    if (userId.isEmpty) return 'Missing user ID';
    if (amountPoisha <= 0) return 'Amount must be positive';
    if (date.year < 2000 || date.year > 2100) return 'Invalid transaction date';
    if (personId != null && !personExists) return 'Person reference not found: $personId';
    return null;
  }
}
