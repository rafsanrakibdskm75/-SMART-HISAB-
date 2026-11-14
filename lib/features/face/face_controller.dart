/// Face enrollment + identification flow (v1.1.0).
///
/// A match only ever FINDS a person — this controller has no way to post
/// money. The scan screen shows the match and a human confirms before
/// opening collection (owner's rule from the design review).
library;

import 'package:get/get.dart';

import '../../data/face/face_engine.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/face_recognition.dart';
import '../../domain/person.dart';

class FaceIdentifyResult {
  final FaceMatchStatus? status; // null = capture/processing failed
  final Person? person;
  final Person? secondPerson;
  final double score;
  final double secondScore;
  final String? errorMessage;

  const FaceIdentifyResult(
      {this.status, this.person, this.secondPerson, this.score = 0, this.secondScore = 0, this.errorMessage});
}

class FaceController extends GetxController {
  FaceController(this._faces, this._persons, this._engine);

  final FaceEnrollmentRepository _faces;
  final PersonRepository _persons;
  final FaceEngine _engine;

  /// Bumped after every enrollment change so profile sections refresh.
  final revision = 0.obs;

  Future<FaceEnrollment?> enrollmentOf(String personId) => _faces.getFor(personId);

  /// Enrolls the face in the photo at [photoPath] for [personId].
  /// Returns null on success, or a Bangla reason to show the user.
  Future<String?> enrollFromPhoto(String personId, String photoPath) async {
    final person = await _persons.getById(personId);
    if (person == null || person.isDeleted) {
      return 'ব্যক্তি পাওয়া যায়নি — আগে তালিকা থেকে সঠিক customer বেছে নিন';
    }
    final outcome = await _engine.processPhoto(photoPath);
    final problem = _captureProblem(outcome);
    if (problem != null) return problem;
    if (outcome.faceCount != 1) {
      return 'ছবিতে ঠিক একজনের মুখ থাকতে হবে (${outcome.faceCount} জন পাওয়া গেছে)';
    }
    switch (checkEnrollQuality(outcome.faceInfo!)) {
      case EnrollQuality.faceTooSmall:
        return 'মুখ অনেক দূরে — আরেকটু কাছে এসে ছবি তুলুন';
      case EnrollQuality.faceTurned:
        return 'মুখ ঘোরানো আছে — সোজা ক্যামেরার দিকে তাকিয়ে ছবি তুলুন';
      case EnrollQuality.faceTilted:
        return 'মাথা বাঁকা আছে — সোজা রেখে ছবি তুলুন';
      case EnrollQuality.eyesClosed:
        return 'চোখ বন্ধ দেখা যাচ্ছে — চোখ খোলা রেখে ছবি তুলুন';
      case EnrollQuality.ok:
        break;
    }
    final existing = await _faces.getFor(personId);
    final query = outcome.embedding!.values;
    // Sample-poisoning guard: a new sample that does not match this
    // person's earlier samples is a different face (staff mistake) —
    // accepting it would make strangers match this customer later.
    if (existing != null && existing.scoreAgainst(query) < defaultMatchThreshold) {
      return 'এই মুখ আগের নমুনার সাথে মিলছে না — একই ব্যক্তির ছবি তো? ভুল হলে আগে পুরনো enroll মুছে নিন';
    }
    // Duplicate-customer guard: the same face must not live under two
    // different customer records.
    final conflict =
        findFaceConflict(query, await _faces.all(), excludePersonId: personId);
    if (conflict != null) {
      final other = await _persons.getById(conflict.personId);
      return 'এই মুখ ইতিমধ্যে "${other?.name ?? conflict.personId}" নামে enroll করা আছে — একই লোক দুইবার থাকলে একটা record মুছে দিন';
    }
    final samples = [...?existing?.samples, outcome.embedding!];
    while (samples.length > FaceEnrollment.maxSamples) {
      samples.removeAt(0); // oldest sample rolls off
    }
    await _faces.save(FaceEnrollment(
        personId: personId,
        samples: samples,
        updatedAtMs: DateTime.now().millisecondsSinceEpoch));
    revision.value++;
    return null;
  }

  Future<void> removeEnrollment(String personId) async {
    await _faces.remove(personId);
    revision.value++;
  }

  /// Identifies the face in the photo at [photoPath].
  Future<FaceIdentifyResult> identifyFromPhoto(String photoPath) async {
    final outcome = await _engine.processPhoto(photoPath);
    final problem = _captureProblem(outcome);
    if (problem != null) return FaceIdentifyResult(errorMessage: problem);
    // A scan must contain exactly the customer's face: silently using the
    // largest of several faces can identify a bystander instead.
    if (outcome.faceCount != 1) {
      return const FaceIdentifyResult(
          errorMessage: 'ছবিতে একাধিক মুখ আছে — শুধু customer-কে frame-এ রেখে আবার ছবি তুলুন');
    }
    // A face too far away embeds unreliably; ask for a closer shot.
    if (outcome.faceInfo != null && outcome.faceInfo!.boxWidthFraction < 0.10) {
      return const FaceIdentifyResult(
          errorMessage: 'মুখ অনেক দূরে — আরেকটু কাছে এসে আবার ছবি তুলুন');
    }

    final enrolled = <FaceEnrollment>[];
    final people = <String, Person>{};
    for (final e in await _faces.all()) {
      final p = await _persons.getById(e.personId);
      if (p != null && !p.isDeleted) {
        enrolled.add(e);
        people[p.id] = p;
      }
    }
    if (enrolled.isEmpty) {
      return const FaceIdentifyResult(
          status: FaceMatchStatus.noMatch,
          errorMessage: 'কোনো customer-এর face এখনো enroll করা নেই');
    }
    final result = identifyFace(outcome.embedding!.values, enrolled);
    return FaceIdentifyResult(
      status: result.status,
      person: result.personId == null ? null : people[result.personId],
      secondPerson: result.secondPersonId == null ? null : people[result.secondPersonId],
      score: result.score,
      secondScore: result.secondScore,
    );
  }

  String? _captureProblem(FaceProcessOutcome outcome) {
    switch (outcome.status) {
      case FaceProcessStatus.ok:
        return null;
      case FaceProcessStatus.noFace:
        return 'ছবিতে মুখ পাওয়া যায়নি — ভালো আলোতে আবার ছবি তুলুন';
      case FaceProcessStatus.modelMissing:
        return 'ফেস মডেল লোড হয়নি — app আবার install করে দেখুন';
      case FaceProcessStatus.engineError:
        return 'ছবি পড়া যায়নি — আবার চেষ্টা করুন';
    }
  }
}
