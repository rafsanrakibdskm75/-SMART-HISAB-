# Release Guide — Smart Hisab 1.0.0

## যা যা তৈরি আছে (Stage 7)
- Platform ফোল্ডার: android, ios, web, windows, linux, macos (org `com.smarthisab`, applicationId `com.smarthisab.smart_hisab`)
- App icon: আপনার logo kit থেকে — Android legacy + adaptive (foreground/background), iOS full set, web icons + favicon
- Android: নাম "Smart Hisab", minSdk 23 (Android 6+), notification permissions + reboot-safe reminder receivers, desugaring (পুরনো ফোনে scheduled notification-এর জন্য)
- Version: `1.0.0+1` (pubspec.yaml)

## প্রথম build (আপনার PC-তে)
এই VM-এ Android SDK-র package download আটকে গেছে (sdkmanager proxy সমস্যা), তাই build-টা আপনার PC-তে হবে — যেখানে Live Chat-এর Flutter setup ইতিমধ্যে আছে।

Windows Terminal / PowerShell-এ, project ফোল্ডারে:
```
flutter pub get
flutter build apk --release
```
APK পাবেন: `build\app\outputs\flutter-apk\app-release.apk` — ফোনে install করে টেস্ট করুন।

> Gradle/Kotlin cache আটকালে (Live Chat-এ হয়েছিল): `flutter clean` → `android` ফোল্ডারে `gradlew.bat --stop` → আবার build।

## নিজের keystore দিয়ে sign করা (Play Store-এর আগে অবশ্যই)
এখন key.properties না থাকলে release build debug key দিয়ে sign হয় (টেস্টের জন্য ঠিক আছে, **Play Store-এ চলবে না**)।

1. Keystore বানান (একবারই; JDK-র keytool দিয়ে):
```
keytool -genkey -v -keystore smarthisab-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias smarthisab
```
2. `.jks` ফাইলটা project ফোল্ডারের বাইরে **নিরাপদ ব্যাকআপে** রাখুন — হারালে Play Store-এ আর update দেওয়া যাবে না।
3. `android/key.properties.example` কপি করে `android/key.properties` বানিয়ে নিজের password বসান (আসল ফাইলটা public repo-তে commit করবেন না)।
4. আবার `flutter build apk --release` অথবা Play Store-এর জন্য:
```
flutter build appbundle --release
```
AAB পাবেন: `build\app\outputs\bundle\release\app-release.aab`

## Play Store-এ তোলা
1. Play Console ($25 developer account) → Create app → নাম **Smart Hisab**, category: Business/Finance।
2. AAB upload করুন, store listing-এ logo kit-এর icon (512) ও screenshot দিন।
3. Data safety ফর্মে বলুন: ডেটা ডিভাইসে থাকে, Firebase sync on থাকলে নিজের account-এ encrypted transit-এ যায়।
4. প্রথমে **Closed testing**-এ নিজের ফোনে চালিয়ে তারপর production।

## Firebase চালু করা (যখন সুবিধা হবে)
`docs/FIREBASE_SETUP.md` অনুযায়ী `firebase login` + `flutterfire configure --project=artful-fastness-341404 --platforms=android,ios,web,windows,macos,linux` — তৈরি ফাইলগুলো (`lib/firebase_options.dart`, `android/app/google-services.json`) project-এ থাকলেই sync live। Google-services plugin লাইন দুটো flutterfire নিজেই বসিয়ে দেয়; না দিলে `android/build.gradle.kts` ও `android/app/build.gradle.kts`-তে plugin id যোগ করতে হবে (FIREBASE_SETUP-তে লেখা আছে)।

## Version বাড়ানো
প্রতিটা release-এ `pubspec.yaml`-এর `version:` বাড়ান — যেমন `1.0.1+2` (শেষের সংখ্যাটা অবশ্যই আগের চেয়ে বড় হতে হবে)।

## Toolchain pins (v1.1.6 — owner's PC setup)
- Dart SDK constraint: `^3.13.3` (the Flutter that ships Dart 3.13.3 —
  pub suggests Flutter 3.50.0). Older Flutter (e.g. 3.35.x, Dart 3.9)
  will refuse `pub get` by design now.
- Kotlin Gradle plugin: **2.4.0** (`android/settings.gradle.kts`);
  app module uses the modern `kotlin { compilerOptions }` DSL.
- Android Studio: **Panda 1 // 2025.3.1** (screenshot from owner) —
  its bundled JetBrains Runtime 21 covers the JDK requirement.
- AGP stays 8.9.1 + Gradle wrapper 8.12 (compatible with Kotlin 2.4.0
  and openable by Panda; if Studio offers an AGP upgrade on first
  open, it is optional, not required).
