# Screen inventory — audited from the user's Stitch zip (2026-11-13)

Zip checked file by file. What is actually inside:

- **21 `code.html` files, 20 `screen.png`, 19 named screen folders, 1 DESIGN.md**
- The prompt says "79-screen design" — **the zip does not contain 79 screens.**
  The remaining screens must be designed fresh, following the same
  `bengal_ledger_tactile/DESIGN.md` system. Nothing will be invented and
  labelled as "from your design".

## Screens present in the zip (19 + root variant)

| # | Folder | Screen (from its <title>) | Module |
|---|--------|---------------------------|--------|
| 1 | smart_hisab_main_dashboard | মূল ড্যাশবোর্ড (also a variant at zip root) | Dashboard |
| 2 | daily_hisab_ledger | দৈনিক হিসাব খাতা | Daily Hisab |
| 3 | baki_customer_ledger | বাকি খাতা ও কাস্টমার | Baki Hisab |
| 4 | baki_khata_due_ledger | বাকি খাতা (due view, same title as #3) | Baki / Overdue |
| 5 | customer_profile_statement | গ্রাহক প্রোফাইল ও পূর্ণ খতিয়ান | Person profile |
| 6 | mfs_dashboard | মোবাইল ব্যাংকিং ও এমএফএস | Mobile Banking |
| 7 | mfs_transaction_entry | এমএফএস লেনদেন এন্ট্রি | MFS entry |
| 8 | mobile_recharge_hub | মোবাইল রিচার্জ ড্যাশবোর্ড | Recharge |
| 9 | quick_recharge_interface | দ্রুত মোবাইল রিচার্জ | Recharge entry |
| 10 | personal_hisab_dashboard | ব্যক্তিগত হিসাব ড্যাশবোর্ড | Personal Hisab |
| 11 | add_personal_expense | নতুন ব্যক্তিগত খরচ এন্ট্রি | Personal expense |
| 12 | person_directory_money_send | ব্যক্তি ডিরেক্টরি ও টাকা পাঠানো | Family transfer |
| 13 | personal_transaction_history | ব্যক্তিগত লেনদেন ইতিহাস | Personal history |
| 14 | personal_reports_analytics | ব্যক্তিগত রিপোর্ট ও বিশ্লেষণ | Reports |
| 15 | profit_loss_dashboard | লাভ-ক্ষতি ড্যাশবোর্ড | Profit & Loss |
| 16 | cash_reconcile_hub | ক্যাশ রিকনসিলিয়েশন | Cash reconcile |
| 17 | tokri_vara_rental_hub | টোকরি ভাড়া ড্যাশবোর্ড | Tokri Vara |
| 18 | somity_collection_hub | সমিতি ও কিস্তি সঞ্চয় | Somity |
| 19 | face_scan_verification | ফেস আইডি ভেরিফিকেশন | Face verification |
| 20 | business_settings_categories | ব্যবসা সেটিংস ও ক্যাটাগরি (code.html only, no PNG) | Settings |

Design system: `bengal_ledger_tactile/DESIGN.md` — primary #005138,
container #176B4D, surface #EFFDF3, Inter for numbers, Noto Sans Bengali
for Bangla, provider colours (bKash #E2136E, Nagad #F7941D, Rocket #8C3494,
Upay #FFC423, GP #00A3E0, Robi #ED1C24, Banglalink #FF6600, Airtel #E40000,
Teletalk #008D36). All tokens are wired in `lib/app/app_colors.dart`.

## Screens in the master prompt with NO design in the zip (build new, same system)

Auth/Login • আজকের আদায় (Today's Collection, §7 — the most important new
screen) • Collection schedule setup per person • Overdue details (বকেয়া) •
Daily closing / reopen • Income entry • Business expense entry •
bKash/Nagad/Rocket/Upay separate ledgers • Operator-wise recharge detail •
Somity member management • Rental attendance / absence / leave •
Monthly & Yearly collection views • Business reports + PDF/Excel export •
Notifications • Backup & Recovery • Sync status • Staff/roles.

## Possible duplicate to confirm with the user
`baki_customer_ledger` and `baki_khata_due_ledger` carry the same title;
they look like list vs due-detail variants of Baki Khata. Treated as two
screens above; confirm if one replaces the other.
