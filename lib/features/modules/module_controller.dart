import 'package:get/get.dart';

import '../../core/dhaka_time.dart';
import '../../core/id_gen.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/daily_ledger.dart';
import '../../domain/modules.dart';

/// Stage 4 controller: MFS, recharge, personal, Tokri Vara, Somity.
class ModuleController extends GetxController {
  final ModuleRepository _modules;
  final LedgerRepository _ledger;
  ModuleController(this._modules, this._ledger);

  final today = dhakaToday().obs;
  final balances = <EntryModule, int>{}.obs;
  final operatorBalances = <String, int>{}.obs;
  final recentRecharges = <RechargeRecord>[].obs;
  final personalSummary = Rxn<PersonalSummary>();
  final rentals = <TokriRental>[].obs;
  final todayAttendance = <String, AttendanceStatus?>{}.obs;
  final monthDue = <String, int>{}.obs;
  final somityMembers = <String>[].obs;

  DateTime get _monthStart => DateTime.utc(today.value.year, today.value.month, 1);
  DateTime get _monthEnd => DateTime.utc(today.value.year, today.value.month + 1, 0);

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    today.value = dhakaToday();
    balances.assignAll(await _modules.mfsBalances());
    for (final op in telecomOperators) {
      operatorBalances[op] = await _modules.operatorBalance(op);
    }
    recentRecharges.assignAll(await _modules.recharges());
    personalSummary.value = await _modules.personalSummaryFor(from: _monthStart, to: _monthEnd);
    rentals.assignAll(await _modules.rentals());
    for (final r in rentals) {
      todayAttendance[r.id] = (await _modules.attendanceOf(r.id, today.value))?.status;
      monthDue[r.id] = await _modules.tokriDue(r.id, from: _monthStart, to: _monthEnd);
    }
    somityMembers.assignAll(await _modules.somityMemberIds());
  }

  Future<String?> mfsTx({
    required EntryModule provider, required MfsTxType type, required int amountPoisha,
    int feePoisha = 0, int commissionPoisha = 0, String? note,
  }) async {
    try {
      await _modules.addMfsTransaction(provider: provider, type: type, amountPoisha: amountPoisha,
          feePoisha: feePoisha, commissionPoisha: commissionPoisha, note: note);
      await refreshAll();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> transfer({required EntryModule from, required EntryModule to, required int amountPoisha}) async {
    try {
      await _modules.transfer(from: from, to: to, amountPoisha: amountPoisha);
      await refreshAll();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> setOperatorBalance(String operator, int poisha) async {
    try {
      await _modules.setOperatorBalance(operator, poisha);
      await refreshAll();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<(RechargeRecord?, String?)> doRecharge({
    required String operator, required String number, required int amountPoisha, required int commissionBasisPoints,
  }) async {
    try {
      final r = await _modules.recharge(operator: operator, number: number,
          amountPoisha: amountPoisha, commissionBasisPoints: commissionBasisPoints);
      await refreshAll();
      return (r, null);
    } catch (e) {
      return (null, e.toString());
    }
  }

  Future<String?> addPersonalEntry({
    required bool isExpense, required int amountPoisha, required String category, String? note,
  }) async {
    try {
      await _ledger.addEntry(LedgerEntry(
        id: IdGen.next('entry'), date: today.value,
        direction: isExpense ? EntryDirection.out_ : EntryDirection.in_,
        amountPoisha: amountPoisha, module: EntryModule.personal, category: category, note: note));
      await refreshAll();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> familyTransfer({required String personId, required int amountPoisha, String? note}) async {
    try {
      await _ledger.addEntry(LedgerEntry(
        id: IdGen.next('entry'), date: today.value, direction: EntryDirection.out_,
        amountPoisha: amountPoisha, module: EntryModule.familyTransfer, personId: personId, note: note));
      await refreshAll();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> saveRental(TokriRental rental) async {
    try {
      await _modules.saveRental(rental);
      await refreshAll();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> markAttendance(String rentalId, AttendanceStatus status) async {
    await _modules.markAttendance(rentalId, today.value, status);
    await refreshAll();
  }

  Future<String?> collectRent(TokriRental rental, int amountPoisha) async {
    try {
      await _modules.collectRent(rentalId: rental.id, personId: rental.personId, amountPoisha: amountPoisha);
      await refreshAll();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> addSomityMember(String personId) async {
    await _modules.addSomityMember(personId);
    await refreshAll();
  }
}
