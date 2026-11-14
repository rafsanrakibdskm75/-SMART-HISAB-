/// Person-wise daily collection — pure domain models (no Flutter, no DB).
/// Rules enforced here come from Master Prompt §3–§8:
///  * one obligation per scheduled day, generated separately;
///  * a missed day is NEVER merged into another day;
///  * a payment is allocated to ONE specific obligation (or marked advance);
///  * partial payments accumulate on that same obligation, originals kept.
library;

import '../core/dhaka_time.dart';

enum ScheduleType { daily, weekly, monthly, yearly, custom }

enum CollectionStatus {
  paid,      // GREEN  — fully paid
  partial,   // YELLOW — partially paid
  unpaid,    // RED    — not paid (today or missed)
  advance,   // BLUE   — paid in advance (before its date)
  notScheduled, // GREY — holiday / paused / not scheduled
}

class CollectionSchedule {
  final String id;
  final String personId;
  final int expectedPoisha;
  final ScheduleType type;
  final DateTime startDate; // date-only UTC
  final DateTime? endDate;
  final Set<int> weekdays; // 1=Mon..7=Sun, for weekly/custom
  final int? dayOfMonth;   // for monthly
  final int graceDays;
  final bool allowAdvance;
  final bool paused;
  final DateTime effectiveFrom; // schedule changes apply from here forward only (§6)

  const CollectionSchedule({
    required this.id,
    required this.personId,
    required this.expectedPoisha,
    required this.type,
    required this.startDate,
    this.endDate,
    this.weekdays = const {},
    this.dayOfMonth,
    this.graceDays = 0,
    this.allowAdvance = true,
    this.paused = false,
    required this.effectiveFrom,
  });

  bool isScheduledOn(DateTime date) {
    if (paused) return false;
    if (date.isBefore(startDate) || date.isBefore(effectiveFrom)) return false;
    if (endDate != null && date.isAfter(endDate!)) return false;
    switch (type) {
      case ScheduleType.daily:
        return true;
      case ScheduleType.weekly:
      case ScheduleType.custom:
        return weekdays.contains(date.weekday);
      case ScheduleType.monthly:
        final dom = dayOfMonth ?? startDate.day;
        final lastDay = DateTime.utc(date.year, date.month + 1, 0).day;
        return date.day == (dom > lastDay ? lastDay : dom);
      case ScheduleType.yearly:
        return date.month == startDate.month && date.day == startDate.day;
    }
  }
}

class CollectionObligation {
  final String id; // deterministic: personId + dateKey — idempotent generation
  final String personId;
  final String scheduleId;
  final DateTime date; // date-only UTC (Dhaka business date)
  final int expectedPoisha;
  int paidPoisha;
  bool isHoliday;
  DateTime? lastAllocationDate; // business date of the most recent allocation

  CollectionObligation({
    required this.personId,
    required this.scheduleId,
    required this.date,
    required this.expectedPoisha,
    this.paidPoisha = 0,
    this.isHoliday = false,
    this.lastAllocationDate,
  }) : id = '${personId}_${dateKey(date)}';

  int get remainingPoisha => expectedPoisha - paidPoisha;
  bool get isFullyPaid => paidPoisha >= expectedPoisha;

  CollectionStatus status({required DateTime today}) {
    if (isHoliday || expectedPoisha == 0) return CollectionStatus.notScheduled;
    if (isFullyPaid) {
      // Paid before the obligation's own date = advance (BLUE), otherwise GREEN.
      if (lastAllocationDate != null && lastAllocationDate!.isBefore(date)) {
        return CollectionStatus.advance;
      }
      return CollectionStatus.paid;
    }
    if (paidPoisha > 0) return CollectionStatus.partial;
    return CollectionStatus.unpaid;
  }

  /// Overdue = belongs to a past day (before today) and not fully paid.
  bool isOverdue({required DateTime today}) =>
      !isHoliday && date.isBefore(today) && !isFullyPaid;
}

class CollectionPayment {
  final String id; // immutable, locally generated (§9)
  final String personId;
  final int amountPoisha;
  final DateTime date; // business date the cash was received
  final String method; // cash / bkash / nagad / rocket / upay / bank
  final String? note;
  const CollectionPayment({
    required this.id,
    required this.personId,
    required this.amountPoisha,
    required this.date,
    this.method = 'cash',
    this.note,
  });
}

class PaymentAllocation {
  final String paymentId;
  final String obligationId;
  final int amountPoisha;
  const PaymentAllocation({required this.paymentId, required this.obligationId, required this.amountPoisha});
}

extension CollectionScheduleJson on CollectionSchedule {
  Map<String, Object?> toJson() => {
        'id': id, 'personId': personId, 'expectedPoisha': expectedPoisha,
        'type': type.name, 'startDate': dateKey(startDate),
        'endDate': endDate == null ? null : dateKey(endDate!),
        'weekdays': weekdays.toList(), 'dayOfMonth': dayOfMonth,
        'graceDays': graceDays, 'allowAdvance': allowAdvance, 'paused': paused,
        'effectiveFrom': dateKey(effectiveFrom),
      };

  static CollectionSchedule fromJson(Map<String, Object?> j) => CollectionSchedule(
        id: j['id'] as String,
        personId: j['personId'] as String,
        expectedPoisha: j['expectedPoisha'] as int,
        type: ScheduleType.values.byName(j['type'] as String),
        startDate: parseDateKey(j['startDate'] as String),
        endDate: j['endDate'] == null ? null : parseDateKey(j['endDate'] as String),
        weekdays: ((j['weekdays'] as List?) ?? const []).cast<int>().toSet(),
        dayOfMonth: j['dayOfMonth'] as int?,
        graceDays: j['graceDays'] as int? ?? 0,
        allowAdvance: j['allowAdvance'] as bool? ?? true,
        paused: j['paused'] as bool? ?? false,
        effectiveFrom: parseDateKey(j['effectiveFrom'] as String),
      );
}

extension CollectionObligationJson on CollectionObligation {
  Map<String, Object?> toJson() => {
        'id': id, 'personId': personId, 'scheduleId': scheduleId,
        'date': dateKey(date), 'expectedPoisha': expectedPoisha,
        'paidPoisha': paidPoisha, 'isHoliday': isHoliday,
        'lastAllocationDate': lastAllocationDate == null ? null : dateKey(lastAllocationDate!),
      };

  static CollectionObligation fromJson(Map<String, Object?> j) => CollectionObligation(
        personId: j['personId'] as String,
        scheduleId: j['scheduleId'] as String,
        date: parseDateKey(j['date'] as String),
        expectedPoisha: j['expectedPoisha'] as int,
        paidPoisha: j['paidPoisha'] as int? ?? 0,
        isHoliday: j['isHoliday'] as bool? ?? false,
        lastAllocationDate: j['lastAllocationDate'] == null ? null : parseDateKey(j['lastAllocationDate'] as String),
      );
}

extension CollectionPaymentJson on CollectionPayment {
  Map<String, Object?> toJson() => {
        'id': id, 'personId': personId, 'amountPoisha': amountPoisha,
        'date': dateKey(date), 'method': method, 'note': note,
      };

  static CollectionPayment fromJson(Map<String, Object?> j) => CollectionPayment(
        id: j['id'] as String,
        personId: j['personId'] as String,
        amountPoisha: j['amountPoisha'] as int,
        date: parseDateKey(j['date'] as String),
        method: j['method'] as String? ?? 'cash',
        note: j['note'] as String?,
      );
}
