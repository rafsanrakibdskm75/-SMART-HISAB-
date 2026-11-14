import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

/// Whether Firebase came up at startup. Everything in the app must keep
/// working when this is false (offline-first, §9): sync features simply
/// show "not configured" and point at docs/FIREBASE_SETUP.md.
class FirebaseGate {
  static bool ready = false;

  static Future<void> init() async {
    try {
      if (DefaultFirebaseOptions.android.apiKey == 'REPLACE_ME') {
        ready = false;
        return;
      }
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      ready = true;
    } catch (_) {
      ready = false; // never block the shop's day on a cloud problem
    }
  }
}
