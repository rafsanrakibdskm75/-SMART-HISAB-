import 'package:get/get.dart';

import '../../data/sync/auth_service.dart';
import '../../data/sync/firebase_gate.dart';
import '../../data/sync/in_memory_sync_source.dart';
import '../../data/sync/sync_gateway.dart';
import '../../domain/sync_engine.dart';

/// Stage 5 controller: account + sync session state.
/// Offline-first contract: every failure here leaves local data untouched
/// and the shop fully usable (§9). Nothing in this controller can block
/// or delete local records.
class SyncController extends GetxController {
  final InMemorySyncSource _source;
  final AuthService _auth;
  SyncController(this._source, this._auth);

  final firebaseReady = FirebaseGate.ready.obs;
  final email = RxnString();
  final status = 'প্রস্তুত'.obs;
  final pendingCount = 0.obs;
  final lastSyncAt = Rxn<DateTime>();
  final syncing = false.obs;
  int _pullWatermarkMs = 0;

  @override
  void onInit() {
    super.onInit();
    email.value = _auth.currentUser?.email;
    refreshPending();
    _auth.userChanges.listen((u) => email.value = u?.email);
  }

  void refreshPending() => pendingCount.value = _source.pendingCount;

  SyncGateway get _gateway {
    final uid = _auth.currentUser?.uid;
    if (!FirebaseGate.ready || uid == null) return UnavailableSyncGateway();
    return FirestoreSyncGateway(uid);
  }

  Future<String?> register(String email, String password) => _afterAuth(() => _auth.register(email, password));
  Future<String?> signIn(String email, String password) => _afterAuth(() => _auth.signIn(email, password));

  Future<String?> _afterAuth(Future<String?> Function() op) async {
    if (!FirebaseGate.ready) return 'Firebase এখনো সেটআপ হয়নি — docs/FIREBASE_SETUP.md অনুসরণ করুন';
    final err = await op();
    email.value = _auth.currentUser?.email;
    return err;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    email.value = null;
  }

  /// Push everything pending (engine order, idempotent), then pull what
  /// changed remotely since the last pull and apply the winners.
  Future<String?> syncNow() async {
    final gateway = _gateway;
    if (!gateway.available) {
      return email.value == null
          ? 'আগে লগইন করুন'
          : 'Firebase এখনো সেটআপ হয়নি — docs/FIREBASE_SETUP.md দেখুন';
    }
    syncing.value = true;
    status.value = 'সিঙ্ক হচ্ছে…';
    try {
      // Pull FIRST and reconcile: when both devices edited the same record,
      // only the winner (latest edit time) is pushed — v1.0.1 pushed
      // blindly, so whichever device synced last overwrote the other.
      final pulled = await gateway.pullSince(_pullWatermarkMs);
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final dirty = _source.dirtyRecords(nowMs: nowMs);
      final plan = planSync(dirty, pulled);
      if (plan.toPush.isNotEmpty) {
        await gateway.push(plan.toPush);
        _source.markPushed(plan.toPush);
      }
      if (plan.superseded.isNotEmpty) {
        _source.markPushed(plan.superseded); // losers leave the queue
      }
      if (plan.toApply.isNotEmpty) {
        _source.applyPulled(plan.toApply);
      }
      if (pulled.isNotEmpty) {
        // Advance only to the newest server time actually seen, so a
        // late-syncing device (old edit, new upload) is never skipped.
        for (final r in pulled) {
          final serverMs = (r.payload['_serverMs'] as num?)?.toInt() ?? r.updatedAtMs;
          if (serverMs > _pullWatermarkMs) _pullWatermarkMs = serverMs;
        }
      }
      lastSyncAt.value = DateTime.now();
      status.value = 'সিঙ্ক সম্পন্ন ✅';
      refreshPending();
      return null;
    } catch (e) {
      status.value = 'সিঙ্ক ব্যর্থ — লোকাল ডেটা নিরাপদ আছে';
      return 'সিঙ্ক হয়নি: $e';
    } finally {
      syncing.value = false;
    }
  }
}
