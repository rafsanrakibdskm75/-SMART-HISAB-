/// Daily accounting (§2): a day closes into a summary; history is never
/// deleted or reset. Tomorrow opens with yesterday's closing balance,
/// while yesterday's transactions and outstanding dues stay untouched.
library;

import '../core/dhaka_time.dart';

enum EntryDirection { in_, out_ }

/// Module tags keep money streams separate (§14): Somity collections are not
/// profit, recharge commission is not recharge sale, MFS stays per-provider.
enum EntryModule {
  dailyHisab, income, expense, baki, collection,
  bkash, nagad, rocket, upay, bank, cash,
  recharge, personal, familyTransfer, tokriVara, somity,
}

class LedgerEntry {
  final String id; // immutable (§12)
  final DateTime date; // Dhaka business date, date-only UTC
  final EntryDirection direction;
  final int amountPoisha; // always positive; direction carries the sign
  final EntryModule module;
  final String? personId;
  final String? accountId;
  final String? category;
  final String? note;
  final bool isReversal;
  final String? reversesEntryId; // a reversal is a NEW linked entry (§14)
  const LedgerEntry({
    required this.id,
    required this.date,
    required this.direction,
    required this.amountPoisha,
    required this.module,
    this.personId,
    this.accountId,
    this.category,
    this.note,
    this.isReversal = false,
    this.reversesEntryId,
  });
  int get signedPoisha => direction == EntryDirection.in_ ? amountPoisha : -amountPoisha;
}

class DailySummary {
  final DateTime date;
  final int openingPoisha;
  final int totalInPoisha;
  final int totalOutPoisha;
  final int collectionPoisha; // collections tracked inside totalIn, shown separately
  int get closingPoisha => openingPoisha + totalInPoisha - totalOutPoisha;
  const DailySummary({
    required this.date,
    required this.openingPoisha,
    required this.totalInPoisha,
    required this.totalOutPoisha,
    required this.collectionPoisha,
  });
}

/// Balances are always recalculated from ledger entries (§14), never stored
/// as a mutable number that can drift.
/// The business day view EXCLUDES the personal module: personal money is
/// tracked in its own books (§14) and must not move the shop's closing.
DailySummary summarizeDay(List<LedgerEntry> allEntries, DateTime date, {required int openingPoisha}) {
  var inSum = 0, outSum = 0, coll = 0;
  for (final e in allEntries) {
    if (e.module == EntryModule.personal) continue;
    if (dateKey(e.date) != dateKey(date)) continue;
    if (e.direction == EntryDirection.in_) {
      inSum += e.amountPoisha;
      if (e.module == EntryModule.collection || e.module == EntryModule.somity) {
        coll += e.amountPoisha;
      }
    } else {
      outSum += e.amountPoisha;
    }
  }
  return DailySummary(date: date, openingPoisha: openingPoisha, totalInPoisha: inSum, totalOutPoisha: outSum, collectionPoisha: coll);
}

/// Opening balance of [date] = closing balance of the day before it,
/// computed over the full history (which is never deleted).
int openingBalanceFor(List<LedgerEntry> allEntries, DateTime date) {
  var balance = 0;
  for (final e in allEntries) {
    if (e.module == EntryModule.personal) continue; // business view (§14)
    if (e.date.isBefore(date)) balance += e.signedPoisha;
  }
  return balance;
}

class DayClosing {
  final DateTime date;
  final DailySummary summary;
  final String closedBy;
  final DateTime closedAtUtc;
  bool reopened = false;
  final List<String> auditLog = []; // reopen/correction trail (§2)
  DayClosing({required this.date, required this.summary, required this.closedBy, required this.closedAtUtc});

  /// Reopening requires an authorized actor and always writes an audit line.
  void reopen({required String by, required String reason, required DateTime atUtc}) {
    reopened = true;
    auditLog.add('${dateKey(atUtc)} reopened by $by: $reason');
  }
}
