import 'package:drift/drift.dart';

/// Drift table definitions mirroring docs/schema.sql exactly.
/// Every syncable table carries the §10 sync columns. Run:
///   dart run build_runner build
/// to generate app_database.g.dart (see docs/BUILD.md).
mixin SyncColumns on Table {
  TextColumn get userId => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text().nullable()();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();
  TextColumn get syncStatus => text().withDefault(const Constant('pendingUpload'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get serverUpdatedAt => integer().nullable()();
}

class Persons extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get mobile => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get personType => text().withDefault(const Constant('customer'))();
  @override Set<Column> get primaryKey => {id};
}

class CollectionSchedules extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get personId => text().references(Persons, #id)();
  IntColumn get expectedPoisha => integer()();
  TextColumn get scheduleType => text()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text().nullable()();
  TextColumn get weekdays => text().nullable()();
  IntColumn get dayOfMonth => integer().nullable()();
  IntColumn get graceDays => integer().withDefault(const Constant(0))();
  BoolColumn get allowAdvance => boolean().withDefault(const Constant(true))();
  BoolColumn get paused => boolean().withDefault(const Constant(false))();
  TextColumn get effectiveFrom => text()();
  @override Set<Column> get primaryKey => {id};
}

class CollectionObligations extends Table with SyncColumns {
  TextColumn get id => text()(); // personId_yyyy-MM-dd
  TextColumn get personId => text().references(Persons, #id)();
  TextColumn get scheduleId => text()();
  TextColumn get date => text()();
  IntColumn get expectedPoisha => integer()();
  IntColumn get paidPoisha => integer().withDefault(const Constant(0))();
  BoolColumn get isHoliday => boolean().withDefault(const Constant(false))();
  TextColumn get lastAllocationDate => text().nullable()();
  @override Set<Column> get primaryKey => {id};
  @override List<Set<Column>> get uniqueKeys => [{personId, date}];
}

class Payments extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get personId => text().references(Persons, #id)();
  IntColumn get amountPoisha => integer()();
  TextColumn get date => text()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  TextColumn get note => text().nullable()();
  BoolColumn get isReversal => boolean().withDefault(const Constant(false))();
  TextColumn get reversesPaymentId => text().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class PaymentAllocations extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get paymentId => text().references(Payments, #id)();
  TextColumn get obligationId => text().references(CollectionObligations, #id)();
  IntColumn get amountPoisha => integer()();
  @override Set<Column> get primaryKey => {id};
}

class LedgerEntries extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get direction => text()(); // in / out
  IntColumn get amountPoisha => integer()();
  TextColumn get module => text()();
  TextColumn get personId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get isReversal => boolean().withDefault(const Constant(false))();
  TextColumn get reversesEntryId => text().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class Accounts extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get kind => text()(); // cash/bkash/nagad/rocket/upay/bank
  TextColumn get label => text()();
  TextColumn get number => text().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class SyncQueueEntries extends Table {
  // v1.0.1 audit: the generated name was 'sync_queue_entries', but every
  // raw-SQL enqueue writes to 'sync_queue' (the docs/schema.sql name) —
  // so the queue table the app actually used was never created either.
  @override String get tableName => 'sync_queue';
  TextColumn get opId => text()(); // recordId_v<localVersion>
  TextColumn get recordId => text()();
  TextColumn get entity => text()();
  IntColumn get localVersion => integer()();
  TextColumn get status => text().withDefault(const Constant('pendingUpload'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  @override Set<Column> get primaryKey => {opId};
}

// ---- Tables added in the v1.0.1 audit (schema v2) -----------------------
// docs/schema.sql always defined these, and the Drift repositories run raw
// SQL against them — but they were MISSING from @DriftDatabase, so Drift
// never created them and every closeDay / settings / recharge-stock /
// tokri / somity call would have crashed on device with "no such table".

class DailySummaries extends Table {
  TextColumn get date => text()();
  TextColumn get userId => text()();
  IntColumn get openingPoisha => integer()();
  IntColumn get totalInPoisha => integer()();
  IntColumn get totalOutPoisha => integer()();
  IntColumn get collectionPoisha => integer()();
  IntColumn get closingPoisha => integer()();
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();
  TextColumn get closedBy => text().nullable()();
  IntColumn get closedAt => integer().nullable()();
  IntColumn get updatedAt => integer()();
  @override Set<Column> get primaryKey => {date};
}

class AuditLog extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();
  TextColumn get actor => text().nullable()();
  TextColumn get reason => text().nullable()();
  IntColumn get createdAt => integer()();
  @override Set<Column> get primaryKey => {id};
}

class Backups extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get kind => text()();
  TextColumn get pathOrRef => text().nullable()();
  IntColumn get recordCount => integer().nullable()();
  BoolColumn get integrityOk => boolean().nullable()();
  IntColumn get createdAt => integer()();
  @override Set<Column> get primaryKey => {id};
}

class OperatorBalances extends Table {
  TextColumn get operator => text()();
  IntColumn get balancePoisha => integer().withDefault(const Constant(0))();
  TextColumn get updatedAt => text()();
  @override Set<Column> get primaryKey => {operator};
}

class TokriRentals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get personId => text()();
  IntColumn get tokriCount => integer()();
  IntColumn get dailyRatePoisha => integer()();
  TextColumn get createdAt => text()();
  @override Set<Column> get primaryKey => {id};
}

class TokriAttendance extends Table {
  TextColumn get userId => text()();
  TextColumn get rentalId => text()();
  TextColumn get businessDate => text()();
  TextColumn get status => text()();
  @override Set<Column> get primaryKey => {rentalId, businessDate};
}

class SomityMembers extends Table {
  TextColumn get userId => text()();
  TextColumn get personId => text()();
  @override Set<Column> get primaryKey => {userId, personId};
}

/// Face enrollments (v1.1.0) — LOCAL ONLY. Embeddings never enter the
/// sync queue, Firestore or backups; this table is device-private.
class FaceEnrollments extends Table {
  @override String get tableName => 'face_enrollments';
  TextColumn get personId => text()();
  TextColumn get json => text()();
  TextColumn get updatedAt => text()();
  @override Set<Column> get primaryKey => {personId};
}

class AppSettingsTable extends Table {
  @override String get tableName => 'app_settings';
  TextColumn get userId => text()();
  TextColumn get json => text()();
  TextColumn get updatedAt => text()();
  @override Set<Column> get primaryKey => {userId};
}
