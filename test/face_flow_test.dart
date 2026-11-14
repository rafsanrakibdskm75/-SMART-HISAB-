/// Face flow audit (v1.1.1) — controller-level adversarial checks with a
/// fake engine: enrollment poisoning, the same face under two customers,
/// multi-face scans, far-face scans, deleted persons.
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hisab/data/face/face_engine.dart';
import 'package:smart_hisab/data/repositories/in_memory_repositories.dart';
import 'package:smart_hisab/domain/face_recognition.dart';
import 'package:smart_hisab/domain/person.dart';
import 'package:smart_hisab/features/face/face_controller.dart';

List<double> v(List<double> head) =>
    [...head, ...List.filled(8 - head.length, 0.0)];

class FakeEngine implements FaceEngine {
  final Map<String, FaceProcessOutcome> byPath;
  FakeEngine(this.byPath);
  @override
  Future<FaceProcessOutcome> processPhoto(String imagePath) async =>
      byPath[imagePath] ??
      const FaceProcessOutcome(FaceProcessStatus.engineError,
          errorDetail: 'unstubbed path');
}

FaceProcessOutcome okFace(List<double> embedding,
        {int count = 1, double frac = 0.4}) =>
    FaceProcessOutcome(FaceProcessStatus.ok,
        embedding: FaceEmbedding(normalizeEmbedding(embedding)),
        faceInfo: DetectedFaceInfo(boxWidthFraction: frac),
        faceCount: count);

void main() {
  test('face enroll/identify guards', () async {
    final rahimFace = v([1, 0.05]);
    final rahimFace2 = v([0.98, 0.1]);
    final karimFace = v([0.05, 1]);

    final store = InMemoryStore();
    final persons = InMemoryPersonRepository(store);
    await persons.create(Person(id: 'rahim', name: 'Rahim'));
    await persons.create(Person(id: 'karim', name: 'Karim'));
    final faceRepo = InMemoryFaceEnrollmentRepository(store);
    final engine = FakeEngine({
      'rahim1.jpg': okFace(rahimFace),
      'rahim2.jpg': okFace(rahimFace2),
      'karim1.jpg': okFace(karimFace),
      'crowd.jpg': okFace(rahimFace, count: 3),
      'far.jpg': okFace(rahimFace, frac: 0.05),
    });
    final c = FaceController(faceRepo, persons, engine);

    expect(await c.enrollFromPhoto('rahim', 'rahim1.jpg'), isNull);
    expect(await c.enrollFromPhoto('karim', 'karim1.jpg'), isNull);

    // 1) poisoning: a different face as rahim's 2nd sample
    expect(await c.enrollFromPhoto('rahim', 'karim1.jpg'), isNotNull,
        reason: 'karim-face sample for rahim must be rejected');
    expect((await faceRepo.getFor('rahim'))!.samples.length, 1);

    // 2) genuine 2nd sample of the same person
    expect(await c.enrollFromPhoto('rahim', 'rahim2.jpg'), isNull);
    expect((await faceRepo.getFor('rahim'))!.samples.length, 2);

    // 3) same face under a second customer record (duplicate customer)
    await persons.create(Person(id: 'rahim2', name: 'Rahim Uddin'));
    final dup = await c.enrollFromPhoto('rahim2', 'rahim1.jpg');
    expect(dup, isNotNull, reason: 'same face for another customer must be rejected');
    expect(dup, contains('Rahim'));
    expect(await faceRepo.getFor('rahim2'), isNull);

    // 4) multi-face scan must not silently pick the largest face
    final crowd = await c.identifyFromPhoto('crowd.jpg');
    expect(crowd.status, isNull);
    expect(crowd.errorMessage, isNotNull);

    // 5) far-face scan is unreliable -> refused
    final far = await c.identifyFromPhoto('far.jpg');
    expect(far.status, isNull);
    expect(far.errorMessage, isNotNull);

    // 6) clean scan still identifies
    final good = await c.identifyFromPhoto('rahim2.jpg');
    expect(good.status, FaceMatchStatus.matched);
    expect(good.person?.id, 'rahim');

    // 7) deleted / missing persons
    expect(await c.enrollFromPhoto('ghost', 'rahim1.jpg'), isNotNull);
    await persons.softDelete('karim');
    expect(await c.enrollFromPhoto('karim', 'karim1.jpg'), isNotNull);
    final afterDelete = await c.identifyFromPhoto('karim1.jpg');
    expect(afterDelete.person?.id, isNot('karim'));
  });
}
