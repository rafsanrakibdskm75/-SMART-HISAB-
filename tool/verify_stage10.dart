/// Stage 10 verification — possible-duplicate warning (v1.0.3).
/// Follows the owner's 2026-11-13 follow-up: two devices create the SAME
/// person at the SAME time under the SAME NAME, and sync keeps BOTH
/// (verify_stage9). This stage adds the warning that makes that visible:
/// the Person list flags name matches so the owner can check and
/// soft-delete the true duplicate. Nothing merges or deletes by itself.
library;

import '../lib/domain/person.dart';

int _pass = 0, _fail = 0;
void check(String name, bool ok) {
  if (ok) { _pass++; } else { _fail++; print('FAIL: $name'); }
}
void eq(String name, Object? got, Object? want) =>
    check('$name (got $got, want $want)', got == want);

Person p(String id, String name, [String? mobile, bool deleted = false]) =>
    Person(id: id, name: name, mobile: mobile, isDeleted: deleted);

void main() {
  // ---- 1) Same name + same mobile -> one STRONG group, both persons ----
  {
    final groups = findPossibleDuplicates([
      p('a', 'Rahim', '01712345678'),
      p('b', 'Rahim', '01712345678'),
    ]);
    eq('same name+mobile: one group', groups.length, 1);
    check('same name+mobile: strong', groups.single.sameMobile);
    eq('same name+mobile: both persons in group',
        groups.single.persons.length, 2);
  }

  // ---- 2) Same name, different mobiles -> possible, NOT strong ----
  {
    final groups = findPossibleDuplicates([
      p('a', 'Rahim', '01712345678'),
      p('b', 'Rahim', '01987654321'),
    ]);
    eq('same name diff mobile: one group', groups.length, 1);
    check('same name diff mobile: not strong', !groups.single.sameMobile);
  }

  // ---- 3) Same name, one mobile missing -> possible, NOT strong ----
  {
    final groups = findPossibleDuplicates([
      p('a', 'Rahim', '01712345678'),
      p('b', 'Rahim'),
    ]);
    eq('same name one mobile missing: one group', groups.length, 1);
    check('same name one mobile missing: not strong',
        !groups.single.sameMobile);
  }

  // ---- 4) Name case / spacing variants still match ----
  {
    final groups = findPossibleDuplicates([
      p('a', '  Rahim  ', '01712345678'),
      p('b', 'RAHIM', '01712345678'),
      p('c', 'Rahim  Uddin', '01712345678'),
    ]);
    eq('case/space variants: one group (Rahim x2)', groups.length, 1);
    eq('case/space variants: group holds the 2 Rahims',
        groups.single.persons.length, 2);
    check('case/space variants: strong', groups.single.sameMobile);
  }

  // ---- 5) Mobile format variants (+880 / 880 / bare) compare equal ----
  {
    eq('mobile +880 == 017', normalizeBdMobile('+8801712345678'),
        normalizeBdMobile('01712345678'));
    eq('mobile 880 == 017', normalizeBdMobile('8801712345678'),
        normalizeBdMobile('01712345678'));
    eq('mobile bare 1712 == 017', normalizeBdMobile('1712345678'),
        normalizeBdMobile('01712345678'));
    final groups = findPossibleDuplicates([
      p('a', 'Rahim', '+8801712345678'),
      p('b', 'Rahim', '01712345678'),
    ]);
    check('mobile format variants: strong group',
        groups.length == 1 && groups.single.sameMobile);
  }

  // ---- 6) Different names -> no groups, even with the same mobile ----
  {
    final groups = findPossibleDuplicates([
      p('a', 'Rahim', '01712345678'),
      p('b', 'Karim', '01712345678'),
    ]);
    eq('same mobile diff name: no group (shared family phone)',
        groups.length, 0);
  }

  // ---- 7) Deleted (tombstoned) person is excluded ----
  {
    final groups = findPossibleDuplicates([
      p('a', 'Rahim', '01712345678'),
      p('b', 'Rahim', '01712345678', true),
    ]);
    eq('deleted twin excluded: no group', groups.length, 0);
  }

  // ---- 8) Single person, empty names -> nothing flagged ----
  {
    eq('single person: no group',
        findPossibleDuplicates([p('a', 'Rahim')]).length, 0);
    eq('blank names ignored',
        findPossibleDuplicates([p('a', '   '), p('b', '')]).length, 0);
    eq('empty list: no group', findPossibleDuplicates([]).length, 0);
  }

  // ---- 9) Bangla names group the same way ----
  {
    final groups = findPossibleDuplicates([
      p('a', 'রহিম', '01712345678'),
      p('b', 'রহিম', '01712345678'),
      p('c', 'করিম', '01712345678'),
    ]);
    eq('Bangla same name: one group', groups.length, 1);
    check('Bangla same name: strong', groups.single.sameMobile);
  }

  // ---- 10) Two separate duplicate pairs -> two groups ----
  {
    final groups = findPossibleDuplicates([
      p('a', 'Rahim', '01712345678'),
      p('b', 'Rahim', '01712345678'),
      p('c', 'Karim', '01987654321'),
      p('d', 'Karim', '01987654321'),
    ]);
    eq('two pairs: two groups', groups.length, 2);
    check('two pairs: both strong',
        groups.every((g) => g.sameMobile));
  }

  // ---- 9) Bangla-digit mobile still counts as the same mobile (v1.0.3 fix) ----
  {
    final groups = findPossibleDuplicates([
      p('a', 'Rahim', '০১৭১২৩৪৫৬৭৮'),
      p('b', 'Rahim', '01712345678'),
    ]);
    eq('bangla-digit mobile: one group', groups.length, 1);
    check('bangla-digit mobile: strong', groups.single.sameMobile);
  }

  print('verify_stage10: $_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('stage10 failures: $_fail');
}
