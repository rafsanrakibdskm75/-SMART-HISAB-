// Firebase options supplied by the owner on 2026-11-13 for TESTING
// (project: login-e5f9b). Standard flutterfire layout. macOS reuses the
// iOS app and Linux the web app until `flutterfire configure` generates
// dedicated entries — fine for testing; regenerate before production.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD4EAaM78f395z3f2zlnivGwJ8h7XIMglA',
    appId: '1:398512212810:web:e79a105c0ee44256ad0fb3',
    messagingSenderId: '398512212810',
    projectId: 'login-e5f9b',
    authDomain: 'login-e5f9b.firebaseapp.com',
    databaseURL: 'https://login-e5f9b-default-rtdb.firebaseio.com',
    storageBucket: 'login-e5f9b.firebasestorage.app',
    measurementId: 'G-YW2BG4CM8Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD23vGlWliK2c71j0cJk0fxZqfbQet_bkI',
    appId: '1:398512212810:android:a5c2ddc83480aa07ad0fb3',
    messagingSenderId: '398512212810',
    projectId: 'login-e5f9b',
    databaseURL: 'https://login-e5f9b-default-rtdb.firebaseio.com',
    storageBucket: 'login-e5f9b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkvgVx49Cdxnqq0A_efbg-_OCCjfsyoQA',
    appId: '1:398512212810:ios:3450ab372fcc5b0aad0fb3',
    messagingSenderId: '398512212810',
    projectId: 'login-e5f9b',
    databaseURL: 'https://login-e5f9b-default-rtdb.firebaseio.com',
    storageBucket: 'login-e5f9b.firebasestorage.app',
    iosClientId: '398512212810-c0rebnlunlsh9k451b7ivhg9tnbp8etq.apps.googleusercontent.com',
    iosBundleId: 'com.smarthisab.smartHisab',
  );

  /// No dedicated macOS app in the project yet — reuse the iOS one.
  static const FirebaseOptions macos = ios;

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyADFtaax52fwDfc7RRlRbyZZBxXrNk04I4',
    appId: '1:398512212810:web:b5de07be414eccf1ad0fb3',
    messagingSenderId: '398512212810',
    projectId: 'login-e5f9b',
    authDomain: 'login-e5f9b.firebaseapp.com',
    databaseURL: 'https://login-e5f9b-default-rtdb.firebaseio.com',
    storageBucket: 'login-e5f9b.firebasestorage.app',
    measurementId: 'G-X7CFC4DPQS',
  );

  /// No dedicated Linux app — flutterfire convention is the web config.
  static const FirebaseOptions linux = web;
}
