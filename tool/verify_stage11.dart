/// Stage 11 verification — face recognition domain (v1.1.0).
/// Pure vector math + identification rules + enrollment quality gates.
/// (Camera/ML accuracy itself can only be proven on a real device; see
/// docs/FACE_RECOGNITION.md and the device checklist.)
library;

import '../lib/domain/face_recognition.dart';
import '../lib/data/repositories/in_memory_repositories.dart';

int _pass = 0, _fail = 0;
void check(String name, bool ok) {
  if (ok) { _pass++; } else { _fail++; print('FAIL: $name'); }
}
void eqCount(String name, Object? got, Object? want) =>
    check('$name (got $got, want $want)', got == want);
void near(String name, double got, double want, [double eps = 1e-9]) =>
    check('$name (got $got, want ~$want)', (got - want).abs() <= eps);

/// 8-dim test vectors (min dim is 8).
List<double> v(List<double> head) =>
    [...head, ...List.filled(8 - head.length, 0.0)];

FaceEnrollment enroll(String id, List<List<double>> samples) => FaceEnrollment(
    personId: id,
    samples: [for (final s in samples) FaceEmbedding(s)],
    updatedAtMs: 1);

Future<void> main() async {
  // ---- cosine + normalize ----
  near('same direction, different scale -> 1',
      cosineSimilarity(v([2, 0]), v([5, 0])), 1);
  near('orthogonal -> 0', cosineSimilarity(v([1, 0]), v([0, 1])), 0);
  near('opposite -> -1', cosineSimilarity(v([1, 0]), v([-1, 0])), -1);
  near('zero vector -> 0, no crash', cosineSimilarity(v([0, 0]), v([1, 0])), 0);
  near('dimension mismatch -> 0, no crash',
      cosineSimilarity(v([1, 0]), List.filled(16, 0.5)), 0);
  final n = normalizeEmbedding(v([3, 4]));
  near('normalized magnitude is 1', n[0] * n[0] + n[1] * n[1], 1);
  check('zero vector normalizes to itself',
      normalizeEmbedding(v([0, 0])).every((x) => x == 0));

  // ---- identify: clear match ----
  final people = [
    enroll('rahim', [v([1, 0.05])]),
    enroll('karim', [v([0.05, 1])]),
    enroll('jamal', [v([0, 0, 1])]),
  ];
  final m = identifyFace(normalizeEmbedding(v([0.97, 0.12])), people);
  check('clear match: status matched', m.status == FaceMatchStatus.matched);
  check('clear match: rahim', m.personId == 'rahim');
  check('clear match: score above threshold', m.score >= defaultMatchThreshold);

  // ---- identify: stranger -> noMatch ----
  final stranger = identifyFace(normalizeEmbedding(v([-1, -0.2])), people);
  check('stranger: noMatch', stranger.status == FaceMatchStatus.noMatch);

  // ---- identify: nobody enrolled -> noMatch ----
  check('empty gallery: noMatch',
      identifyFace(v([1, 0]), const []).status == FaceMatchStatus.noMatch);

  // ---- identify: lookalikes -> ambiguous, never a guess ----
  final twins = [
    enroll('bhai_a', [v([1, 0.10])]),
    enroll('bhai_b', [v([1, 0.16])]),
  ];
  final amb = identifyFace(normalizeEmbedding(v([1, 0.13])), twins);
  check('lookalikes: ambiguous', amb.status == FaceMatchStatus.ambiguous);
  check('ambiguous carries both candidates',
      amb.personId != null && amb.secondPersonId != null && amb.personId != amb.secondPersonId);

  // ---- multi-sample: matches the closest sample ----
  final multi = [
    enroll('rahim', [v([0, 1]), v([1, 0.02])]), // second sample faces the query
    enroll('karim', [v([0.3, 0.3, 0.9])]),
  ];
  final mm = identifyFace(normalizeEmbedding(v([0.99, 0.05])), multi);
  check('multi-sample person matches via best sample',
      mm.status == FaceMatchStatus.matched && mm.personId == 'rahim');

  // ---- enrollment json roundtrip ----
  final e = enroll('p1', [v([0.1, 0.2, 0.3])]);
  final back = FaceEnrollment.fromJson(e.toJson());
  check('enrollment json roundtrip',
      back.personId == 'p1' && back.samples.length == 1 &&
          back.samples.single.values[2] == 0.3);

  // ---- enrollment guards ----
  var threw = false;
  try {
    FaceEnrollment(personId: 'x', samples: const [], updatedAtMs: 0);
  } on ArgumentError {
    threw = true;
  }
  check('empty samples rejected', threw);
  threw = false;
  try {
    FaceEmbedding([1, 2, 3]); // below min dim
  } on ArgumentError {
    threw = true;
  }
  check('too-short embedding rejected', threw);

  // ---- quality gates ----
  DetectedFaceInfo face({double frac = 0.4, double y = 0, double z = 0, double? l, double? r}) =>
      DetectedFaceInfo(boxWidthFraction: frac, headEulerY: y, headEulerZ: z,
          leftEyeOpen: l, rightEyeOpen: r);
  check('good frontal face: ok', checkEnrollQuality(face(l: 0.9, r: 0.9)) == EnrollQuality.ok);
  check('far face: tooSmall', checkEnrollQuality(face(frac: 0.1)) == EnrollQuality.faceTooSmall);
  check('turned face: faceTurned', checkEnrollQuality(face(y: 40)) == EnrollQuality.faceTurned);
  check('tilted face: faceTilted', checkEnrollQuality(face(z: 30)) == EnrollQuality.faceTilted);
  check('both eyes closed: eyesClosed',
      checkEnrollQuality(face(l: 0.1, r: 0.05)) == EnrollQuality.eyesClosed);
  check('one eye open passes (wink/blink)',
      checkEnrollQuality(face(l: 0.1, r: 0.9)) == EnrollQuality.ok);
  check('missing eye data passes', checkEnrollQuality(face()) == EnrollQuality.ok);

  // ---- in-memory repository + backup privacy ----
  {
    final store = InMemoryStore();
    final repo = InMemoryFaceEnrollmentRepository(store);
    check('repo: nothing enrolled yet', await repo.getFor('p1') == null);
    await repo.save(enroll('p1', [v([0.5, 0.5, 0.5])]));
    await repo.save(enroll('p2', [v([0.1, 0.9])]));
    eqCount('repo: two enrollments', (await repo.all()).length, 2);
    check('repo: getFor returns samples',
        (await repo.getFor('p1'))!.samples.length == 1);
    await repo.remove('p1');
    check('repo: remove works', await repo.getFor('p1') == null);
    // Embeddings must never leak into a store snapshot (= the backup file).
    final snap = store.snapshot();
    check('snapshot carries NO face data',
        !snap.contains('faceEnrollments') && !snap.contains('0.5,0.5'));
  }

  print('verify_stage11: $_pass passed, $_fail failed');
  if (_fail > 0) throw StateError('stage11 failures: $_fail');
}
