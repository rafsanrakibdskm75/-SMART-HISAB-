/// Person — the shared identity behind Baki customers, collection payers,
/// Somity members, renters and family contacts (§15, §19 shared repositories).
library;

enum PersonType { customer, family, somityMember, renter, staff, other }

class Person {
  final String id;
  final String name;
  final String? mobile;
  final String? address;
  final String? photoPath;
  final PersonType type;
  final bool isDeleted; // tombstone (§12) — never hard-deleted from the UI
  final int localVersion;

  const Person({
    required this.id,
    required this.name,
    this.mobile,
    this.address,
    this.photoPath,
    this.type = PersonType.customer,
    this.isDeleted = false,
    this.localVersion = 1,
  });

  Person copyWith({String? name, String? mobile, String? address, String? photoPath, PersonType? type, bool? isDeleted, int? localVersion}) {
    return Person(
      id: id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      photoPath: photoPath ?? this.photoPath,
      type: type ?? this.type,
      isDeleted: isDeleted ?? this.isDeleted,
      localVersion: localVersion ?? this.localVersion,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id, 'name': name, 'mobile': mobile, 'address': address,
        'photoPath': photoPath, 'type': type.name,
        'isDeleted': isDeleted, 'localVersion': localVersion,
      };

  factory Person.fromJson(Map<String, Object?> j) => Person(
        id: j['id'] as String,
        name: j['name'] as String,
        mobile: j['mobile'] as String?,
        address: j['address'] as String?,
        photoPath: j['photoPath'] as String?,
        type: PersonType.values.byName(j['type'] as String? ?? 'customer'),
        isDeleted: j['isDeleted'] as bool? ?? false,
        localVersion: j['localVersion'] as int? ?? 1,
      );
}

final _bdMobile = RegExp(r'^01[3-9]\d{8}$');

/// True for a well-formed Bangladeshi mobile number (01XXXXXXXXX).
bool isValidBdMobile(String value) => _bdMobile.hasMatch(value.trim());

/// Returns an error message, or null when valid.
String? validatePerson({required String name, String? mobile}) {
  if (name.trim().isEmpty) return 'নাম আবশ্যক';
  if (mobile != null && mobile.trim().isNotEmpty && !_bdMobile.hasMatch(mobile.trim())) {
    return 'সঠিক মোবাইল নম্বর দিন (01XXXXXXXXX)';
  }
  return null;
}

/// Search match for §7/§17: name, mobile, or person ID (case-insensitive).
bool personMatches(Person p, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return p.name.toLowerCase().contains(q) ||
      (p.mobile ?? '').contains(q) ||
      p.id.toLowerCase().contains(q);
}

// ---- Possible-duplicate spotting (v1.0.3) ----
// Two devices can create the SAME person (same name, same time) and sync
// keeps BOTH — by design, names are not identity (verify_stage9). The risk
// is silent: Baki/collection then splits across the two records. So the
// Person list warns instead of merging: the owner checks and soft-deletes
// the true duplicate. Nothing here ever merges or deletes automatically.

/// Name key: trimmed, inner whitespace collapsed, case-insensitive.
/// Works for Bangla names too (no case folding needed there).
String normalizePersonName(String name) =>
    name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

/// Mobile key: digits only, '+88'/'88' country prefix stripped, so
/// 017…, +88017… and 88017… compare equal. '' when unusable.
String normalizeBdMobile(String? mobile) {
  if (mobile == null) return '';
  var d = mobile;
  // Bangla digits would otherwise be stripped as non-digits below.
  for (var i = 0; i < 10; i++) {
    d = d.replaceAll('০১২৩৪৫৬৭৮৯'[i], '$i');
  }
  d = d.replaceAll(RegExp(r'\D'), '');
  if (d.startsWith('88')) d = d.substring(2); // 88017… -> 017…
  if (d.length == 10 && d.startsWith('1')) d = '0$d'; // 1712… -> 01712…
  return d;
}

class PossibleDuplicateGroup {
  /// Two or more live persons sharing one normalized name.
  final List<Person> persons;

  /// True only when EVERY member carries the same non-empty mobile —
  /// the strongest signal this is one person entered twice.
  /// Same name with different/missing mobiles is still flagged, as
  /// 'possible': two real customers can share a name.
  final bool sameMobile;

  const PossibleDuplicateGroup({required this.persons, required this.sameMobile});
}

/// Groups of live persons that look like the same person entered twice.
/// Deleted (tombstoned) persons are excluded; a shared mobile alone,
/// with different names, is NOT a group (family can share one phone).
List<PossibleDuplicateGroup> findPossibleDuplicates(List<Person> persons) {
  final byName = <String, List<Person>>{};
  for (final p in persons) {
    if (p.isDeleted) continue;
    final key = normalizePersonName(p.name);
    if (key.isEmpty) continue;
    (byName[key] ??= []).add(p);
  }
  final out = <PossibleDuplicateGroup>[];
  for (final group in byName.values) {
    if (group.length < 2) continue;
    final mobiles =
        group.map((p) => normalizeBdMobile(p.mobile)).where((m) => m.isNotEmpty).toSet();
    final sameMobile = mobiles.length == 1 &&
        group.every((p) => normalizeBdMobile(p.mobile).isNotEmpty);
    out.add(PossibleDuplicateGroup(persons: List.unmodifiable(group), sameMobile: sameMobile));
  }
  return out;
}
