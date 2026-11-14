/// Stage 6 domain: Baki (customer dues) with FIFO aging, business reports
/// with CSV export, the backup envelope, reminder planning and settings.
/// All pure Dart, verified by tool/verify_stage6.dart.
library;

import 'dart:convert';

import '../core/dhaka_time.dart';
import '../core/money.dart';
import 'daily_ledger.dart';
import 'modules.dart';
import 'overdue.dart';

// ---------------- Baki (customer dues) ----------------

class BakiBalance {
  final String personId;
  final int duePoisha; // credit given - payments received (module baki)
  final DateTime? oldestUnpaidDate; // FIFO: oldest credit not yet covered
  final int daysOverdue; // today - oldestUnpaidDate (0 when no due)
  const BakiBalance({required this.personId, required this.duePoisha, this.oldestUnpaidDate, this.daysOverdue = 0});
}

/// Baki math from ledger entries of module `baki`:
/// out_ = goods/service given on credit, in_ = payment received.
/// Payments cover the OLDEST credits first (FIFO), so aging is honest.
BakiBalance bakiBalanceFor(List<LedgerEntry> entries, String personId, {required DateTime today}) {
  final mine = entries
      .where((e) => e.module == EntryModule.baki && e.personId == personId && !e.date.isAfter(today))
      .toList();
  // FIFO: the payment pool (whenever it arrived) settles the oldest
  // credits first. Walking entries in order would strand payments that
  // arrived before later credits — pool first, then age the credits.
  var paymentPool = 0;
  for (final e in mine) {
    if (e.direction == EntryDirection.in_) paymentPool += e.amountPoisha;
  }
  final credits = mine.where((e) => e.direction == EntryDirection.out_).toList()
    ..sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.id.compareTo(b.id); // deterministic FIFO on same-day ties
    });
  var due = 0;
  DateTime? oldest;
  for (final e in credits) {
    final covered = paymentPool >= e.amountPoisha ? e.amountPoisha : paymentPool;
    paymentPool -= covered;
    final uncovered = e.amountPoisha - covered;
    if (uncovered > 0) {
      due += uncovered;
      oldest ??= e.date;
    }
  }
  final days = (due > 0 && oldest != null) ? today.difference(oldest).inDays : 0;
  return BakiBalance(personId: personId, duePoisha: due, oldestUnpaidDate: due > 0 ? oldest : null, daysOverdue: days);
}

List<BakiBalance> bakiDueList(List<LedgerEntry> entries, {required DateTime today}) {
  final ids = <String>{};
  for (final e in entries) {
    if (e.module == EntryModule.baki && e.personId != null) ids.add(e.personId!);
  }
  final list = ids.map((id) => bakiBalanceFor(entries, id, today: today)).where((b) => b.duePoisha > 0).toList()
    ..sort((a, b) => b.duePoisha.compareTo(a.duePoisha));
  return list;
}

// ---------------- Reports ----------------

class PeriodReport {
  final DateTime from;
  final DateTime to;
  final int incomePoisha; // module income (incl. commissions)
  final int expensePoisha; // module expense
  final int collectionPoisha; // collection + somity
  final int bakiGivenPoisha;
  final int bakiReceivedPoisha;
  final Map<String, int> expenseByCategory;
  final Map<String, int> incomeByModule; // business modules only
  const PeriodReport({
    required this.from, required this.to, required this.incomePoisha, required this.expensePoisha,
    required this.collectionPoisha, required this.bakiGivenPoisha, required this.bakiReceivedPoisha,
    required this.expenseByCategory, required this.incomeByModule,
  });
  int get profitPoisha => incomePoisha - expensePoisha;
}

/// Business report over a period. Personal module is excluded (§14);
/// transfers between own accounts are excluded (they are not profit).
PeriodReport buildReport(List<LedgerEntry> entries, {required DateTime from, required DateTime to}) {
  var income = 0, expense = 0, collection = 0, bakiGiven = 0, bakiReceived = 0;
  final byCat = <String, int>{};
  final byModule = <String, int>{};
  for (final e in entries) {
    if (e.date.isBefore(from) || e.date.isAfter(to)) continue;
    if (e.module == EntryModule.personal) continue;
    if (e.category == 'transfer') continue;
    switch (e.module) {
      case EntryModule.income:
        if (e.direction == EntryDirection.in_) {
          income += e.amountPoisha;
          byModule['income'] = (byModule['income'] ?? 0) + e.amountPoisha;
        }
      case EntryModule.expense:
        if (e.direction == EntryDirection.out_) {
          expense += e.amountPoisha;
          final cat = e.category ?? 'অন্যান্য';
          byCat[cat] = (byCat[cat] ?? 0) + e.amountPoisha;
        }
      case EntryModule.collection:
      case EntryModule.somity:
        if (e.direction == EntryDirection.in_) collection += e.amountPoisha;
      case EntryModule.baki:
        if (e.direction == EntryDirection.out_) {
          bakiGiven += e.amountPoisha;
        } else {
          bakiReceived += e.amountPoisha;
        }
      default:
        if (e.direction == EntryDirection.in_) {
          byModule[e.module.name] = (byModule[e.module.name] ?? 0) + e.amountPoisha;
        }
    }
  }
  return PeriodReport(
    from: from, to: to, incomePoisha: income, expensePoisha: expense,
    collectionPoisha: collection, bakiGivenPoisha: bakiGiven, bakiReceivedPoisha: bakiReceived,
    expenseByCategory: byCat, incomeByModule: byModule);
}

String _csvCell(Object? v) {
  var s = '${v ?? ''}';
  // Spreadsheet formula injection: a note/name starting with = + - @ or a
  // control char is executed as a formula by Excel/Sheets — neutralise it.
  if (s.isNotEmpty && '=+-@\t\r'.contains(s[0])) s = "'$s";
  return s.contains(',') || s.contains('"') || s.contains('\n') ? '"${s.replaceAll('"', '""')}"' : s;
}

/// Integer-only taka formatting (no doubles near money, §14).
String _taka(int poisha) {
  final neg = poisha < 0;
  final a = poisha.abs();
  return '${neg ? '-' : ''}${a ~/ 100}.${(a % 100).toString().padLeft(2, '0')}';
}

/// UTF-8 BOM so Excel shows Bangla correctly.
String entriesCsv(List<LedgerEntry> entries, Map<String, String> nameOf) {
  final buf = StringBuffer('\uFEFF');
  buf.writeln('Date,Person,Module,Direction,Category,Amount (BDT),Note');
  final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));
  for (final e in sorted) {
    buf.writeln([
      dateKey(e.date), _csvCell(e.personId == null ? '' : nameOf[e.personId] ?? e.personId),
      e.module.name, e.direction == EntryDirection.in_ ? 'in' : 'out',
      _csvCell(e.category ?? ''), _taka(e.amountPoisha), _csvCell(e.note ?? ''),
    ].join(','));
  }
  return buf.toString();
}

String reportCsv(PeriodReport r) {
  final buf = StringBuffer('\uFEFF');
  buf.writeln('Smart Hisab Report,${dateKey(r.from)},${dateKey(r.to)}');
  buf.writeln('Income (BDT),${_taka(r.incomePoisha)}');
  buf.writeln('Expense (BDT),${_taka(r.expensePoisha)}');
  buf.writeln('Profit (BDT),${_taka(r.profitPoisha)}');
  buf.writeln('Collection (BDT),${_taka(r.collectionPoisha)}');
  buf.writeln('Baki given (BDT),${_taka(r.bakiGivenPoisha)}');
  buf.writeln('Baki received (BDT),${_taka(r.bakiReceivedPoisha)}');
  buf.writeln('Expense by category,');
  for (final e in r.expenseByCategory.entries) {
    buf.writeln('${_csvCell(e.key)},${_taka(e.value)}');
  }
  return buf.toString();
}

// ---------------- Backup envelope ----------------

/// FNV-1a 32-bit — a tamper check, not cryptography. It catches truncated
/// or edited backup files before a restore is attempted.
String fnv1a(String s) {
  var hash = 0x811c9dc5;
  for (final byte in utf8.encode(s)) {
    hash ^= byte;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

const backupAppTag = 'smart_hisab';
const backupFormatVersion = 1;

String makeBackup(String snapshotJson, {required DateTime exportedAt}) {
  return jsonEncode({
    'app': backupAppTag,
    'format': backupFormatVersion,
    'exportedAt': exportedAt.toUtc().toIso8601String(),
    'checksum': fnv1a(snapshotJson),
    'data': snapshotJson,
  });
}

/// Returns (snapshotJson, null) on success or (null, error) — never throws
/// on bad user input, because restore files come from share sheets.
(String?, String?) parseBackup(String backupJson) {
  try {
    final j = jsonDecode(backupJson) as Map<String, Object?>;
    if (j['app'] != backupAppTag) return (null, 'এটা Smart Hisab-এর ব্যাকআপ নয়');
    if (j['format'] != backupFormatVersion) return (null, 'ব্যাকআপের ফরম্যাট মেলেনি (format ${j['format']})');
    final data = j['data'] as String?;
    if (data == null) return (null, 'ব্যাকআপে ডেটা নেই');
    if (fnv1a(data) != j['checksum']) return (null, 'ব্যাকআপ ফাইল নষ্ট/বদলানো হয়েছে (checksum মেলেনি)');
    jsonDecode(data); // must be valid JSON
    return (data, null);
  } catch (_) {
    return (null, 'ব্যাকআপ ফাইল পড়া যাচ্ছে না');
  }
}

// ---------------- Reminder plan ----------------

enum ReminderKind { dailyClosing, overdue, lowStock, somityDue }

class ReminderItem {
  final ReminderKind kind;
  final String title;
  final String body;
  const ReminderItem(this.kind, this.title, this.body);
}

/// Pure planner: given the day's facts, which reminders should fire?
/// The notification service only displays this plan.
List<ReminderItem> buildReminderPlan({
  required DateTime today,
  required bool yesterdayClosed,
  required List<PersonOverdue> overdue,
  required Map<String, int> operatorBalances,
  required int lowStockThresholdPoisha,
}) {
  final items = <ReminderItem>[];
  if (!yesterdayClosed) {
    items.add(const ReminderItem(ReminderKind.dailyClosing, 'দৈনিক হিসাব বন্ধ হয়নি',
        'গতকালের দিন এখনো close করা হয়নি — হিসাব মিলিয়ে close করুন।'));
  }
  final totalOverdue = overdue.fold<int>(0, (a, r) => a + r.totalPoisha);
  if (totalOverdue > 0) {
    items.add(ReminderItem(ReminderKind.overdue, 'বকেয়া আদায় বাকি',
        '${toBanglaDigits(overdue.length.toString())} জনের কাছে মোট ${formatBdt(totalOverdue, banglaDigits: true)} বকেয়া আছে।'));
  }
  for (final e in operatorBalances.entries) {
    if (e.value < lowStockThresholdPoisha) {
      items.add(ReminderItem(ReminderKind.lowStock, 'রিচার্জ স্টক কম',
          '${telecomOperatorsBn[e.key] ?? e.key} ব্যালেন্স মাত্র ${formatBdt(e.value, banglaDigits: true)} — স্টক তুলুন।'));
    }
  }
  return items;
}

// ---------------- Settings ----------------

class AppSettings {
  final String businessName;
  final String ownerName;
  final String mobile;
  final String address;
  final int lowStockThresholdPoisha;
  final int defaultRechargeCommissionBp; // basis points, 280 = 2.8%
  final bool dailyClosingReminder;
  final int closingReminderHour; // 0-23 Dhaka
  final int closingReminderMinute;
  // v1.1.3 — account/session (login, create account, fingerprint).
  final String accountEmail;
  final String localPasswordHash; // sha256(salt + password); never plain text
  final String localPasswordSalt;
  final bool biometricEnabled;
  final bool offlineMode; // owner chose "offline-e chaliye jan" at the gate
  const AppSettings({
    this.businessName = 'আমার দোকান', this.ownerName = '', this.mobile = '', this.address = '',
    this.lowStockThresholdPoisha = 50000, // ৳500
    this.defaultRechargeCommissionBp = 280,
    this.dailyClosingReminder = true, this.closingReminderHour = 21, this.closingReminderMinute = 30,
    this.accountEmail = '', this.localPasswordHash = '', this.localPasswordSalt = '',
    this.biometricEnabled = false, this.offlineMode = false,
  });
  AppSettings copyWith({
    String? businessName, String? ownerName, String? mobile, String? address,
    int? lowStockThresholdPoisha, int? defaultRechargeCommissionBp,
    bool? dailyClosingReminder, int? closingReminderHour, int? closingReminderMinute,
    String? accountEmail, String? localPasswordHash, String? localPasswordSalt,
    bool? biometricEnabled, bool? offlineMode,
  }) => AppSettings(
        businessName: businessName ?? this.businessName, ownerName: ownerName ?? this.ownerName,
        mobile: mobile ?? this.mobile, address: address ?? this.address,
        lowStockThresholdPoisha: lowStockThresholdPoisha ?? this.lowStockThresholdPoisha,
        defaultRechargeCommissionBp: defaultRechargeCommissionBp ?? this.defaultRechargeCommissionBp,
        dailyClosingReminder: dailyClosingReminder ?? this.dailyClosingReminder,
        closingReminderHour: closingReminderHour ?? this.closingReminderHour,
        closingReminderMinute: closingReminderMinute ?? this.closingReminderMinute,
        accountEmail: accountEmail ?? this.accountEmail,
        localPasswordHash: localPasswordHash ?? this.localPasswordHash,
        localPasswordSalt: localPasswordSalt ?? this.localPasswordSalt,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        offlineMode: offlineMode ?? this.offlineMode);
  Map<String, Object?> toJson() => {
        'businessName': businessName, 'ownerName': ownerName, 'mobile': mobile, 'address': address,
        'lowStockThresholdPoisha': lowStockThresholdPoisha,
        'defaultRechargeCommissionBp': defaultRechargeCommissionBp,
        'dailyClosingReminder': dailyClosingReminder,
        'closingReminderHour': closingReminderHour, 'closingReminderMinute': closingReminderMinute,
        'accountEmail': accountEmail, 'localPasswordHash': localPasswordHash,
        'localPasswordSalt': localPasswordSalt, 'biometricEnabled': biometricEnabled,
        'offlineMode': offlineMode,
      };
  factory AppSettings.fromJson(Map<String, Object?> j) => AppSettings(
        businessName: j['businessName'] as String? ?? 'আমার দোকান',
        ownerName: j['ownerName'] as String? ?? '', mobile: j['mobile'] as String? ?? '',
        address: j['address'] as String? ?? '',
        lowStockThresholdPoisha: j['lowStockThresholdPoisha'] as int? ?? 50000,
        defaultRechargeCommissionBp: j['defaultRechargeCommissionBp'] as int? ?? 280,
        dailyClosingReminder: j['dailyClosingReminder'] as bool? ?? true,
        closingReminderHour: j['closingReminderHour'] as int? ?? 21,
        closingReminderMinute: j['closingReminderMinute'] as int? ?? 30,
        accountEmail: j['accountEmail'] as String? ?? '',
        localPasswordHash: j['localPasswordHash'] as String? ?? '',
        localPasswordSalt: j['localPasswordSalt'] as String? ?? '',
        biometricEnabled: j['biometricEnabled'] as bool? ?? false,
        offlineMode: j['offlineMode'] as bool? ?? false);
}
