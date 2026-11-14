/// Overdue reporting (§8): every missed date stays its own line; totals are
/// shown separately from today's expected collection — never mixed into it.
library;

import '../core/dhaka_time.dart';
import 'collection_engine.dart';
import 'collection_models.dart';

enum OverdueKind { oneDay, multiDay, partial, longOverdue }

class PersonOverdue {
  final String personId;
  final List<CollectionObligation> items; // oldest first, one line per date
  final int totalPoisha;
  final OverdueKind kind;
  const PersonOverdue({required this.personId, required this.items, required this.totalPoisha, required this.kind});

  int get missedDays => items.where((o) => o.paidPoisha == 0).length;
  int ageDays({required DateTime today}) =>
      items.isEmpty ? 0 : daysBetween(items.first.date, today);
}

OverdueKind classify(List<CollectionObligation> items, {required DateTime today}) {
  if (items.any((o) => o.paidPoisha > 0)) return OverdueKind.partial;
  final oldest = items.isEmpty
      ? null
      : items.reduce((a, b) => a.date.isBefore(b.date) ? a : b).date;
  if (oldest != null && daysBetween(oldest, today) >= 7) return OverdueKind.longOverdue;
  if (items.length > 1) return OverdueKind.multiDay;
  return OverdueKind.oneDay;
}

/// Global overdue report across all persons, worst first.
List<PersonOverdue> overdueReport(
  Map<String, List<CollectionObligation>> byPerson, {
  required DateTime today,
}) {
  final out = <PersonOverdue>[];
  byPerson.forEach((personId, obs) {
    final s = summarizePerson(obs, today: today);
    if (s.overdueItems.isEmpty) return;
    final items = [...s.overdueItems]..sort((a, b) => a.date.compareTo(b.date));
    out.add(PersonOverdue(
      personId: personId,
      items: items,
      totalPoisha: s.overduePoisha,
      kind: classify(items, today: today),
    ));
  });
  out.sort((a, b) => b.totalPoisha.compareTo(a.totalPoisha));
  return out;
}

String overdueBadgeBn(int totalPoisha, String Function(int) format) => 'বকেয়া ${format(totalPoisha)}';
