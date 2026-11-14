# Firestore structure (sync mirror of the local SQLite truth)

Local SQLite/Drift is the primary source (§9). Firestore is the sync copy.

    users/{uid}/
      profile                      (business name, owner name, role)
      members/{memberUid}          (role: owner/manager/staff/readonly)
      persons/{personId}
      collection_schedules/{id}
      collection_obligations/{personId_yyyy-MM-dd}
      payments/{paymentId}                  (immutable)
      payment_allocations/{id}
      ledger_entries/{entryId}              (immutable; reversals are new docs)
      accounts/{accountId}
      daily_summaries/{yyyy-MM-dd}
      audit_log/{id}
      backups/{backupId}                    (versioned snapshots, §13)
      sync_state/meta                       (lastServerSync, device list)

Every document carries: id, userId, createdAt, updatedAt, deviceId,
localVersion, syncStatus, isDeleted (tombstone), serverUpdatedAt
(serverTimestamp on write). Uploads are idempotent: the client writes with
the deterministic document ID above and a unique sync operation ID, so a
retried upload overwrites the same document instead of duplicating it (§12).
