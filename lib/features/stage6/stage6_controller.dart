import 'package:get/get.dart';

import '../../core/dhaka_time.dart';
import '../../data/notifications/notification_service.dart';
import '../../data/repositories/in_memory_repositories.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/stage6.dart';

/// Stage 6 controller: Baki, reports/exports, settings, backup, reminders.
class Stage6Controller extends GetxController {
  final ModuleRepository _modules;
  final LedgerRepository _ledger;
  final SettingsRepository _settingsRepo;
  final InMemoryStore _store;
  final CollectionRepository _collections;
  final NotificationService notifications;
  Stage6Controller(this._modules, this._ledger, this._settingsRepo, this._store, this._collections,
      {NotificationService? notifications})
      : notifications = notifications ?? NotificationService();

  final today = dhakaToday().obs;
  final dueList = <BakiBalance>[].obs;
  final totalDue = 0.obs;
  final settings = const AppSettings().obs;
  final report = Rxn<PeriodReport>();
  final reminders = <ReminderItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    today.value = dhakaToday();
    dueList.assignAll(await _modules.bakiDueList(today: today.value));
    totalDue.value = dueList.fold(0, (a, b) => a + b.duePoisha);
    settings.value = await _settingsRepo.load();
    await loadReportMonth();
    await loadReminders();
  }

  Future<String?> addBaki({required String personId, required int amountPoisha, required bool isPayment, String? note}) async {
    try {
      if (isPayment) {
        await _modules.addBakiPayment(personId: personId, amountPoisha: amountPoisha, note: note);
      } else {
        await _modules.addBakiCredit(personId: personId, amountPoisha: amountPoisha, note: note);
      }
      await refreshAll();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> loadReport({required DateTime from, required DateTime to}) async {
    final entries = await _ledger.all();
    report.value = buildReport(entries, from: from, to: to);
  }

  Future<void> loadReportMonth() async {
    final t = today.value;
    await loadReport(from: DateTime.utc(t.year, t.month, 1), to: DateTime.utc(t.year, t.month + 1, 0));
  }

  Future<String> exportEntriesCsv(Map<String, String> nameOf) async =>
      entriesCsv(await _ledger.all(), nameOf);

  String exportReportCsv() => report.value == null ? '' : reportCsv(report.value!);

  Future<void> saveSettings(AppSettings s) async {
    await _settingsRepo.save(s);
    settings.value = s;
    if (s.dailyClosingReminder) {
      await notifications.scheduleDailyClosing(hour: s.closingReminderHour, minute: s.closingReminderMinute);
    } else {
      await notifications.cancelDailyClosing();
    }
    await loadReminders();
  }

  Future<void> loadReminders() async {
    final overdue = await _collections.overdue(today: today.value);
    final yesterday = today.value.subtract(const Duration(days: 1));
    final entries = await _ledger.all();
    // A day with no business activity needs no closing — v1.0.0 nagged new
    // users daily. Only an active, unclosed yesterday counts as unclosed.
    final yesterdayActive = entries.any((e) => dateKey(e.date) == dateKey(yesterday));
    final yesterdayClosed = _store.isClosed(yesterday) || !yesterdayActive;
    // Only operators the shop actually stocks can be "low" — v1.0.0
    // reported all five operators at ৳0 on a fresh install.
    final balances = <String, int>{
      for (final op in _store.operatorBalances.keys) op: await _modules.operatorBalance(op),
    };
    reminders.assignAll(buildReminderPlan(
      today: today.value, yesterdayClosed: yesterdayClosed, overdue: overdue,
      operatorBalances: balances, lowStockThresholdPoisha: settings.value.lowStockThresholdPoisha));
  }

  /// Backup = the store snapshot inside the checksummed envelope.
  String exportBackup() => makeBackup(_store.snapshot(), exportedAt: DateTime.now());

  /// Returns null on success, error text otherwise. Local data is only
  /// replaced after the envelope passes every check.
  String? importBackup(String backupJson) {
    final (data, err) = parseBackup(backupJson);
    if (err != null) return err;
    try {
      _store.replaceWith(InMemoryStore.restore(data!));
    } catch (_) {
      return 'ব্যাকআপের ডেটা পড়া যাচ্ছে না';
    }
    refreshAll();
    return null;
  }
}
