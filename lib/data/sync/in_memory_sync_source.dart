/// Builds SyncRecords from the in-memory store's pending operations and
/// applies pulled records back. This is the record source while the app
/// runs on the in-memory repositories; the Drift cutover reads the same
/// shape from the syncStatus columns instead (tables.dart SyncColumns).
library;

import '../../core/dhaka_time.dart';
import '../../domain/collection_models.dart';
import '../../domain/person.dart';
import '../../domain/sync_engine.dart';
import '../../domain/sync_queue.dart';
import '../repositories/in_memory_repositories.dart';

class InMemorySyncSource {
  final InMemoryStore store;
  InMemorySyncSource(this.store);

  int get pendingCount => store.syncQueue.pendingCount;

  List<SyncOp> get pendingOps => store.syncQueue.pending;

  /// One SyncRecord per pending op, with the entity's current payload.
  /// updatedAtMs uses the Dhaka-now clock; versions come from the op.
  List<SyncRecord> dirtyRecords({required int nowMs}) {
    final out = <SyncRecord>[];
    for (final op in store.syncQueue.pending) {
      final payload = _payloadFor(op.entity, op.recordId);
      if (payload == null) continue; // record vanished locally; skip
      out.add(SyncRecord(
        entity: op.entity, id: op.recordId, version: op.localVersion,
        // The op's EDIT time, not the sync time (nowMs is only a fallback
        // for ops created before timestamps existed).
        updatedAtMs: op.enqueuedAtMs > 0 ? op.enqueuedAtMs : nowMs,
        isDeleted: payload['isDeleted'] == true, payload: payload));
    }
    return out;
  }

  Map<String, Object?>? _payloadFor(String entity, String id) {
    switch (entity) {
      case 'persons':
        final p = store.persons[id];
        return p?.toJson();
      case 'ledger_entries':
        for (final e in store.entries) {
          if (e.id == id) return entryToJson(e);
        }
        return null;
      case 'collection_schedules':
        final s = store.schedules[id];
        return s?.toJson();
      case 'collection_obligations':
        final o = store.obligations[id];
        return o?.toJson();
      case 'payments':
        for (final pay in store.payments) {
          if (pay.id == id) return pay.toJson();
        }
        return null;
      case 'daily_summaries':
        // recordId is closing_<dateKey>
        final key = id.replaceFirst('closing_', '');
        final c = store.closings[key];
        if (c == null) return null;
        return {
          'id': id, 'date': key, 'closedBy': c.closedBy,
          'opening': c.summary.openingPoisha, 'in': c.summary.totalInPoisha,
          'out': c.summary.totalOutPoisha, 'collection': c.summary.collectionPoisha,
        };
      case 'operator_balances':
        final bal = store.operatorBalances[id];
        return bal == null ? null : {'operator': id, 'balancePoisha': bal};
      case 'recharges':
        for (final r in store.rechargeRecords) {
          if (r.id == id) return r.toJson();
        }
        return null;
      case 'tokri_rentals':
        return store.rentals[id]?.toJson();
      case 'tokri_attendance':
        for (final t in store.tokriDays) {
          if ('${t.rentalId}_${dateKey(t.date)}' == id) return t.toJson();
        }
        return null;
      case 'somity_members':
        return {'personId': id, 'member': store.somityMembers.contains(id)};
      default:
        return {'id': id};
    }
  }

  // SyncRecord.opId is 'entity:id:vN' but SyncQueue.opId is 'id_vN' —
  // v1.0.1 passed the record format straight through, so markSynced never
  // matched anything and pushed ops stayed "pending" forever.
  String _queueOpId(SyncRecord r) => '${r.id}_v${r.version}';

  void markPushed(List<SyncRecord> records) {
    for (final r in records) {
      store.syncQueue.markSynced(_queueOpId(r));
    }
  }

  void markFailed(List<SyncRecord> records, String error) {
    for (final r in records) {
      store.syncQueue.markFailed(_queueOpId(r), error);
    }
  }

  /// Apply pulled winners into the store. Persons, ledger entries and
  /// schedules are fully applied; other entities are returned so the
  /// caller can surface them (full restore ships with the Drift cutover).
  /// True when a local edit of this record is still waiting to upload —
  /// a pulled copy must never silently overwrite unsynced local work.
  bool _hasPending(String entity, String id) =>
      store.syncQueue.pending.any((o) => o.entity == entity && o.recordId == id);

  List<SyncRecord> applyPulled(List<SyncRecord> records) {
    final unapplied = <SyncRecord>[];
    for (final r in records) {
      if (_hasPending(r.entity, r.id)) {
        unapplied.add(r); // local pending edit wins; it pushes next sync
        continue;
      }
      switch (r.entity) {
        case 'persons':
          final p = Person.fromJson(r.payload.cast<String, Object?>());
          if (r.isDeleted) {
            // Tombstone = soft delete (§12): the row stays for ledger
            // references; v1.0.0 hard-removed it and broke history.
            final existing = store.persons[r.id];
            if (existing != null) {
              store.persons[r.id] = existing.copyWith(
                  isDeleted: true, localVersion: r.version);
            }
          } else {
            store.persons[p.id] = p;
          }
        case 'ledger_entries':
          final e = entryFromJson(r.payload.cast<String, Object?>());
          store.entries.removeWhere((x) => x.id == e.id);
          if (!r.isDeleted) store.entries.add(e);
        case 'collection_schedules':
          final s = CollectionScheduleJson.fromJson(r.payload.cast<String, Object?>());
          if (r.isDeleted) {
            store.schedules.remove(r.id);
          } else {
            store.schedules[s.id] = s;
          }
        default:
          unapplied.add(r);
      }
    }
    return unapplied;
  }
}
