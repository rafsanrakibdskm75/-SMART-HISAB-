import 'package:get/get.dart';
import '../../core/dhaka_time.dart';
import '../../core/id_gen.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/collection_engine.dart';
import '../../domain/collection_models.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/overdue.dart';
import '../../domain/person.dart';

class CollectionController extends GetxController {
  CollectionController(this._collections, this._persons);
  final CollectionRepository _collections;
  final PersonRepository _persons;

  final today = dhakaToday().obs;
  final dashboard = Rxn<TodayDashboard>();
  final summaries = <String, PersonCollectionSummary>{}.obs;
  final overdueList = <PersonOverdue>[].obs;
  final names = <String, String>{}.obs;
  final allPersons = <Person>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  /// Generation window: obligations exist for the last 90 days (so overdue
  /// is complete) and the next 7 days (so advance payment has a target).
  Future<void> load() async {
    today.value = dhakaToday(); // rolls over if the app stayed open past midnight
    loading.value = true;
    final people = await _persons.list();
    allPersons.value = people;
    names.value = {for (final p in people) p.id: p.name};
    final from = addDays(today.value, -90);
    final to = addDays(today.value, 7);
    for (final p in people) {
      await _collections.ensureObligations(p.id, from: from, to: to);
    }
    dashboard.value = await _collections.dashboard(today: today.value);
    final map = <String, PersonCollectionSummary>{};
    for (final p in people) {
      map[p.id] = await _collections.summaryFor(p.id, today: today.value);
    }
    summaries.value = map;
    overdueList.value = await _collections.overdue(today: today.value);
    loading.value = false;
  }

  Future<List<CollectionSchedule>> schedulesOf(String personId) =>
      _collections.schedulesFor(personId);

  Future<List<CollectionObligation>> obligationsOf(String personId) =>
      _collections.obligationsFor(personId);

  Future<List<CollectionPayment>> paymentsOf(String personId) =>
      _collections.paymentsFor(personId);

  Future<String?> saveSchedule({
    required String personId,
    required int expectedPoisha,
    required ScheduleType type,
    required DateTime startDate,
    required DateTime effectiveFrom,
    DateTime? endDate,
    Set<int> weekdays = const {},
    int? dayOfMonth,
    int graceDays = 0,
    bool allowAdvance = true,
  }) async {
    try {
      await _collections.saveSchedule(CollectionSchedule(
        id: IdGen.next('sch'), personId: personId, expectedPoisha: expectedPoisha,
        type: type, startDate: startDate, endDate: endDate, weekdays: weekdays,
        dayOfMonth: dayOfMonth, graceDays: graceDays, allowAdvance: allowAdvance,
        effectiveFrom: effectiveFrom));
      await load();
      return null;
    } on FormatException catch (e) {
      return e.message;
    }
  }

  Future<(ReceiveResult?, String?)> receive({
    required String personId,
    required int amountPoisha,
    String method = 'cash',
    DateTime? targetDate,
    String? note,
    EntryModule ledgerModule = EntryModule.collection,
  }) async {
    try {
      final r = await _collections.receivePayment(
        personId: personId, amountPoisha: amountPoisha, date: today.value,
        method: method, targetDate: targetDate, note: note, ledgerModule: ledgerModule);
      await load();
      return (r, null);
    } on StateError catch (e) {
      return (null, e.message);
    } on FormatException catch (e) {
      return (null, e.message);
    }
  }

  Future<void> markHoliday(String personId, {required bool holiday}) async {
    await _collections.markHoliday(personId, today.value, holiday: holiday);
    await load();
  }

  Future<void> setPaused(String scheduleId, {required bool paused}) async {
    await _collections.setPaused(scheduleId, paused: paused);
    await load();
  }
}
