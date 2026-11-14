# Bugfix Report — Smart Hisab v1.0.1 (2026-11-13 audit)

Point-by-point: every bug below was **confirmed by a failing test first**
(`tool/verify_stage7.dart`, 45 checks — 11 failed + 1 crash on v1.0.0;
`test/drift_schema_test.dart`, 4 tests on real SQLite), then fixed, then
re-verified: **194 old checks + 45 new checks + 5 flutter tests all pass,
`flutter analyze` = 0 errors, 0 warnings.**

## 🔴 Critical — would have broken the app on device
1. **8 database tables were never created.** docs/schema.sql defines
   daily_summaries, audit_log, backups, operator_balances, tokri_rentals,
   tokri_attendance, somity_members, app_settings — and the Drift
   repositories run SQL against them — but they were missing from
   `@DriftDatabase`. Daily closing, settings, recharge stock, Tokri and
   Somity would all have crashed with "no such table". → Tables added,
   schema v2 + migration, generated code rebuilt.
2. **The sync-queue table had the wrong name.** Drift generated
   `sync_queue_entries`; every raw-SQL enqueue writes to `sync_queue`.
   → `@override tableName = 'sync_queue'`.
3. **Recharge on a closed day ate the operator's stock.** Balance was
   deducted before the ledger post, which then threw (closed day) —
   stock gone, no record. → Validation first, ledger posts first, stock
   deducted last (both repositories).
4. **Receiving a collection payment was not atomic.** In-memory: the
   obligation was marked paid before the ledger post, so a failure left
   phantom payments. Drift: 4 separate writes. → Drift now uses one
   transaction, ledger first; in-memory validates the target before any
   money moves.

## 🟠 Money & accounting correctness
5. **Negative / zero payments were accepted** by the collection engine
   (a negative payment *reduced* a day's paid amount). → Rejected.
6. **A payment could land on the wrong person** — the engine matched
   obligations by date only. → It now matches person + date.
7. **Zero-amount allocations** were recorded when paying an already-full
   day. → Pure advance credit now records no allocation; both repos
   handle advance-only payments correctly.
8. **Out-of-order payments moved `lastAllocationDate` backwards**,
   corrupting the advance (BLUE) status. → Only moves forward.
9. **Entries could be reversed twice** (and a reversal itself reversed),
   double-counting money. → Both repositories now refuse.
10. **Re-closing a reopened day wiped its audit log** (in-memory).
    → Audit trail is carried into the new closing, with a re-close line.
11. **Monthly/yearly period summaries included personal money** in
    business totals, contradicting §14. → Personal module excluded.
12. **CSV export used floating point for taka** (precision loss on big
    amounts) and allowed **spreadsheet formula injection** via notes
    starting with `= + - @`. → Integer formatting; cells neutralised.

## 🟡 Data integrity & sync
13. **Money parser returned ৳0 for `"-"` / `"."`** instead of an error.
    → Amounts with no digits are rejected.
14. **`parseDateKey` silently rolled invalid dates** (`2026-02-30` →
    March 2). → Strict round-trip validation.
15. **`page()` crashed with RangeError** on negative page index.
    → Guarded.
16. **Person updates used the caller's version number** — a stale edit
    form re-used the same version (and sync opId). → Both repositories
    bump from the *stored* version; updating a missing person errors.
17. **Person update erased photo/mobile/address** when the form left
    them empty (Drift didn't even write photo_path). → Stored values are
    preserved for omitted nullable fields.
18. **Mutable records only ever synced their first version** — settings,
    schedules (pause didn't even enqueue), balances, rentals, attendance,
    Somity membership all enqueued as v1 forever. → Per-record version
    counters (`InMemoryStore.enqueueMutable`), persisted in backups.
19. **Sync pulls hard-deleted people** and could overwrite unsynced local
    edits. → Tombstones now soft-delete; records with a pending local
    edit are not overwritten by a pull.
20. **Drift gaps vs in-memory:** ledger entries never enqueued for sync;
    person soft-delete never enqueued; module posts never checked that
    the person exists; schedule save had no validation; daily close
    could overwrite a closed day and reopen a never-closed day silently;
    recharge history always showed ৳0 commission. → All aligned.

## 🔵 UX / platform
21. **Reminders nagged brand-new users**: "yesterday not closed" with no
    activity at all, plus all 5 operators "low stock" at ৳0. → Only an
    active unclosed day and actually-stocked operators remind.
22. **Notifications**: timezone DB was never initialised (reminder would
    fire at UTC time — 6 hours off), Android 13+ permission never
    requested, and same-kind notifications replaced each other (one id
    per kind). → Asia/Dhaka pinned, permission requested, unique ids.
23. **Stale "today"**: controllers captured the date at startup — an app
    left open past midnight kept showing yesterday (Test H). → Today
    rolls over on load/refresh.
24. **Future-dated Baki entries counted as due today.** → Aging ignores
    entries after today; FIFO order deterministic on same-day ties.
25. **Holiday could be marked on a day that already had payments**,
    vanishing it from summaries while the cash stayed in the ledger.
    → Blocked in both repositories.
26. **Input validation added**: schedule weekdays 1–7, day-of-month
    1–31, end ≥ start; recharge operator must be a known operator,
    number a valid BD mobile, commission 0–100%; rental count/rate;
    negative operator balances rejected; recharge/attendance against
    non-existent records rejected.
27. **iOS icon set had invalid idioms** (iPad sizes filed as iPhone).
    → Regenerated Contents.json: iPhone + iPad + marketing, 18 entries.
28. **Release signing crashed config-time** if `key.properties` existed
    but was incomplete. → Signing is configured only when complete.
29. Code health: 20 automated fixes (deprecated `withOpacity`,
    dropdown `value`, const) — analyzer warnings went 2 → 0.

## Known limitations (documented, not hidden)
- `graceDays` on a schedule is stored but still not applied to overdue
  classification — needs the grace value carried onto obligations
  (schema change); planned for v1.1.
- Advance payment *without any schedule* is not creatable; advance only
  exists as excess over a scheduled day (as in the master prompt §4).
- MFS cash-out is not blocked at zero balance (agent float can be owed
  by customers mid-day); the balance simply shows negative.
- Default bindings still run the in-memory repositories; the Drift swap
  in `lib/app/bindings.dart` is now fully tested but remains a manual
  step, together with the Firebase file handover.

## Addendum v1.0.2 — the two-device conflict audit (owner's question)
30. **Records were stamped with SYNC time, not EDIT time** — last-sync-won
    instead of last-edit-wins. SyncOp now stores `enqueuedAtMs` (the edit
    moment) and dirty records carry it. See docs/SYNC_CONFLICTS.md.
31. **Sync pushed blindly before pulling** — a device overwrote the server
    copy of a record another device had edited later. syncNow now pulls
    first, reconciles with `planSync` (winner per record), pushes only
    winners, and drops superseded ops.
32. **`markPushed` never cleared the queue** — record opIds
    (`entity:id:vN`) did not match queue opIds (`id_vN`), so every sync
    re-uploaded everything and pending never reached 0.
33. **`app_settings` was missing from the pull list**, and the pull
    watermark used client edit times (a late-syncing old edit could be
    skipped forever) — pulls now filter on the server timestamp and the
    watermark advances only to server times actually seen.
Verified by tool/verify_stage8.dart: 19 checks covering the owner's exact
9:50 ৳190 vs 10:50 ৳200 case from both devices, same-value case, all tie
rules, non-conflicting new entries, and the three bugs above.

## v1.0.3 addendum — duplicate সতর্কতা (owner-approved 2026-11-13)
Feature (asked after the same-time/same-name sync answer): Person list now
warns about possible duplicates instead of ever merging automatically.
- `findPossibleDuplicates` (domain/person.dart): groups live persons by
  normalised name (trim/collapse/case); a group is STRONG when every member
  shares one normalised mobile (+88/88/leading-0 and Bangla-digit forms
  unified). Same mobile with different names is NOT grouped (families
  share phones).
- Person list: amber banner ("Nটি নামে মিল আছে…", with the strong count)
  plus a ⚠ badge on each suspect row. `verify_stage10` 25/25.
- Review fixes on top of the first cut: (34) duplicate detection ran on
  the search-filtered subset — searching hid warnings and badges; it now
  always runs on the full directory. (35) Bangla-digit mobiles normalised
  before digit-stripping, so ০১৭… matches 017….

## v1.1.1 addendum — face recognition audit (fixes #36–41)
Method as before: adversarial checks FIRST (`test/face_flow_test.dart`
failed on v1.1.0 at the poisoning case), then fixes, then proof.
36. **Multi-face scan silently used the largest face** — a bystander
    closer to the camera could be "identified" as the customer. Scans
    now require exactly one face; otherwise a Bangla retake message.
37. **Far-face scans accepted** — a tiny face embeds unreliably. Scan
    now refuses below 0.10 frame width ("আরেকটু কাছে এসে তুলুন").
38. **Enrollment poisoning** — nothing stopped a DIFFERENT person's
    photo becoming customer A's 2nd/3rd sample, after which strangers
    would match A. New samples must match A's existing samples
    (scoreAgainst ≥ threshold) or enrollment is refused.
39. **Same face enrollable under two customer records** (the duplicate
    customer from v1.0.3, now in biometric form). `findFaceConflict`
    blocks it and names the customer who already owns that face.
40. **Orphan enrollments** — enrolling a missing/deleted person id
    created vectors nothing could clean up. Enroll now validates the
    person exists and is live first.
41. **One corrupt `face_enrollments` row crashed every scan** — the
    Drift repository now skips unparseable rows (getFor returns null).
Proof: face_flow_test (7 guard scenarios) + corrupt-row Drift test pass;
328 Dart checks, 9/9 flutter tests, analyze 0/0.
Not code-fixable here (device-only, already documented): EXIF/box
alignment on real cameras, MobileFaceNet threshold calibration in shop
lighting — both are DEVICE_TEST_CHECKLIST items.

## v1.1.5 addendum — session/auth audit (fixes #42–44) + new logo
Audit of the v1.1.3/v1.1.4 code; both bugs proven by failing tests first
(`test/session_flow_test.dart`, "v1.1.5 audit" group).
42. **Offline door bypassed the password gate.** With an account, the
    login screen still offered "অফলাইনে চালিয়ে যান", which persisted
    offlineMode — after which the gate never asked for a password again:
    anyone holding the phone walked in. Offline continue is now a no-op
    for account holders and the button is hidden for them.
43. **Session saves clobbered newer settings.** SessionController kept
    its splash-time AppSettings copy and saved it (biometric toggle,
    create account), silently reverting profile/reminder edits made
    meanwhile in Settings. All session saves now merge into a freshly
    loaded AppSettings first.
44. **Fingerprint auto-prompt could stack on a running password login**
    (and the login profile chip could show splash-time data). The login
    screen reloads settings on open and the prompt is busy-guarded.
Also in this version: the owner's new Khata Book logo replaces the
previous mark in all 63 icon slots + the in-app logo asset (adaptive
foreground re-cropped to the book symbol, visually verified). NOTE:
the artwork says "খাতা বুক / KHATA BOOK" while the app name remains
Smart Hisab — owner's call pending if he wants a rename.
Proof: 328 Dart checks, 18/18 flutter tests, analyze 0/0.

## v1.1.6 — toolchain rework (owner-requested pins, not bug fixes)
pubspec Dart SDK `^3.13.3`; Kotlin Gradle plugin 2.1.0 → 2.4.0;
`kotlinOptions` migrated to the `kotlin { compilerOptions }` DSL
(the old block is deprecated under Kotlin 2.x). Target environment:
Flutter with Dart 3.13.3 (3.50.x) + Android Studio Panda 1 // 2025.3.1.
Verified on the VM via a scratch copy (this VM's Flutter bundles
Dart 3.9.2 and cannot resolve ^3.13.3): analyze 0/0, 18/18 flutter
tests, verify suites green. The Android/Gradle build itself runs on
the owner's PC.
