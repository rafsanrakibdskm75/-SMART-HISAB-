# Build instructions

On your PC (Windows is fine):
1. Install Flutter (stable) — flutter.dev/get-started. Run `flutter doctor`
   and fix the Android toolchain + accept licenses (`flutter doctor --android-licenses`).
2. Unzip this pack, open a terminal in the `smart_hisab` folder.
3. `flutter pub get`
4. Generate the Drift database code: `dart run build_runner build --delete-conflicting-outputs`
5. (Firebase, optional for offline use) follow docs/FIREBASE_SETUP.md.
6. Check the pure accounting rules any time, no phone needed:
   `dart run tool/verify.dart`  → expect "41 passed, 0 failed"
7. Run: `flutter run`  •  Release APK: `flutter build apk --release`
   (APK lands in build/app/outputs/flutter-apk/app-release.apk)

Honest status: the domain core (lib/core, lib/domain) is analyzer-clean and
rule-verified with the Dart SDK. The Flutter UI/DB wiring compiles only
after steps 3–4 on a machine with the Flutter SDK; it has not been
APK-built yet — that is Stage 7 work with your Firebase config in place.

## Verified on this machine (2026-11-13, Stage 4)
- Flutter SDK 3.35.7 (Linux) downloaded and used directly:
  - `flutter pub get` — OK (125 dependencies resolved; pubspec.lock committed in the pack)
  - `flutter analyze` — **0 errors** across the whole project (lib/ incl. all UI and Drift repositories). Remaining items are info-level lints only.
  - `flutter pub run build_runner build` — OK; generates `lib/data/db/app_database.g.dart` (included in the pack — regenerate after changing tables.dart).
- Still NOT done: an actual APK build/run on a device (Stage 7) and Firebase wiring (Stage 5).
