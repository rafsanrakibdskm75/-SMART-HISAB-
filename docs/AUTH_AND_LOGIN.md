# Splash, Login, Create Account, Fingerprint (v1.1.3)

Entry flow: **native splash → Stitch splash screen → gate → home**.

- The splash screen is the owner's own Stitch design
  (`smart_hisab_splash_screen`, delivered 2026-11-13) rebuilt in Flutter.
  The native launch background was recoloured to the design's light
  mint (#EFFDF3) so the two splashes blend. The version label lives in
  `splash_screen.dart` (`splashVersionLabel`) — bump it with pubspec.
- The re-export contained ONLY the splash screen — no login screen —
  so Login and Create Account are original screens in the same Bengal
  Ledger Tactile system, visually paired with the splash. If the owner
  later exports the Stitch login design, swap the visuals then.

## The gate (SessionController)
- First run (no account, no offline choice): Login screen.
- "অফলাইনে চালিয়ে যান" (continue offline) is remembered
  (`settings.offlineMode`) and skips the gate afterwards.
- With an account: password required at cold start, or fingerprint
  when enabled. Creating an account signs in immediately.

## Passwords
- Never stored in plain text: `sha256(salt + password)`, random salt,
  both in AppSettings (which syncs between the owner's own devices, so
  the same login works on phone B after sync).
- When Firebase is configured, create/sign-in ALSO call FirebaseAuth
  with the same email — one identity for cloud sync. Firebase being
  down or unconfigured never blocks the local gate.

## Fingerprint (local_auth 3.x)
- Enable: offered once after a successful password login/create, and
  any time in Settings → "Fingerprint login" (account required; the
  toggle checks the device really has biometrics set up).
- Login screen auto-prompts once when unlock is available; cancelling
  leaves the password form. Device PIN works as fallback
  (biometricOnly: false) — this is a device unlock gate, exactly like
  banking apps; the underlying session/app data rules don't change.
- Android needs `FlutterFragmentActivity` (MainActivity changed) +
  USE_BIOMETRIC/USE_FINGERPRINT permissions; iOS needs
  NSFaceIDUsageDescription (added). Desktop/web: no biometrics, the
  option simply never appears.
