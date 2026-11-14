/// Stage 4 module domain: MFS, recharge, personal, Tokri Vara, Somity.
/// Everything financial still flows through the shared LedgerEntry (§19);
/// these are the module-specific shapes and pure calculations.
library;

import '../core/dhaka_time.dart';
import 'daily_ledger.dart';

// ---------------- MFS (Mobile Banking) ----------------

/// Provider accounts are EntryModules so balances stay separate per
/// provider (§14) and are always recalculated from entries.
const mfsProviders = <EntryModule, String>{
  EntryModule.bkash: 'বিকাশ',
  EntryModule.nagad: 'নগদ',
  EntryModule.rocket: 'রকেট',
  EntryModule.upay: 'উপায়',
  EntryModule.bank: 'ব্যাংক',
  EntryModule.cash: 'ক্যাশ',
};

enum MfsTxType { cashIn, cashOut, sendMoney, payment, receive }

/// Balance of one provider account from ledger entries (in − out).
int accountBalancePoisha(List<LedgerEntry> entries, EntryModule provider) {
  var bal = 0;
  for (final e in entries) {
    if (e.module == provider) bal += e.signedPoisha;
  }
  return bal;
}

/// A transfer between the owner's OWN accounts is a linked pair (§14:
/// never double-counted). Out of A + into B, sharing a group id in their
/// ids (trf_<group>_out / trf_<group>_in); the pair nets to zero.
({LedgerEntry outEntry, LedgerEntry inEntry}) makeTransfer({
  required String groupId,
  required EntryModule from,
  required EntryModule to,
  required int amountPoisha,
  required DateTime date,
  String? note,
}) {
  return (
    outEntry: LedgerEntry(
      id: 'trf_${groupId}_out', date: date, direction: EntryDirection.out_,
      amountPoisha: amountPoisha, module: from, category: 'transfer',
      note: note ?? 'Transfer to ${mfsProviders[to]}'),
    inEntry: LedgerEntry(
      id: 'trf_${groupId}_in', date: date, direction: EntryDirection.in_,
      amountPoisha: amountPoisha, module: to, category: 'transfer',
      note: note ?? 'Transfer from ${mfsProviders[from]}'),
  );
}

/// Commission earned inside a period for one category (MFS commission and
/// recharge commission are income — the SALE amount is not profit, §14).
int commissionTotalPoisha(List<LedgerEntry> entries, {required String category, required DateTime from, required DateTime to}) {
  var sum = 0;
  for (final e in entries) {
    if (e.module == EntryModule.income && e.category == category && e.direction == EntryDirection.in_ && !e.date.isBefore(from) && !e.date.isAfter(to)) {
      sum += e.amountPoisha;
    }
  }
  return sum;
}

// ---------------- Mobile Recharge ----------------

const telecomOperators = ['Grameenphone', 'Robi', 'Airtel', 'Banglalink', 'Teletalk'];
const telecomOperatorsBn = {
  'Grameenphone': 'গ্রামীণফোন', 'Robi': 'রবি', 'Airtel': 'এয়ারটেল',
  'Banglalink': 'বাংলালিংক', 'Teletalk': 'টেলিটক',
};

class RechargeRecord {
  final String id;
  final String operator;
  final String number;
  final int amountPoisha; // face value sold to the customer
  final int commissionPoisha; // discount/commission earned by the shop
  final DateTime date;
  const RechargeRecord({
    required this.id, required this.operator, required this.number,
    required this.amountPoisha, required this.commissionPoisha, required this.date,
  });
  Map<String, Object?> toJson() => {
        'id': id, 'operator': operator, 'number': number,
        'amountPoisha': amountPoisha, 'commissionPoisha': commissionPoisha, 'date': dateKey(date),
      };
  factory RechargeRecord.fromJson(Map<String, Object?> j) => RechargeRecord(
        id: j['id'] as String, operator: j['operator'] as String, number: j['number'] as String,
        amountPoisha: j['amountPoisha'] as int, commissionPoisha: j['commissionPoisha'] as int,
        date: parseDateKey(j['date'] as String),
      );
}

/// Commission from a percentage given in basis points (e.g. 280 = 2.80%),
/// integer math only: amount * bp / 10000, truncated to whole poisha.
int commissionFor(int amountPoisha, int basisPoints) => (amountPoisha * basisPoints) ~/ 10000;

// ---------------- Personal Hisab ----------------

class PersonalSummary {
  final int incomePoisha;
  final int expensePoisha;
  final Map<String, int> expenseByCategory;
  const PersonalSummary({required this.incomePoisha, required this.expensePoisha, required this.expenseByCategory});
  int get netPoisha => incomePoisha - expensePoisha;
}

/// Personal books are ONLY the personal module (§14) — business entries
/// never leak in, and personal entries never move the business closing.
PersonalSummary personalSummary(List<LedgerEntry> entries, {required DateTime from, required DateTime to}) {
  var inc = 0, exp = 0;
  final byCat = <String, int>{};
  for (final e in entries) {
    if (e.module != EntryModule.personal) continue;
    if (e.date.isBefore(from) || e.date.isAfter(to)) continue;
    if (e.direction == EntryDirection.in_) {
      inc += e.amountPoisha;
    } else {
      exp += e.amountPoisha;
      final cat = e.category ?? 'অন্যান্য';
      byCat[cat] = (byCat[cat] ?? 0) + e.amountPoisha;
    }
  }
  return PersonalSummary(incomePoisha: inc, expensePoisha: exp, expenseByCategory: byCat);
}

// ---------------- Tokri Vara (rental) ----------------

enum AttendanceStatus { present, absent, leave }

class TokriRental {
  final String id;
  final String personId;
  final int tokriCount;
  final int dailyRatePoisha; // per tokri per day
  const TokriRental({required this.id, required this.personId, required this.tokriCount, required this.dailyRatePoisha});
  Map<String, Object?> toJson() => {'id': id, 'personId': personId, 'tokriCount': tokriCount, 'dailyRatePoisha': dailyRatePoisha};
  factory TokriRental.fromJson(Map<String, Object?> j) => TokriRental(
        id: j['id'] as String, personId: j['personId'] as String,
        tokriCount: j['tokriCount'] as int, dailyRatePoisha: j['dailyRatePoisha'] as int);
}

class TokriDay {
  final String rentalId;
  final DateTime date;
  final AttendanceStatus status;
  const TokriDay({required this.rentalId, required this.date, required this.status});
  Map<String, Object?> toJson() => {'rentalId': rentalId, 'date': dateKey(date), 'status': status.name};
  factory TokriDay.fromJson(Map<String, Object?> j) => TokriDay(
        rentalId: j['rentalId'] as String, date: parseDateKey(j['date'] as String),
        status: AttendanceStatus.values.byName(j['status'] as String));
}

/// Charge for one day: full count × rate only when present; absent and
/// leave days charge nothing (attendance drives the bill, §23–26).
int tokriDayChargePoisha(TokriRental rental, AttendanceStatus status) =>
    status == AttendanceStatus.present ? rental.tokriCount * rental.dailyRatePoisha : 0;

int tokriDuePoisha(TokriRental rental, List<TokriDay> days, {required DateTime from, required DateTime to}) {
  var due = 0;
  for (final day in days) {
    if (day.rentalId != rental.id) continue;
    if (day.date.isBefore(from) || day.date.isAfter(to)) continue;
    due += tokriDayChargePoisha(rental, day.status);
  }
  return due;
}

/// Rent already collected in a period comes from ledger entries
/// (module tokriVara, personId = renter).
int tokriCollectedPoisha(List<LedgerEntry> entries, String personId, {required DateTime from, required DateTime to}) {
  var sum = 0;
  for (final e in entries) {
    if (e.module == EntryModule.tokriVara && e.personId == personId && e.direction == EntryDirection.in_ && !e.date.isBefore(from) && !e.date.isAfter(to)) {
      sum += e.amountPoisha;
    }
  }
  return sum;
}
