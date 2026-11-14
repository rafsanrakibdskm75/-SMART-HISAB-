/// Sync transport boundary. The engine (lib/domain/sync_engine.dart)
/// decides WHAT to move and in which order; a gateway only moves it.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/sync_engine.dart';
import 'firebase_gate.dart';

abstract interface class SyncGateway {
  bool get available;
  String? get uid;

  /// Idempotently write records (create-or-replace by deterministic id).
  Future<void> push(List<SyncRecord> records);

  /// Records changed on the server after [watermarkMs] (0 = everything).
  Future<List<SyncRecord>> pullSince(int watermarkMs);
}

/// Firestore transport: users/{uid}/{entity}/{recordId}.
/// Documents carry userId + updatedAt so the shipped security rules
/// (firebase/firestore.rules) accept them; deletes are tombstones, never
/// hard deletes (§14).
class FirestoreSyncGateway implements SyncGateway {
  final FirebaseFirestore _fs;
  final String _uid;
  FirestoreSyncGateway(this._uid, {FirebaseFirestore? firestore})
      : _fs = firestore ?? FirebaseFirestore.instance;

  @override
  bool get available => FirebaseGate.ready;
  @override
  String? get uid => _uid;

  CollectionReference<Map<String, dynamic>> _col(String entity) =>
      _fs.collection('users').doc(_uid).collection(entity);

  @override
  Future<void> push(List<SyncRecord> records) async {
    // Firestore batches cap at 500 writes.
    for (var i = 0; i < records.length; i += 400) {
      final chunk = records.skip(i).take(400);
      final batch = _fs.batch();
      for (final r in chunk) {
        batch.set(_col(r.entity).doc(r.id), {
          ...r.payload,
          'userId': _uid,
          'version': r.version,
          'updatedAtMs': r.updatedAtMs,
          'isDeleted': r.isDeleted,
          'opId': r.opId,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    }
  }

  @override
  Future<List<SyncRecord>> pullSince(int watermarkMs) async {
    final out = <SyncRecord>[];
    for (final entity in entityPushOrder.keys) {
      // Filter on the SERVER 'updatedAt', never on the client edit stamp:
      // a record edited long ago but synced late has an old updatedAtMs and
      // would be skipped forever by an edit-time watermark.
      final snap = await _col(entity)
          .where('updatedAt',
              isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(watermarkMs))
          .get();
      for (final doc in snap.docs) {
        final d = doc.data();
        final serverMs = (d['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch;
        out.add(SyncRecord(
          entity: entity,
          id: doc.id,
          version: (d['version'] as num?)?.toInt() ?? 1,
          updatedAtMs: (d['updatedAtMs'] as num?)?.toInt() ?? 0,
          isDeleted: d['isDeleted'] == true,
          payload: {...d, if (serverMs != null) '_serverMs': serverMs},
        ));
      }
    }
    return out;
  }
}

/// Used until the owner finishes Firebase setup: sync screens stay
/// honest ("not configured") instead of pretending to sync.
class UnavailableSyncGateway implements SyncGateway {
  @override
  bool get available => false;
  @override
  String? get uid => null;
  @override
  Future<void> push(List<SyncRecord> records) =>
      throw StateError('Firebase এখনো সেটআপ হয়নি — docs/FIREBASE_SETUP.md দেখুন');
  @override
  Future<List<SyncRecord>> pullSince(int watermarkMs) async => const [];
}
