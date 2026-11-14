/// Session gate (v1.1.3): splash → login → home decision + the account
/// operations behind the Login / Create Account screens.
///
/// Rules (offline-first, §9):
/// - No account and no offline choice → the gate shows (login screen).
/// - "Offline-e chaliye jan" is remembered (settings.offlineMode) and
///   skips the gate on later starts.
/// - With an account, the gate asks for the password — or the fingerprint
///   when the owner enabled it and the device supports it. The password
///   itself is never stored: only sha256(salt + password).
/// - When Firebase is configured, create/sign-in ALSO go through
///   FirebaseAuth (same email), so cloud sync keeps one identity.
///   Firebase failing never blocks the local gate decision.
library;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

import '../../data/auth/biometric_service.dart';
import '../../data/repositories/repositories.dart';
import '../../data/sync/auth_service.dart';
import '../../data/sync/firebase_gate.dart';
import '../../domain/stage6.dart';

enum GateDecision { home, login }

class SessionController extends GetxController {
  SessionController(this._settings, this._auth, this._biometrics);

  final SettingsRepository _settings;
  final AuthService _auth;
  final BiometricService _biometrics;

  final settings = const AppSettings().obs;
  final signedIn = false.obs;

  /// True when an account exists on this profile.
  bool get hasAccount => settings.value.accountEmail.isNotEmpty;

  /// Fingerprint button should be offered: owner enabled it, an account
  /// exists, and the hardware can do it (checked live by the screen).
  bool get biometricOffered =>
      settings.value.biometricEnabled && hasAccount;

  Future<void> load() async {
    settings.value = await _settings.load();
  }

  /// Where the splash should send the user.
  GateDecision decide() {
    if (signedIn.value) return GateDecision.home;
    if (settings.value.offlineMode) return GateDecision.home;
    return GateDecision.login;
  }

  // ---- validators (shared by login + create screens) ----
  static String? validateEmail(String email) {
    final e = email.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e)) {
      return 'সঠিক ইমেইল দিন';
    }
    return null;
  }

  static String? validatePassword(String password) =>
      password.length < 6 ? 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে' : null;

  static String? validateMobile(String mobile) {
    final m = mobile.trim();
    if (m.isEmpty) return null; // optional
    return RegExp(r'^01[3-9]\d{8}$').hasMatch(m)
        ? null
        : 'সঠিক ১১ ডিজিটের মোবাইল নম্বর দিন (01…)';
  }

  String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  String _newSalt() {
    final r = Random.secure();
    return [for (var i = 0; i < 16; i++) r.nextInt(256).toRadixString(16).padLeft(2, '0')].join();
  }

  // ---- account operations: null = success, otherwise a Bangla reason ----

  Future<String?> createAccount({
    required String businessName,
    required String ownerName,
    required String mobile,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (businessName.trim().isEmpty) return 'বিজনেসের নাম দিন';
    if (ownerName.trim().isEmpty) return 'আপনার নাম দিন';
    final mErr = validateMobile(mobile);
    if (mErr != null) return mErr;
    final eErr = validateEmail(email);
    if (eErr != null) return eErr;
    final pErr = validatePassword(password);
    if (pErr != null) return pErr;
    if (password != confirmPassword) return 'দুটি পাসওয়ার্ড মিলছে না';

    if (FirebaseGate.ready) {
      final err = await _auth.register(email, password);
      if (err != null) return err;
    }
    final salt = _newSalt();
    // Always merge into the FRESHEST settings — this controller's copy is
    // loaded at splash and other screens may have saved since (v1.1.5 fix:
    // saving the stale copy silently reverted the owner's newer edits).
    final next = (await _settings.load()).copyWith(
      businessName: businessName.trim(),
      ownerName: ownerName.trim(),
      mobile: mobile.trim(),
      accountEmail: email.trim().toLowerCase(),
      localPasswordSalt: salt,
      localPasswordHash: _hash(salt, password),
      offlineMode: false,
    );
    await _settings.save(next);
    settings.value = next;
    signedIn.value = true;
    return null;
  }

  Future<String?> signIn(String email, String password) async {
    final eErr = validateEmail(email);
    if (eErr != null) return eErr;
    if (!hasAccount) {
      return 'এই app-এ এখনো কোনো অ্যাকাউন্ট তৈরি করা হয়নি — আগে অ্যাকাউন্ট তৈরি করুন';
    }
    if (FirebaseGate.ready) {
      final err = await _auth.signIn(email, password);
      if (err != null) return err;
    } else {
      final s = settings.value;
      if (email.trim().toLowerCase() != s.accountEmail) {
        return 'এই ইমেইলে কোনো অ্যাকাউন্ট নেই';
      }
      if (_hash(s.localPasswordSalt, password) != s.localPasswordHash) {
        return 'পাসওয়ার্ড মিলছে না';
      }
    }
    signedIn.value = true;
    return null;
  }

  Future<bool> biometricAvailable() => _biometrics.isAvailable();

  Future<bool> unlockWithBiometric() async {
    if (!biometricOffered) return false;
    final ok = await _biometrics.authenticate();
    if (ok) signedIn.value = true;
    return ok;
  }

  /// Enables/disables fingerprint unlock (from login success or Settings).
  Future<void> setBiometricEnabled(bool enabled) async {
    final next =
        (await _settings.load()).copyWith(biometricEnabled: enabled);
    await _settings.save(next);
    settings.value = next;
  }

  /// Remembers the offline choice and lets the user straight in.
  /// ONLY for the no-account case: with an account, an "offline" door
  /// would permanently bypass the password gate for anyone holding the
  /// phone (v1.1.5 fix) — so this is a no-op for account holders.
  Future<void> continueOffline() async {
    await load();
    if (hasAccount) return;
    if (!settings.value.offlineMode) {
      final next = settings.value.copyWith(offlineMode: true);
      await _settings.save(next);
      settings.value = next;
    }
    signedIn.value = true;
  }
}
