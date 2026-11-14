# Stitch screen inventory and implementation map

The Stitch archive is design input only. Screens below have no matching Flutter implementation yet unless stated in the Status column. Native widgets should follow `bengal_ledger_tactile/DESIGN.md`; the HTML files use web styling and are references, not runtime assets.

| Stitch folder | Screen / feature mapping | Current Flutter status |
|---|---|---|
| `smart_hisab_splash_screen` | Launch / brand intro | Not implemented |
| `_2` | Login and registration | Not implemented; Firebase Auth unavailable |
| `smart_hisab_main_dashboard` | Main business dashboard | Partial: local cash summary, ledger, quick actions in `lib/main.dart` |
| `_1` | Alternate main dashboard concept | Not implemented; review against primary dashboard |
| `daily_hisab_ledger` | Daily ledger and close | Partial: ledger and entry UI; no close/reconciliation workflow |
| `baki_customer_ledger` | Customer / baki ledger | Partial: person directory and due collection; no full statement |
| `baki_khata_due_ledger` | Due list and collection status | Partial: today's obligations and partial collection |
| `customer_profile_statement` | Customer profile and statement | Not implemented |
| `person_directory_money_send` | Person directory / money send | Partial: person directory; money send not implemented |
| `mfs_dashboard` | Mobile financial service accounts | Not implemented |
| `mfs_transaction_entry` | MFS transaction form | Not implemented |
| `mobile_recharge_hub` | Recharge dashboard | Not implemented |
| `quick_recharge_interface` | Recharge form | Not implemented |
| `somity_collection_hub` | Somity / installment collection | Not implemented |
| `tokri_vara_rental_hub` | Tokri rental management | Not implemented |
| `personal_hisab_dashboard` | Personal accounts | Not implemented |
| `add_personal_expense` | Personal expense entry | Not implemented |
| `personal_transaction_history` | Personal transaction history | Not implemented |
| `personal_reports_analytics` | Personal analytics | Not implemented |
| `profit_loss_dashboard` | Profit and loss report | Partial: totals from local ledger only; no date/category filtering |
| `cash_reconcile_hub` | Cash reconciliation / daily close | Not implemented |
| `business_settings_categories` | Business settings and categories | Not implemented |
| `face_scan_verification` | Biometric verification | Not implemented; requires platform/auth design |
| `khata_book_logo` | Brand asset | Reference image only |
| `smart_hisab_official_fintech_brand_logo_identity_system` | Brand identity | Reference image only |
| `bengal_ledger_tactile` | Design tokens and visual system | Reference in `DESIGN.md` |

Archive inspection found 23 `code.html` files, 25 PNG files and one design markdown file. The 23 HTML files include 20 business/auth screen designs and three supporting HTML files; folder names are the stable inventory key. The design brief specifies a green ledger palette (primary `#176B4D`), rounded cards, Bangla-friendly typography, Inter-style numeric display, and semantic financial colors. Font files are not included.

## Current architecture and gaps

- `lib/data/local/app_database.dart` is the only pre-existing Dart source. It defines four Drift tables: people, obligations, collection payments and ledger entries. Money is stored as integer poisha.
- The app has no Firebase packages/configuration, repositories, sync queue, auth, audit/reversal workflow, backup/restore, report logic or business screens.
- The current native shell implements local income/expense entries, people, scheduled obligations, collections, a daily ledger and simple all-time income/expense totals. Other business modules show an explicit not-yet-available message; they do not create fake transactions.
- The obligation insertion path now ignores a duplicate person/day instead of overwriting a previously recorded amount. It does not yet provide a correction/reversal workflow.
- A debug-signed release APK was produced for build verification. No production signing configuration or Firebase project credentials are present. Multi-device sync and security rules remain unconfigured.

## Suggested implementation order

1. Generate Drift code and add local database/repository tests for idempotent obligations, collection atomicity, and integer money calculations.
2. Design schema migrations for categories, accounts, business modules, audit events and reversal records before expanding writes.
3. Implement the daily ledger and customer collection flows against local storage, then the remaining business modules.
4. Add Firebase Auth, per-business security rules, durable idempotent sync and conflict review after a Firebase project is configured.
5. Add backup/restore with checkpointing, then device/offline integration coverage.
6. Translate the Stitch screens into native Flutter components and verify each mapped screen.
