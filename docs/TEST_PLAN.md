# Mandatory tests (Master Prompt §20) — status

| Test | What | Status |
|------|------|--------|
| A Offline transaction | expense survives app restart offline | ✅ LOGIC VERIFIED in tool/verify_stage2.dart (snapshot/restore); on-device Drift persistence is the same contract |
| B Offline collection | payment offline, daily balance correct | ✅ VERIFIED in tool/verify_stage3.dart (payment posts to the daily ledger, collection total matches) |
| C Missed day | old due stays separate | ✅ VERIFIED in tool/verify.dart |
| D Partial payment | 200 → pay 100 → pay 50, remaining 50 | ✅ VERIFIED in tool/verify.dart |
| E Firebase sync | 20 offline tx upload exactly once | Stage 5 (needs your Firebase project) |
| F Multiple devices | payment on A appears on B | Stage 5 |
| G Recovery | backup → clear data → restore, balances match | Stage 5 |
| H Daily rollover | close yesterday, opening = closing, history kept | ✅ VERIFIED in tool/verify.dart |
| I Duplicate prevention | interrupted upload retried, no duplicates | ✅ logic VERIFIED (deterministic op IDs); network level Stage 5 |
| J Long-term offline | days offline, then full sync | Stage 5 |

v1.0.1 audit (2026-11-13): tool/verify_stage7.dart adds 45 adversarial checks (all failed pre-fix where noted in docs/BUGFIX_REPORT.md); test/drift_schema_test.dart runs 4 tests against a real in-memory SQLite database via Drift (all 16 tables, close/reopen, settings, collection transaction, recharge stock safety). Run flutter tests with LD_LIBRARY_PATH pointing at a libsqlite3.so on Linux dev machines.

Stage 7 (2026-11-13): platform folders generated (Flutter 3.35.7 template, org com.smarthisab), icons installed from the owner's logo kit, Android signing wired for key.properties, version 1.0.0+1, docs/RELEASE.md + docs/DEVICE_TEST_CHECKLIST.md (Tests A–J as on-device steps). APK build on THIS VM is blocked: sdkmanager cannot fetch SDK packages through the VM egress proxy (crashes fetching the remote repository) — build runs on the owner's PC per RELEASE.md. flutter analyze remains 0 errors; all 194 logic checks still pass.

Stage 6 also verified (tool/verify_stage6.dart, 37 checks): Baki FIFO aging (payments settle oldest credits first regardless of entry order — an order-dependent first version failed 7 checks and was rewritten pool-first), due list + full settlement, period reports (personal + own-account transfers excluded from profit), CSV with BOM/names/taka decimals, backup envelope round-trip + checksum tamper rejection + junk rejection + in-place restore, settings persistence through snapshot/restore, reminder plan composition (closing/overdue/low-stock, Bangla digits).

Stage 5 also verified at the ENGINE level (tool/verify_stage5.dart, 27 checks): deterministic parents-first push order; Test E (offline set drains fully, second sync is a no-op); Tests F+I (crash after 2 of 5 pushes → retry sends only the remaining 3, every opId applied exactly once, version-bump edit = one new op); backoff 1s→2s→4s capped at 5 min; conflict policy (newer wins, version breaks ties, tombstone wins exact ties, newer edit resurrects); pull merge. Live Firestore transport compiles (flutter analyze 0 errors) but runs only against the owner's own Firebase project — on-device verification pending his setup (docs/FIREBASE_SETUP.md).

Stage 4 also verified (tool/verify_stage4.dart, 28 checks): per-provider MFS balances from the ledger, transfer neutrality (own-account transfers never change total money), MFS/recharge commission booked as income (not sale), recharge stock deduction + insufficient-stock refusal, personal entries never move the business closing while family transfer does, Tokri attendance billing (present charges, absent/leave free, re-mark overwrites, collection zeroes due), Somity money booked under the somity module only, module-state snapshot/restore. Full-project `flutter analyze` (Flutter 3.35.7): 0 errors; `flutter pub get`: OK.

Stage 3 also verified (tool/verify_stage3.dart, 31 checks): idempotent obligation generation, schedule change forward-only, targeted overdue settlement by exact date, holiday GREY exclusion, pause/resume generation, advance + overpay credit, collection snapshot/restore, closed-day payment block.

Stage 2 also verified (tool/verify_stage2.dart, 30 checks): person search by name/mobile/ID, BD mobile validation, soft-delete tombstones, reversal immutability, duplicate-ID rejection, closed-day entry block + audited reopen, person statement, pagination.

Also verified: money parsing/formatting (no floats, Bangla digits, lakh
grouping), weekly/monthly schedule generation, advance = BLUE, holiday =
GREY, today's-collection dashboard buckets, SQL schema executed in SQLite
with the overdue query returning exactly the missed day.
