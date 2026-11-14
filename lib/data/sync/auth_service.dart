import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Thin wrapper over FirebaseAuth with Bangla, human error messages.
class AuthService {
  FirebaseAuth? get _auth =>
      Firebase.apps.isEmpty ? null : FirebaseAuth.instance;

  User? get currentUser => _auth?.currentUser;
  Stream<User?> get userChanges =>
      _auth?.authStateChanges() ?? const Stream<User?>.empty();

  Future<String?> register(String email, String password) async {
    try {
      await _auth?.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _message(e);
    } catch (_) {
      return 'অজানা সমস্যা — আবার চেষ্টা করুন';
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth?.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _message(e);
    } catch (_) {
      return 'অজানা সমস্যা — আবার চেষ্টা করুন';
    }
  }

  Future<void> signOut() async {
    await _auth?.signOut();
  }

  String _message(FirebaseAuthException e) => switch (e.code) {
        'invalid-email' => 'ইমেইল ঠিকানা সঠিক নয়',
        'user-not-found' || 'wrong-password' || 'invalid-credential' => 'ইমেইল বা পাসওয়ার্ড মেলেনি',
        'email-already-in-use' => 'এই ইমেইল দিয়ে ইতিমধ্যে অ্যাকাউন্ট আছে — লগইন করুন',
        'weak-password' => 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
        'network-request-failed' => 'ইন্টারনেট সংযোগ নেই — অফলাইন মোডে কাজ চলবে',
        'too-many-requests' => 'অনেকবার চেষ্টা হয়েছে — কিছুক্ষণ পরে আবার চেষ্টা করুন',
        _ => 'সমস্যা: ${e.code}',
      };
}
