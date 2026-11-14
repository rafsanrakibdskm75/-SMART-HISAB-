# On-Device Test Checklist — ফোনে বসে একে একে টিক দিন

Master Prompt-এর A–J test-গুলো ফোনের ভাষায়। Logic level-এ সব ইতিমধ্যে VM-এ pass (194 checks); এগুলো আসল ডিভাইসে চোখে দেখার জন্য।

## A — Data safety
- [ ] কিছু এন্ট্রি দিন → অ্যাপ kill করে আবার খুলুন → ডেটা আছে কিনা (Drift cutover-এর পর প্রযোজ্য; in-memory build-এ session-only)
- [ ] সেটিংস → ব্যাকআপ নিন → অ্যাপের ডেটা clear → Restore করুন → সব ফিরে এসেছে

## B — Offline collection
- [ ] Airplane mode on → একজনের পেমেন্ট নিন → Daily Hisab-এ collection total মিলেছে
- [ ] Net ফিরিয়ে সিঙ্ক (Firebase চালু থাকলে) → console-এ record দেখা যায়

## C — Missed day কখনো merge হয় না
- [ ] Rahim-এর daily ৳200 schedule দিন, মাঝে 2 দিন পেমেন্ট নেবেন না
- [ ] ৩য় দিনে খুলুন: বকেয়ায় 2 টা আলাদা দিনের লাইন, মোট ৳400 — এক লাইনে মেশেনি

## D — Partial payment
- [ ] ৳200-এর দিনে ৳120 নিন → হলুদ (আংশিক), বাকি ৳80
- [ ] পরে আরও ৳80 নিন → সবুজ; payment history-তে 2 টা আলাদা record

## E/F — Sync ও interrupted sync
- [ ] Offline-এ 5 টা এন্ট্রি → online হয়ে Sync Now → সব উঠেছে, দ্বিতীয়বার sync-এ নতুন কিছু ওঠে না
- [ ] Sync চলার মাঝে net বন্ধ করে আবার চালু → বাকিটুকুই ওঠে, duplicate নেই

## G — Daily closing
- [ ] দিন close করুন → ওই দিনে নতুন এন্ট্রি নেওয়া যায় না
- [ ] Reopen করুন (কারণ লিখে) → audit log-এ কারণ দেখা যায়
- [ ] পরের দিন opening = আগের closing

## H — Date rollover (Asia/Dhaka)
- [ ] রাত ১২টার পরে অ্যাপ খুলুন → নতুন দিনের হিসাব, পুরনো দিন History-তে অক্ষত

## I — Duplicate protection
- [ ] একই পেমেন্ট দুইবার save করার চেষ্টা → balance একবারই বদলায়

## J — Low-end performance
- [ ] 2GB RAM ফোনে: Person list scroll, আজকের আদায় খোলা, রিপোর্ট — lag ছাড়া চলে
- [ ] Reminder notification রাতের সময়ে আসে; ফোন restart-এর পরেও schedule থাকে

কোনো test fail করলে কোন ধাপে, কী দেখালেন — screenshot পাঠালেই ঠিক করে দেবো।

## Face ID (v1.1.0 — physical phone only)
1. Person খুলুন → "ফেস আইডি" card → Face enroll করুন: ভালো আলোতে সোজা মুখে ছবি তুলুন — সফল message আসতে হবে।
2. ইচ্ছা করে পাশ ফিরে / দূর থেকে ছবি তুলুন — Bangla কারণসহ reject হতে হবে।
3. Person list → উপরে ডানদিকে face icon → একই customer-এর ছবি তুলুন — নাম, মিল % ও বাকি পাওনা দেখাতে হবে।
4. Enroll করা নেই এমন লোকের ছবি তুলুন — "কোনো মিল পাওয়া যায়নি" আসতে হবে।
5. Profile থেকে Face enroll মুছে আবার scan করুন — আর মিলবে না।
6. মনে রাখুন: অন্য device-এ এই customer চিনবে না — embeddings sync হয় না (privacy), প্রতি device-এ আলাদা enroll লাগে।

## Splash / Login / Fingerprint (v1.1.3 — physical phone)
1. App খুলুন: সবুজ→হালকা splash-এর বদলে এখন হালকা mint splash আসবে (logo, FINTECH VERIFIED pill, Made With Md Nahidul Islam), ~1.5 সেকেন্ড পর login screen।
2. প্রথমবার: "নতুন অ্যাকাউন্ট তৈরি করুন" — business নাম, নাম, মোবাইল, ইমেইল, পাসওয়ার্ড দিয়ে তৈরি করুন; সরাসরি home-এ যাবে।
3. App পুরো বন্ধ করে আবার খুলুন: login চাইবে। ভুল পাসওয়ার্ড দিলে Bangla error আসতে হবে, ঠিকটা দিলে ঢুকবে।
4. Login-এর পর fingerprint চালুর dialog আসলে "চালু করুন" দিন। আবার বন্ধ করে খুললে fingerprint prompt আসতে হবে — fingerprint দিলে সরাসরি home।
5. Fingerprint বাতিল (cancel) করলে পাসওয়ার্ড form-এই থাকতে হবে, আটকে যাওয়া যাবে না।
6. Settings → "Fingerprint login" toggle off/on করে দেখুন।
7. আলাদা ফোনে fingerprint না থাকলে fingerprint button-ই দেখাবে না — পাসওয়ার্ডেই চলবে।
