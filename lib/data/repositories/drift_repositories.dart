/// On-device SQLite repositories (Drift), same interfaces as the verified
/// in-memory implementation. Uses raw SQL that mirrors docs/schema.sql, so
/// behaviour matches the schema exactly. Requires the generated database:
///   dart run build_runner build --delete-conflicting-outputs
library;

import 'package:drift/drift.dart';

import '../../core/dhaka_time.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/ledger_service.dart';
import '../../domain/person.dart';
import '../db/app_database.dart' hide CollectionObligation, CollectionSchedule, LedgerEntry, PaymentAllocation, Person, DailySummary;
import 'in_memory_repositories.dart' show entryFromJson;
import 'repositories.dart';

int _nowMs() => DateTime.now().toUtc().millisecondsSinceEpoch;

class DriftPersonRepository implements PersonRepository {
  final AppDatabase db;
  final String userId;
  DriftPersonRepository(this.db, {required this.userId});

  @override
  Future<Person> create(Person p) async {
    final err = validatePerson(name: p.name, mobile: p.mobile);
    if (err != null) throw FormatException(err);
    await db.customInsert(
      'INSERT INTO persons (id, user_id, name, mobile, address, photo_path, person_type, created_at, updated_at, local_version, sync_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable.withString(p.id), Variable.withString(userId), Variable.withString(p.name),
        Variable.withString(p.mobile ?? ''), Variable.withString(p.address ?? ''),
        Variable.withString(p.photoPath ?? ''), Variable.withString(p.type.name),
        Variable.withInt(_nowMs()), Variable.withInt(_nowMs()),
        Variable.withInt(p.localVersion), Variable.withString('pendingUpload'),
      ],
    );
    // Nullable columns are written as '' here for simplicity of the v1 SQL
    // layer; reads map '' back to null below.
    await _enqueue(p.id, p.localVersion, 'persons');
    return p;
  }

  Future<void> _enqueue(String recordId, int version, String entity) async {
    await db.customInsert(
      'INSERT OR IGNORE INTO sync_queue (op_id, record_id, entity, local_version, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable.withString('${recordId}_v$version'), Variable.withString(recordId),
        Variable.withString(entity), Variable.withInt(version),
        Variable.withString('pendingUpload'), Variable.withInt(_nowMs()), Variable.withInt(_nowMs()),
      ],
    );
  }

  Person _fromRow(Map<String, Object?> d) => Person(
        id: d['id'] as String, name: d['name'] as String,
        mobile: (d['mobile'] as String?)?.isEmpty ?? true ? null : d['mobile'] as String,
        address: (d['address'] as String?)?.isEmpty ?? true ? null : d['address'] as String,
        photoPath: (d['photo_path'] as String?)?.isEmpty ?? true ? null : d['photo_path'] as String,
        type: PersonType.values.byName(d['person_type'] as String? ?? 'customer'),
        isDeleted: (d['is_deleted'] as int? ?? 0) == 1,
        localVersion: d['local_version'] as int? ?? 1,
      );

  @override
  Future<Person?> getById(String personId) async {
    final rows = await db.customSelect('SELECT * FROM persons WHERE id = ?',
        variables: [Variable.withString(personId)]).get();
    return rows.isEmpty ? null : _fromRow(rows.first.data);
  }

  @override
  Future<List<Person>> list({String query = '', PersonType? type, bool includeDeleted = false}) async {
    final rows = await db.customSelect('SELECT * FROM persons ORDER BY name').get();
    return rows.map((r) => _fromRow(r.data)).where((p) {
      if (!includeDeleted && p.isDeleted) return false;
      if (type != null && p.type != type) return false;
      return personMatches(p, query);
    }).toList();
  }

  @override
  Future<Person> update(Person p) async {
    final err = validatePerson(name: p.name, mobile: p.mobile);
    if (err != null) throw FormatException(err);
    final existing = await getById(p.id);
    if (existing == null) throw StateError('Person not found: ${p.id}');
    // Stored version wins (a stale object must not re-use a version/opId),
    // and photo_path is part of the update (v1.0.0 silently dropped it).
    final updated = p.copyWith(localVersion: existing.localVersion + 1);
    await db.customUpdate(
      'UPDATE persons SET name = ?, mobile = ?, address = ?, photo_path = ?, person_type = ?, updated_at = ?, local_version = ?, sync_status = ? WHERE id = ?',
      variables: [
        Variable.withString(updated.name),
        Variable.withString(updated.mobile ?? existing.mobile ?? ''),
        Variable.withString(updated.address ?? existing.address ?? ''),
        Variable.withString(updated.photoPath ?? existing.photoPath ?? ''),
        Variable.withString(updated.type.name),
        Variable.withInt(_nowMs()), Variable.withInt(updated.localVersion),
        Variable.withString('pendingUpload'), Variable.withString(updated.id),
      ],
      updateKind: UpdateKind.update,
    );
    await _enqueue(updated.id, updated.localVersion, 'persons');
    return updated;
  }

  @override
  Future<void> softDelete(String personId) async {
    final existing = await getById(personId);
    if (existing == null) return;
    await db.customUpdate(
      'UPDATE persons SET is_deleted = 1, updated_at = ?, local_version = local_version + 1, sync_status = ? WHERE id = ?',
      variables: [Variable.withInt(_nowMs()), Variable.withString('pendingUpload'), Variable.withString(personId)],
      updateKind: UpdateKind.update,
    );
    await _enqueue(personId, existing.localVersion + 1, 'persons');
  }
}

class DriftLedgerRepository implements LedgerRepository {
  final AppDatabase db;
  final String userId;
  DriftLedgerRepository(this.db, {required this.userId});

  @override
  Future<LedgerEntry> addEntry(LedgerEntry e) async {
    final err = validateEntry(e);
    if (err != null) throw FormatException(err);
    final closed = await db.customSelect(
        "SELECT COUNT(*) AS c FROM daily_summaries WHERE date = ? AND is_closed = 1",
        variables: [Variable.withString(dateKey(e.date))]).getSingle();
    if ((closed.data['c'] as int) > 0) {
      throw StateError('Day ${dateKey(e.date)} is closed — reopen it with a reason first');
    }
    await db.customInsert(
      'INSERT INTO ledger_entries (id, user_id, date, direction, amount_poisha, module, person_id, account_id, category, note, is_reversal, reverses_entry_id, created_at, updated_at, sync_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable.withString(e.id), Variable.withString(userId), Variable.withString(dateKey(e.date)),
        Variable.withString(e.direction.name), Variable.withInt(e.amountPoisha),
        Variable.withString(e.module.name), Variable.withString(e.personId ?? ''),
        Variable.withString(e.accountId ?? ''), Variable.withString(e.category ?? ''),
        Variable.withString(e.note ?? ''), Variable.withInt(e.isReversal ? 1 : 0),
        Variable.withString(e.reversesEntryId ?? ''), Variable.withInt(_nowMs()),
        Variable.withInt(_nowMs()), Variable.withString('pendingUpload'),
      ],
    );
    // v1.0.0 never wrote a sync_queue row for ledger entries under Drift.
    await db.customInsert(
      'INSERT OR IGNORE INTO sync_queue (op_id, record_id, entity, local_version, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable.withString('${e.id}_v1'), Variable.withString(e.id),
        Variable.withString('ledger_entries'), Variable.withInt(1),
        Variable.withString('pendingUpload'), Variable.withInt(_nowMs()), Variable.withInt(_nowMs()),
      ],
    );
    return e;
  }

  @override
  Future<LedgerEntry> reverseEntry(LedgerEntry original, {required DateTime date, String? note}) async {
    if (original.isReversal) throw StateError('A reversal entry cannot itself be reversed');
    final dup = await db.customSelect(
        'SELECT COUNT(*) AS c FROM ledger_entries WHERE reverses_entry_id = ? AND is_reversal = 1',
        variables: [Variable.withString(original.id)]).getSingle();
    if ((dup.data['c'] as int) > 0) throw StateError('Entry already reversed: ${original.id}');
    return addEntry(makeReversal(original, date: date, note: note));
  }

  LedgerEntry _fromRow(Map<String, Object?> d) {
    final j = Map<String, Object?>.from(d);
    j['date'] = d['date'];
    j['amountPoisha'] = d['amount_poisha'];
    j['personId'] = (d['person_id'] as String?)?.isEmpty ?? true ? null : d['person_id'];
    j['accountId'] = (d['account_id'] as String?)?.isEmpty ?? true ? null : d['account_id'];
    j['category'] = (d['category'] as String?)?.isEmpty ?? true ? null : d['category'];
    j['note'] = (d['note'] as String?)?.isEmpty ?? true ? null : d['note'];
    j['isReversal'] = (d['is_reversal'] as int? ?? 0) == 1;
    j['reversesEntryId'] = (d['reverses_entry_id'] as String?)?.isEmpty ?? true ? null : d['reverses_entry_id'];
    return entryFromJson(j);
  }

  @override
  Future<List<LedgerEntry>> all() async {
    final rows = await db.customSelect('SELECT * FROM ledger_entries').get();
    return rows.map((r) => _fromRow(r.data)).toList();
  }

  @override
  Future<List<LedgerEntry>> query(EntryFilter filter, {int pageIndex = 0, int pageSize = 50}) async {
    final filtered = filterEntries(await all(), filter);
    return page(filtered, pageIndex: pageIndex, pageSize: pageSize);
  }

  @override
  Future<int> personNet(String personId) async => personNetPoisha(await all(), personId);
}

class DriftDailyRepository implements DailyRepository {
  final AppDatabase db;
  final DriftLedgerRepository ledger;
  final String userId;
  DriftDailyRepository(this.db, this.ledger, {required this.userId});

  @override
  Future<DailySummary> summaryFor(DateTime date) async {
    final entries = await ledger.all();
    return summarizeDay(entries, date, openingPoisha: openingBalanceFor(entries, date));
  }

  @override
  Future<DayClosing> closeDay(DateTime date, {required String closedBy}) async {
    if (await isClosed(date)) {
      throw StateError('Day ${dateKey(date)} is already closed');
    }
    final summary = await summaryFor(date);
    await db.customInsert(
      'INSERT OR REPLACE INTO daily_summaries (date, user_id, opening_poisha, total_in_poisha, total_out_poisha, collection_poisha, closing_poisha, is_closed, closed_by, closed_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?)',
      variables: [
        Variable.withString(dateKey(date)), Variable.withString(userId),
        Variable.withInt(summary.openingPoisha), Variable.withInt(summary.totalInPoisha),
        Variable.withInt(summary.totalOutPoisha), Variable.withInt(summary.collectionPoisha),
        Variable.withInt(summary.closingPoisha), Variable.withString(closedBy),
        Variable.withInt(_nowMs()), Variable.withInt(_nowMs()),
      ],
    );
    return DayClosing(date: date, summary: summary, closedBy: closedBy, closedAtUtc: DateTime.now().toUtc());
  }

  @override
  Future<void> reopenDay(DateTime date, {required String by, required String reason}) async {
    if (reason.trim().isEmpty) throw ArgumentError('Reopen reason is required');
    if (!await isClosed(date)) {
      throw StateError('Day ${dateKey(date)} is not closed');
    }
    await db.customUpdate(
      'UPDATE daily_summaries SET is_closed = 0, updated_at = ? WHERE date = ?',
      variables: [Variable.withInt(_nowMs()), Variable.withString(dateKey(date))],
      updateKind: UpdateKind.update,
    );
    await db.customInsert(
      'INSERT INTO audit_log (id, user_id, entity, entity_id, action, actor, reason, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      variables: [
        Variable.withString('audit_${dateKey(date)}_${_nowMs()}'), Variable.withString(userId),
        Variable.withString('daily_summaries'), Variable.withString(dateKey(date)),
        Variable.withString('reopen'), Variable.withString(by),
        Variable.withString(reason), Variable.withInt(_nowMs()),
      ],
    );
  }

  @override
  Future<bool> isClosed(DateTime date) async {
    final row = await db.customSelect(
        'SELECT is_closed FROM daily_summaries WHERE date = ?',
        variables: [Variable.withString(dateKey(date))]).get();
    return row.isNotEmpty && (row.first.data['is_closed'] as int) == 1;
  }

  @override
  Future<List<DailySummary>> history({required DateTime from, required DateTime to}) async {
    final entries = await ledger.all();
    final out = <DailySummary>[];
    var d = from;
    while (!d.isAfter(to)) {
      if (entries.any((e) => dateKey(e.date) == dateKey(d))) {
        out.add(summarizeDay(entries, d, openingPoisha: openingBalanceFor(entries, d)));
      }
      d = addDays(d, 1);
    }
    return out.reversed.toList();
  }
}
