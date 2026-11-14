# Firebase Setup — Smart Hisab (একবারই করতে হয়)

এই ধাপগুলো **আপনার নিজের Google account** দিয়ে করতে হবে — Firebase project অন্য কেউ বানিয়ে দিতে পারে না, কারণ ডেটা, billing আর মালিকানা আপনারই থাকে। মোট সময় ~১৫ মিনিট। এই setup শেষ না হওয়া পর্যন্ত অ্যাপ **অফলাইনে পুরোপুরি চলবে**; শুধু সিঙ্ক বন্ধ থাকবে।

## ধাপ ১ — Project বানান
1. [console.firebase.google.com](https://console.firebase.google.com) → **Add project** → নাম `smart-hisab` → Continue।
2. Google Analytics চাইলে on রাখতে পারেন (না রাখলেও চলবে) → Create project।

## ধাপ ২ — Authentication চালু করুন
1. বাম মেনু **Authentication → Get started**।
2. **Sign-in method** ট্যাবে **Email/Password → Enable → Save**।

## ধাপ ৩ — Firestore Database বানান
1. **Firestore Database → Create database**।
2. Location: **asia-south1 (Mumbai)** বেছে নিন (বাংলাদেশের সবচেয়ে কাছের region)।
3. **Start in production mode** → Create।

## ধাপ ৪ — Security Rules বসান (গুরুত্বপূর্ণ!)
Pack-এর `firebase/firestore.rules` ফাইলে তৈরি rules আছে — owner ছাড়া কেউ ডেটা পড়তে/লিখতে পারে না, আর আর্থিক রেকর্ড client থেকে hard-delete করা যায় না।
- সহজ উপায়: Firestore → **Rules** ট্যাবে ফাইলের পুরো লেখা paste করে **Publish**।
- অথবা CLI দিয়ে: project root-এ `firebase deploy --only firestore` (pack-এ `firebase.json` দেওয়া আছে)।

## ধাপ ৫ — FlutterFire configure (আপনার PC-তে)
আগে Android platform ফোল্ডার লাগবে (Stage 7-তে তৈরি হবে, অথবা এখনই):
```
flutter create --org com.smarthisab .
```
তারপর:
```
dart pub global activate flutterfire_cli
flutterfire configure
```
- আপনার বানানো `smart-hisab` project-টা বেছে নিন, platform: **android**।
- এটি নিজে থেকেই `lib/firebase_options.dart` বানিয়ে দেবে (pack-এর placeholder ফাইলটা replace হবে) এবং Android app register করে দেবে।
- Manual পথ চাইলে: Firebase console → Project settings → **Add app → Android**, package name দিন `com.smarthisab.smart_hisab`, `google-services.json` download করে `android/app/` ফোল্ডারে রাখুন, আর `lib/firebase_options.dart`-এর `REPLACE_ME` জায়গাগুলোতে console-এর মানগুলো বসান।

## ধাপ ৬ — যাচাই করুন
1. অ্যাপ চালান → **সেবা → সিঙ্ক ও অ্যাকাউন্ট**।
2. Firebase কার্ডে "সংযুক্ত" দেখাবে → **লগইন → নতুন অ্যাকাউন্ট খুলুন** (আপনার ইমেইল/পাসওয়ার্ড)।
3. কিছু এন্ট্রি দিন → **এখনই সিঙ্ক করুন** → "সিঙ্ক সম্পন্ন ✅"।
4. Firebase console → Firestore-এ `users → {আপনার uid} → persons / ledger_entries …` দেখা যাবে।

## সমস্যা হলে
- **Gradle/Kotlin cache আটকে গেলে** (আগে Live Chat-এ হয়েছিল): project ফোল্ডারে `flutter clean`, তারপর `android` ফোল্ডারে `gradlew.bat --stop`, তারপর `flutter pub get` ও `flutter run`।
- **"Firebase সেটআপ হয়নি" দেখালে**: `lib/firebase_options.dart`-এ এখনো `REPLACE_ME` আছে মানে ধাপ ৫ শেষ হয়নি।
- **Permission denied (Firestore)**: ধাপ ৪-এর rules publish হয়নি, অথবা অ্যাপে লগইন করা নেই।
- API key public repo-তে commit করবেন না — এই key client key হলেও সাবধানে রাখুন।

## ডেটা কোথায় থাকে
`users/{আপনার uid}/{entity}/{recordId}` — প্রতিটা document-এ `userId`, `version`, `updatedAtMs`, `isDeleted` (tombstone) থাকে। Sync engine-এর নিয়ম: একই রেকর্ড কখনো দুইবার ওঠে না, নতুন লেখা পুরনোটাকে জেতে, delete সবসময় tombstone (ইতিহাস থাকে)।
