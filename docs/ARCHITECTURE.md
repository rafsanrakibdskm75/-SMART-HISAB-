# Smart Hisab — architecture (Stage 1)

Clean architecture, offline-first (Master Prompt §9, §19):

    lib/
      core/     money.dart (integer poisha, Bangla digits, lakh grouping)
                dhaka_time.dart (Asia/Dhaka business dates, UTC+6)
      domain/   collection_models.dart / collection_engine.dart  ← the rules
                daily_ledger.dart (daily summary, closing, rollover)
                sync_queue.dart (idempotent sync ops, pre-upload validation)
      data/     db/tables.dart + app_database.dart (Drift/SQLite, schema.sql)
                repositories/ (Stage 2: Person, Ledger, Collection, Sync)
      app/      app_colors.dart + theme.dart (Stitch design tokens, M3)
      features/ dashboard/ collection/ baki/ mfs/ recharge/ personal/
                tokri/ somity/ reports/ settings/ backup/ (one folder/screen)

Data flow: UI reads ONLY the local DB. Writes save locally first, enqueue a
sync op (recordId + localVersion = deterministic op ID), and the Sync Engine
uploads when connectivity returns, marks Synced only after the Firestore
write is acknowledged, downloads remote changes, and merges with tombstones.
Conflicts on financial rows are never auto-overwritten: versions are
compared, the row is flagged Conflict, and the audit log keeps both versions.

Money: integer poisha end to end. Dates: Dhaka business-date strings
(yyyy-MM-dd) in the DB; instants are UTC epoch milliseconds.

Stage map: S1 architecture+DB+models (this pack) → S2 repositories, daily
accounting, persons, ledger → S3 collection schedules, missed/partial,
overdue dashboard → S4 MFS, recharge, personal, Tokri, Somity → S5 Firebase
sync engine, conflict, backup → S6 reports, export, notifications, security
→ S7 UI integration for all screens, performance, release APK.
