/// Fingerprint / Face unlock boundary (v1.1.3). Wraps the platform
/// biometric prompt (local_auth) behind an interface so the session
/// logic stays testable and every platform failure reads as "not
/// available" instead of a crash.
library;

import 'package:local_auth/local_auth.dart';

abstract interface class BiometricService {
  /// True when this device can show a biometric (or device-credential)
  /// prompt at all.
  Future<bool> isAvailable();

  /// Shows the system prompt. False on cancel/failure — never throws.
  Future<bool> authenticate();
}

class LocalAuthBiometricService implements BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Smart Hisab খুলতে fingerprint / Face ID দিন',
        biometricOnly: false, // device PIN remains a fallback
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
