/// Ledger operations (§2, §14): entries are immutable — a mistake is fixed
/// by a linked reversal entry, never by editing or deleting the original.
library;

import '../core/id_gen.dart';
import 'daily_ledger.dart';

String? validateEntry(LedgerEntry e) {
  if (e.amountPoisha <= 0) return 'Amount must be positive';
  if (e.id.isEmpty) return 'Missing entry ID';
  return null;
}

/// Build the reversal for [original]: opposite direction, same amount,
/// linked by reversesEntryId. The original row is not touched.
LedgerEntry makeReversal(LedgerEntry original, {required DateTime date, String? note}) {
  return LedgerEntry(
    id: IdGen.next('rev'),
    date: date,
    direction: original.direction == EntryDirection.in_ ? EntryDirection.out_ : EntryDirection.in_,
    amountPoisha: original.amountPoisha,
    module: original.module,
    personId: original.personId,
    accountId: original.accountId,
    category: original.category,
    note: note ?? 'Reversal of ${original.id}',
    isReversal: true,
    reversesEntryId: original.id,
  );
}

class EntryFilter {
  final DateTime? from;
  final DateTime? to;
  final String? personId;
  final EntryModule? module;
  final EntryDirection? direction;
  final String search; // matches note/category/personId
  const EntryFilter({this.from, this.to, this.personId, this.module, this.direction, this.search = ''});
}

List<LedgerEntry> filterEntries(List<LedgerEntry> all, EntryFilter f) {
  final out = all.where((e) {
    if (f.from != null && e.date.isBefore(f.from!)) return false;
    if (f.to != null && e.date.isAfter(f.to!)) return false;
    if (f.personId != null && e.personId != f.personId) return false;
    if (f.module != null && e.module != f.module) return false;
    if (f.direction != null && e.direction != f.direction) return false;
    if (f.search.isNotEmpty) {
      final s = f.search.toLowerCase();
      final hay = '${e.note ?? ''} ${e.category ?? ''} ${e.personId ?? ''}'.toLowerCase();
      if (!hay.contains(s)) return false;
    }
    return true;
  }).toList();
  out.sort((a, b) => b.date.compareTo(a.date) != 0 ? b.date.compareTo(a.date) : b.id.compareTo(a.id));
  return out;
}

/// Pagination for long lists (§16) — never load the whole ledger into a screen.
List<T> page<T>(List<T> items, {required int pageIndex, int pageSize = 50}) {
  if (pageIndex < 0 || pageSize <= 0) return const [];
  final start = pageIndex * pageSize;
  if (start >= items.length) return const [];
  final end = (start + pageSize) > items.length ? items.length : start + pageSize;
  return items.sublist(start, end);
}

/// Net balance for one person across all their entries (in − out).
/// Positive = the business received more from them / they owe less; the Baki
/// screens present the sign in words, never a raw negative.
int personNetPoisha(List<LedgerEntry> all, String personId) {
  var net = 0;
  for (final e in all) {
    if (e.personId == personId) net += e.signedPoisha;
  }
  return net;
}

class PeriodSummary {
  final int totalInPoisha;
  final int totalOutPoisha;
  final int collectionPoisha;
  final int entryCount;
  int get netPoisha => totalInPoisha - totalOutPoisha;
  const PeriodSummary({required this.totalInPoisha, required this.totalOutPoisha, required this.collectionPoisha, required this.entryCount});
}

PeriodSummary summarizePeriod(List<LedgerEntry> all, {required DateTime from, required DateTime to}) {
  var inSum = 0, outSum = 0, coll = 0, count = 0;
  for (final e in all) {
    if (e.module == EntryModule.personal) continue; // business view (§14)
    if (e.date.isBefore(from) || e.date.isAfter(to)) continue;
    count++;
    if (e.direction == EntryDirection.in_) {
      inSum += e.amountPoisha;
      if (e.module == EntryModule.collection || e.module == EntryModule.somity) coll += e.amountPoisha;
    } else {
      outSum += e.amountPoisha;
    }
  }
  return PeriodSummary(totalInPoisha: inSum, totalOutPoisha: outSum, collectionPoisha: coll, entryCount: count);
}

PeriodSummary monthlySummary(List<LedgerEntry> all, int year, int month) {
  final from = DateTime.utc(year, month, 1);
  final to = DateTime.utc(year, month + 1, 0);
  return summarizePeriod(all, from: from, to: to);
}

PeriodSummary yearlySummary(List<LedgerEntry> all, int year) =>
    summarizePeriod(all, from: DateTime.utc(year, 1, 1), to: DateTime.utc(year, 12, 31));

/// Statement lines for a person profile (Stitch: customer_profile_statement),
/// oldest first with a running balance.
List<({LedgerEntry entry, int runningPoisha})> personStatement(List<LedgerEntry> all, String personId) {
  final mine = all.where((e) => e.personId == personId).toList()
    ..sort((a, b) => a.date.compareTo(b.date) != 0 ? a.date.compareTo(b.date) : a.id.compareTo(b.id));
  var running = 0;
  return [for (final e in mine) (entry: e, runningPoisha: running += e.signedPoisha)];
}

String monthKeyOf(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}';
