/// Schedule versioning (§6): when an amount or pattern changes, the change
/// applies from its effective date forward. Historical obligations already
/// generated keep the amount they were created with — they are never
/// rewritten. A person can therefore have several schedule versions; the
/// applicable one for a day is the latest version effective on that day.
library;

import '../core/dhaka_time.dart';
import 'collection_engine.dart';
import 'collection_models.dart';

CollectionSchedule? applicableSchedule(List<CollectionSchedule> versions, DateTime date) {
  CollectionSchedule? best;
  for (final s in versions) {
    if (date.isBefore(s.startDate) || date.isBefore(s.effectiveFrom)) continue;
    if (s.endDate != null && date.isAfter(s.endDate!)) continue;
    if (best == null || s.effectiveFrom.isAfter(best.effectiveFrom)) best = s;
  }
  return best;
}

/// Generate obligations for a person across all their schedule versions.
/// Existing obligations (by deterministic ID) are always preserved as-is.
List<CollectionObligation> generateForPerson(
  List<CollectionSchedule> versions, {
  required DateTime from,
  required DateTime to,
  Map<String, CollectionObligation>? existing,
}) {
  final out = <CollectionObligation>[];
  var d = from;
  while (!d.isAfter(to)) {
    final s = applicableSchedule(versions, d);
    if (s != null && s.isScheduledOn(d)) {
      final probe = CollectionObligation(
          personId: s.personId, scheduleId: s.id, date: d, expectedPoisha: s.expectedPoisha);
      out.add(existing?[probe.id] ?? probe);
    }
    d = addDays(d, 1);
  }
  return out;
}

/// Convenience for the single-schedule case (Stage 1 callers).
List<CollectionObligation> generateWithVersions(
  CollectionSchedule s, {
  required DateTime from,
  required DateTime to,
  Map<String, CollectionObligation>? existing,
}) =>
    generateObligations(s, from: from, to: to, existing: existing);

/// Shared schedule sanity rules (both repositories enforce these; v1.0.0
/// only checked for a negative amount, and only in one repository).
String? validateSchedule(CollectionSchedule s) {
  if (s.expectedPoisha < 0) return 'Amount cannot be negative';
  if (s.endDate != null && s.endDate!.isBefore(s.startDate)) {
    return 'End date is before start date';
  }
  if (s.dayOfMonth != null && (s.dayOfMonth! < 1 || s.dayOfMonth! > 31)) {
    return 'Day of month must be 1–31';
  }
  if (s.weekdays.any((w) => w < 1 || w > 7)) return 'Weekdays must be 1–7 (Mon–Sun)';
  if (s.graceDays < 0) return 'Grace days cannot be negative';
  return null;
}
