/// Repository interfaces (Stage 2). Screens and controllers depend ONLY on
/// these — never on Drift or Firestore directly (§19 clean architecture).
/// Two implementations ship in this pack:
///  * in_memory_repositories.dart — reference implementation, unit-verified,
///    also used by widget tests;
///  * drift_repositories.dart — the on-device SQLite implementation.
library;

import '../../domain/daily_ledger.dart';
import '../../domain/modules.dart';
import '../../domain/stage6.dart';
import '../../domain/ledger_service.dart';
import '../../domain/person.dart';
import '../../domain/collection_models.dart';
import '../../domain/face_recognition.dart';
import '../../domain/collection_engine.dart';
import '../../domain/overdue.dart';

abstract class PersonRepository {
  Future<Person> create(Person person);
  Future<Person> update(Person person);
  Future<void> softDelete(String personId);
  Future<Person?> getById(String personId);
  Future<List<Person>> list({String query = '', PersonType? type, bool includeDeleted = false});
}

abstract class LedgerRepository {
  /// Throws StateError when the entry's day is closed (§2) or FormatException
  /// when the entry is invalid. Entries are immutable once added.
  Future<LedgerEntry> addEntry(LedgerEntry entry);
  Future<LedgerEntry> reverseEntry(LedgerEntry original, {required DateTime date, String? note});
  Future<List<LedgerEntry>> query(EntryFilter filter, {int pageIndex = 0, int pageSize = 50});
  Future<List<LedgerEntry>> all();
  Future<int> personNet(String personId);
}

abstract class DailyRepository {
  Future<DailySummary> summaryFor(DateTime date);
  Future<DayClosing> closeDay(DateTime date, {required String closedBy});
  Future<void> reopenDay(DateTime date, {required String by, required String reason});
  Future<bool> isClosed(DateTime date);
  Future<List<DailySummary>> history({required DateTime from, required DateTime to});
}

class ReceiveResult {
  final CollectionPayment payment;
  final int appliedPoisha; // amount allocated to the chosen obligation
  final int advanceCreditPoisha; // leftover after that day is fully paid
  final CollectionStatus statusAfter;
  const ReceiveResult({required this.payment, required this.appliedPoisha, required this.advanceCreditPoisha, required this.statusAfter});
}

abstract class CollectionRepository {
  Future<CollectionSchedule> saveSchedule(CollectionSchedule schedule);
  Future<List<CollectionSchedule>> schedulesFor(String personId);
  Future<void> setPaused(String scheduleId, {required bool paused});

  /// Generates any missing obligations in [from, to] (idempotent) and
  /// returns the person's obligations in that range, oldest first.
  Future<List<CollectionObligation>> ensureObligations(String personId, {required DateTime from, required DateTime to});
  Future<List<CollectionObligation>> obligationsFor(String personId);

  /// Records a payment allocated to ONE obligation: [targetDate] when given
  /// (e.g. settling a specific overdue day), otherwise the payment date's own
  /// obligation. Throws StateError when no obligation exists for that date,
  /// the date is a holiday, or the ledger day is closed.
  Future<ReceiveResult> receivePayment({
    required String personId,
    required int amountPoisha,
    required DateTime date,
    String method = 'cash',
    DateTime? targetDate,
    String? note,
    EntryModule ledgerModule = EntryModule.collection,
  });

  Future<List<CollectionPayment>> paymentsFor(String personId);
  Future<void> markHoliday(String personId, DateTime date, {required bool holiday});
  Future<PersonCollectionSummary> summaryFor(String personId, {required DateTime today});
  Future<TodayDashboard> dashboard({required DateTime today});
  Future<List<PersonOverdue>> overdue({required DateTime today});
}

/// Stage 4 business modules (§8–§11). All money movement goes through the
/// shared ledger; module state that is NOT money (operator stock,
/// attendance, group membership) lives here too.
abstract interface class ModuleRepository {
  // MFS
  Future<Map<EntryModule, int>> mfsBalances();
  Future<void> addMfsTransaction({
    required EntryModule provider,
    required MfsTxType type,
    required int amountPoisha,
    int feePoisha = 0,
    int commissionPoisha = 0,
    DateTime? date,
    String? note,
  });
  Future<void> transfer({
    required EntryModule from,
    required EntryModule to,
    required int amountPoisha,
    DateTime? date,
    String? note,
  });
  // Recharge
  Future<int> operatorBalance(String operator);
  Future<void> setOperatorBalance(String operator, int poisha);
  Future<RechargeRecord> recharge({
    required String operator,
    required String number,
    required int amountPoisha,
    required int commissionBasisPoints,
    DateTime? date,
  });
  Future<List<RechargeRecord>> recharges({int limit = 30});
  // Personal
  Future<PersonalSummary> personalSummaryFor({required DateTime from, required DateTime to});
  // Tokri Vara
  Future<List<TokriRental>> rentals();
  Future<void> saveRental(TokriRental rental);
  Future<void> markAttendance(String rentalId, DateTime date, AttendanceStatus status);
  Future<TokriDay?> attendanceOf(String rentalId, DateTime date);
  Future<int> tokriDue(String rentalId, {required DateTime from, required DateTime to});
  Future<void> collectRent({required String rentalId, required String personId, required int amountPoisha, DateTime? date});
  // Baki (Stage 6)
  Future<void> addBakiCredit({required String personId, required int amountPoisha, DateTime? date, String? note});
  Future<void> addBakiPayment({required String personId, required int amountPoisha, DateTime? date, String? note});
  Future<List<BakiBalance>> bakiDueList({required DateTime today});
  Future<BakiBalance> bakiFor(String personId, {required DateTime today});
  // Somity
  Future<List<String>> somityMemberIds();
  Future<void> addSomityMember(String personId);
  Future<void> removeSomityMember(String personId);
}

/// Stage 6 settings storage.
abstract interface class SettingsRepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}

/// Face enrollments (v1.1.0). LOCAL-ONLY storage: implementations must
/// never enqueue sync operations for this data.
abstract interface class FaceEnrollmentRepository {
  Future<FaceEnrollment?> getFor(String personId);
  Future<List<FaceEnrollment>> all();
  Future<void> save(FaceEnrollment enrollment);
  Future<void> remove(String personId);
}
