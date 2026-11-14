/// The daily-collection engine — the heart of Smart Hisab (§3–§8).
/// Pure Dart: no Flutter, no database. The Drift repository loads/saves
/// these objects; every accounting rule lives here and is unit-verified.
library;

import '../core/dhaka_time.dart';
import 'collection_models.dart';

/// Generate one obligation per scheduled day in [from, to] (inclusive).
/// Deterministic IDs make regeneration safe — it can never duplicate a day.
List<CollectionObligation> generateObligations(
  CollectionSchedule s, {
  required DateTime from,
  required DateTime to,
  Map<String, CollectionObligation>? existing,
}) {
  final out = <CollectionObligation>[];
  var d = from;
  while (!d.isAfter(to)) {
    if (s.isScheduledOn(d)) {
      final probe = CollectionObligation(personId: s.personId, scheduleId: s.id, date: d, expectedPoisha: s.expectedPoisha);
      out.add(existing?[probe.id] ?? probe);
    }
    d = addDays(d, 1);
  }
  return out;
}

class AllocationResult {
  final List<PaymentAllocation> allocations;
  final int advanceCreditPoisha; // money left over after the target day is full
  final String? error;
  const AllocationResult({this.allocations = const [], this.advanceCreditPoisha = 0, this.error});
  bool get ok => error == null;
}

/// Apply ONE payment. The payment goes to exactly one obligation:
///  * [targetDate] when the owner picks a specific (e.g. overdue) date — §4;
///  * otherwise the obligation of the payment's own date.
/// It is NEVER spread across missed days automatically, and a missed day's
/// due is NEVER merged into today (§4). Any excess over that day's remaining
/// amount is returned as advance credit — it is not silently reallocated.
AllocationResult applyPayment(
  List<CollectionObligation> obligations,
  CollectionPayment payment, {
  DateTime? targetDate,
}) {
  if (payment.amountPoisha <= 0) {
    return const AllocationResult(error: 'Amount must be positive');
  }
  final targetKey = dateKey(targetDate ?? payment.date);
  CollectionObligation? target;
  for (final o in obligations) {
    if (dateKey(o.date) == targetKey && o.personId == payment.personId) { target = o; break; }
  }
  if (target == null) {
    return const AllocationResult(error: 'No collection scheduled for that date');
  }
  if (target.isHoliday) {
    return const AllocationResult(error: 'That date is marked as a holiday');
  }
  final applied = payment.amountPoisha <= target.remainingPoisha
      ? payment.amountPoisha
      : target.remainingPoisha;
  target.paidPoisha += applied;
  // Out-of-order allocations must not move this backwards: it drives the
  // advance (BLUE) status, which depends on the LATEST allocation date.
  if (applied > 0 &&
      (target.lastAllocationDate == null || payment.date.isAfter(target.lastAllocationDate!))) {
    target.lastAllocationDate = payment.date;
  }
  return AllocationResult(
    // A payment to an already-full day is pure advance credit — recording a
    // zero-amount allocation for it polluted the allocation ledger.
    allocations: applied > 0
        ? [PaymentAllocation(paymentId: payment.id, obligationId: target.id, amountPoisha: applied)]
        : const [],
    advanceCreditPoisha: payment.amountPoisha - applied,
  );
}

class PersonCollectionSummary {
  final int todayExpectedPoisha;
  final int todayReceivedPoisha;
  final int todayRemainingPoisha;
  final int overduePoisha; // strictly previous days, kept separate from today (§8)
  final int missedDays;
  final List<CollectionObligation> overdueItems; // each missed date on its own line
  final DateTime? nextPaymentDate;
  final DateTime? lastPaymentDate;
  const PersonCollectionSummary({
    required this.todayExpectedPoisha,
    required this.todayReceivedPoisha,
    required this.todayRemainingPoisha,
    required this.overduePoisha,
    required this.missedDays,
    required this.overdueItems,
    required this.nextPaymentDate,
    required this.lastPaymentDate,
  });
}

PersonCollectionSummary summarizePerson(
  List<CollectionObligation> obligations, {
  required DateTime today,
}) {
  final sorted = [...obligations]..sort((a, b) => a.date.compareTo(b.date));
  var todayExpected = 0, todayReceived = 0;
  final overdue = <CollectionObligation>[];
  DateTime? nextDate, lastPaid;
  for (final o in sorted) {
    if (o.isHoliday) continue;
    if (dateKey(o.date) == dateKey(today)) {
      todayExpected = o.expectedPoisha;
      todayReceived = o.paidPoisha;
    }
    if (o.isOverdue(today: today)) overdue.add(o);
    if (o.date.isAfter(today) && !o.isFullyPaid && nextDate == null) nextDate = o.date;
    if (o.paidPoisha > 0 && o.lastAllocationDate != null) {
      if (lastPaid == null || o.lastAllocationDate!.isAfter(lastPaid)) lastPaid = o.lastAllocationDate;
    }
  }
  return PersonCollectionSummary(
    todayExpectedPoisha: todayExpected,
    todayReceivedPoisha: todayReceived,
    todayRemainingPoisha: todayExpected - todayReceived,
    overduePoisha: overdue.fold(0, (sum, o) => sum + o.remainingPoisha),
    missedDays: overdue.where((o) => o.paidPoisha == 0).length,
    overdueItems: overdue,
    nextPaymentDate: nextDate,
    lastPaymentDate: lastPaid,
  );
}

class TodayDashboard {
  final int totalExpectedPoisha;
  final int totalReceivedPoisha;
  final int totalRemainingPoisha;
  final int totalOverduePoisha;
  final List<String> paidPersonIds;
  final List<String> partialPersonIds;
  final List<String> unpaidPersonIds;
  const TodayDashboard({
    required this.totalExpectedPoisha,
    required this.totalReceivedPoisha,
    required this.totalRemainingPoisha,
    required this.totalOverduePoisha,
    required this.paidPersonIds,
    required this.partialPersonIds,
    required this.unpaidPersonIds,
  });
}

/// আজকের আদায় — the three lists of §7: Paid / Partial / Not Paid.
TodayDashboard todayDashboard(
  Map<String, List<CollectionObligation>> byPerson, {
  required DateTime today,
}) {
  var expected = 0, received = 0, overdueTotal = 0;
  final paid = <String>[], partial = <String>[], unpaid = <String>[];
  byPerson.forEach((personId, obs) {
    final s = summarizePerson(obs, today: today);
    expected += s.todayExpectedPoisha;
    received += s.todayReceivedPoisha;
    overdueTotal += s.overduePoisha;
    if (s.todayExpectedPoisha == 0) return; // not scheduled today
    if (s.todayRemainingPoisha <= 0) {
      paid.add(personId);
    } else if (s.todayReceivedPoisha > 0) {
      partial.add(personId);
    } else {
      unpaid.add(personId);
    }
  });
  return TodayDashboard(
    totalExpectedPoisha: expected,
    totalReceivedPoisha: received,
    totalRemainingPoisha: expected - received,
    totalOverduePoisha: overdueTotal,
    paidPersonIds: paid,
    partialPersonIds: partial,
    unpaidPersonIds: unpaid,
  );
}
