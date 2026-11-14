import 'package:get/get.dart';
import '../../core/dhaka_time.dart';
import '../../core/id_gen.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/ledger_service.dart';

class DailyController extends GetxController {
  DailyController(this._ledger, this._daily);
  final LedgerRepository _ledger;
  final DailyRepository _daily;

  final date = dhakaToday().obs;
  final summary = Rxn<DailySummary>();
  final entries = <LedgerEntry>[].obs;
  final closed = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  bool _followToday = true;

  Future<void> load() async {
    if (_followToday) date.value = dhakaToday();
    summary.value = await _daily.summaryFor(date.value);
    closed.value = await _daily.isClosed(date.value);
    entries.value = await _ledger.query(
      EntryFilter(from: date.value, to: date.value), pageSize: 200);
  }

  void setDate(DateTime d) {
    date.value = DateTime.utc(d.year, d.month, d.day);
    _followToday = dateKey(date.value) == dateKey(dhakaToday());
    load();
  }

  /// Returns an error message, or null on success. Amount enters as a taka
  /// string and is parsed exactly to poisha (no doubles).
  Future<String?> addEntry({
    required EntryDirection direction,
    required int amountPoisha,
    required EntryModule module,
    String? personId,
    String? category,
    String? note,
  }) async {
    try {
      await _ledger.addEntry(LedgerEntry(
        id: IdGen.next('entry'), date: date.value, direction: direction,
        amountPoisha: amountPoisha, module: module, personId: personId,
        category: category, note: note));
      await load();
      return null;
    } on StateError catch (e) {
      return e.message;
    } on FormatException catch (e) {
      return e.message;
    }
  }

  Future<String?> reverse(LedgerEntry entry) async {
    try {
      await _ledger.reverseEntry(entry, date: date.value);
      await load();
      return null;
    } on StateError catch (e) {
      return e.message;
    }
  }

  Future<void> closeDay(String closedBy) async {
    await _daily.closeDay(date.value, closedBy: closedBy);
    await load();
  }

  Future<void> reopenDay(String by, String reason) async {
    await _daily.reopenDay(date.value, by: by, reason: reason);
    await load();
  }
}
