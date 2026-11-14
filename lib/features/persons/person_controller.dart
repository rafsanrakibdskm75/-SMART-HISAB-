import 'package:get/get.dart';
import '../../core/id_gen.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/person.dart';

class PersonController extends GetxController {
  PersonController(this._persons, this._ledger);
  final PersonRepository _persons;
  final LedgerRepository _ledger;

  final persons = <Person>[].obs;
  final query = ''.obs;
  final loading = false.obs;

  /// v1.0.3: live persons that look like the same person entered twice
  /// (same name on two devices, synced in as two records). Warning only —
  /// nothing merges or deletes automatically.
  final duplicateGroups = <PossibleDuplicateGroup>[].obs;
  final duplicateIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(query, (_) => refreshList(), time: const Duration(milliseconds: 250)); // §16 debounced search
    refreshList();
  }

  Future<void> refreshList() async {
    loading.value = true;
    persons.value = await _persons.list(query: query.value);
    // Duplicate detection runs on the FULL directory — running it on the
    // search-filtered subset would hide warnings while searching and lose
    // the badge on a person whose twin is filtered out.
    final groups = findPossibleDuplicates(await _persons.list());
    duplicateGroups.value = groups;
    duplicateIds.assignAll({for (final g in groups) for (final p in g.persons) p.id});
    loading.value = false;
  }

  Future<String?> addPerson({required String name, String? mobile, String? address, PersonType type = PersonType.customer}) async {
    final err = validatePerson(name: name, mobile: mobile);
    if (err != null) return err;
    await _persons.create(Person(id: IdGen.next('person'), name: name.trim(), mobile: mobile?.trim(), address: address?.trim(), type: type));
    await refreshList();
    return null;
  }

  Future<void> deletePerson(String id) async {
    await _persons.softDelete(id);
    await refreshList();
  }

  Future<int> netOf(String personId) => _ledger.personNet(personId);
}
