import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Persons, CollectionSchedules, CollectionObligations,
  Payments, PaymentAllocations, LedgerEntries, Accounts, SyncQueueEntries,
  DailySummaries, AuditLog, Backups, OperatorBalances, TokriRentals,
  TokriAttendance, SomityMembers, AppSettingsTable, FaceEnrollments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'smart_hisab'));
  AppDatabase.forTesting(super.e);

  @override int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1.0.1 audit: these tables existed in docs/schema.sql and in
            // repository SQL but were never created by Drift (see tables.dart).
            await m.createTable(dailySummaries);
            await m.createTable(auditLog);
            await m.createTable(backups);
            await m.createTable(operatorBalances);
            await m.createTable(tokriRentals);
            await m.createTable(tokriAttendance);
            await m.createTable(somityMembers);
            await m.createTable(appSettingsTable);
          }
          if (from < 3) {
            // v1.1.0: local-only face enrollments (never synced).
            await m.createTable(faceEnrollments);
          }
        },
      );
}
