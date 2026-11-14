/// Face recognition — pure domain (v1.1.0, design screen #19
/// face_scan_verification: camera identifies a CUSTOMER and opens their
/// record).
///
/// Privacy + safety rules baked into this layer:
/// - An embedding is a list of numbers, NOT a photo. Embeddings live in a
///   local-only repository: they are never synced, never backed up to the
///   cloud, and deleting a person's enrollment is instant.
/// - A face match is a FINDER, never an authorisation: the UI must show
///   the matched person and let a human confirm before any money moves.
/// - When the best two candidates are too close, the result is
///   [FaceMatchStatus.ambiguous] — the app asks, it does not guess.
library;

import 'dart:math' as math;

/// Minimum plausible embedding size (MobileFaceNet emits 192).
const int minEmbeddingDim = 8;

/// Default cosine-similarity bar for "this is the same person".
/// MobileFaceNet scores for the same person under shop lighting usually
/// land 0.75–0.95; different people usually stay under 0.5.
const double defaultMatchThreshold = 0.70;

/// If the runner-up is within this distance of the winner, the match is
/// ambiguous (lookalikes, brothers, poor light) and a human must pick.
const double defaultAmbiguityMargin = 0.08;

/// One face embedding vector.
class FaceEmbedding {
  final List<double> values;

  FaceEmbedding(List<double> v) : values = List.unmodifiable(v) {
    if (v.length < minEmbeddingDim) {
      throw ArgumentError('embedding too short: ${v.length}');
    }
    if (v.any((x) => x.isNaN || x.isInfinite)) {
      throw ArgumentError('embedding contains non-finite values');
    }
  }

  int get dim => values.length;

  List<double> toJson() => values;

  factory FaceEmbedding.fromJson(List<Object?> j) =>
      FaceEmbedding([for (final x in j) (x as num).toDouble()]);
}

/// L2-normalises [v]; a zero vector stays zero (cosine then reads 0).
List<double> normalizeEmbedding(List<double> v) {
  var sum = 0.0;
  for (final x in v) {
    sum += x * x;
  }
  final norm = math.sqrt(sum);
  if (norm == 0) return List.of(v);
  return [for (final x in v) x / norm];
}

/// Cosine similarity in [-1, 1]. Embeddings of different dimensions never
/// match (returns 0) — e.g. after a model change, old enrollments simply
/// stop matching instead of crashing or false-matching.
double cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length) return 0;
  var dot = 0.0, na = 0.0, nb = 0.0;
  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    na += a[i] * a[i];
    nb += b[i] * b[i];
  }
  if (na == 0 || nb == 0) return 0;
  return dot / (math.sqrt(na) * math.sqrt(nb));
}

/// All enrolled face samples of one person (up to [maxSamples]).
class FaceEnrollment {
  static const int maxSamples = 3;

  final String personId;
  final List<FaceEmbedding> samples;
  final int updatedAtMs;

  FaceEnrollment({required this.personId, required List<FaceEmbedding> samples, required this.updatedAtMs})
      : samples = List.unmodifiable(samples) {
    if (samples.isEmpty || samples.length > maxSamples) {
      throw ArgumentError('samples must be 1..$maxSamples, got ${samples.length}');
    }
  }

  /// Best similarity of [query] against any of this person's samples.
  double scoreAgainst(List<double> query) {
    var best = -1.0;
    for (final s in samples) {
      final c = cosineSimilarity(query, s.values);
      if (c > best) best = c;
    }
    return best;
  }

  Map<String, Object?> toJson() => {
        'personId': personId,
        'samples': [for (final s in samples) s.toJson()],
        'updatedAtMs': updatedAtMs,
      };

  factory FaceEnrollment.fromJson(Map<String, Object?> j) => FaceEnrollment(
        personId: j['personId'] as String,
        samples: [
          for (final s in (j['samples'] as List<Object?>))
            FaceEmbedding.fromJson(s as List<Object?>)
        ],
        updatedAtMs: (j['updatedAtMs'] as num).toInt(),
      );
}

enum FaceMatchStatus { matched, noMatch, ambiguous }

class FaceMatchResult {
  final FaceMatchStatus status;

  /// Winner (status == matched) or best candidate (ambiguous).
  final String? personId;
  final double score;

  /// Runner-up, present when there was a real second candidate.
  final String? secondPersonId;
  final double secondScore;

  const FaceMatchResult(this.status,
      {this.personId, this.score = 0, this.secondPersonId, this.secondScore = 0});
}

/// Identifies [query] among [enrolled]. Pure and deterministic: ties are
/// broken by personId so both devices agree on the outcome.
FaceMatchResult identifyFace(List<double> query, Iterable<FaceEnrollment> enrolled,
    {double threshold = defaultMatchThreshold, double ambiguityMargin = defaultAmbiguityMargin}) {
  final scored = <(String, double)>[];
  for (final e in enrolled) {
    final s = e.scoreAgainst(query);
    if (s > 0) scored.add((e.personId, s));
  }
  scored.sort((a, b) {
    final byScore = b.$2.compareTo(a.$2);
    return byScore != 0 ? byScore : a.$1.compareTo(b.$1);
  });
  if (scored.isEmpty || scored.first.$2 < threshold) {
    return FaceMatchResult(FaceMatchStatus.noMatch,
        score: scored.isEmpty ? 0 : scored.first.$2,
        personId: scored.isEmpty ? null : scored.first.$1);
  }
  final best = scored.first;
  if (scored.length > 1) {
    final second = scored[1];
    if (best.$2 - second.$2 < ambiguityMargin) {
      return FaceMatchResult(FaceMatchStatus.ambiguous,
          personId: best.$1, score: best.$2,
          secondPersonId: second.$1, secondScore: second.$2);
    }
    return FaceMatchResult(FaceMatchStatus.matched,
        personId: best.$1, score: best.$2,
        secondPersonId: second.$1, secondScore: second.$2);
  }
  return FaceMatchResult(FaceMatchStatus.matched, personId: best.$1, score: best.$2);
}

/// Another person's enrollment that [query] already matches at or above
/// [threshold] — used to stop the SAME face being enrolled under two
/// different customer records (the duplicate-customer case). Returns the
/// strongest conflicting enrollment, or null.
FaceEnrollment? findFaceConflict(List<double> query, Iterable<FaceEnrollment> enrolled,
    {String? excludePersonId, double threshold = defaultMatchThreshold}) {
  FaceEnrollment? best;
  var bestScore = threshold;
  for (final e in enrolled) {
    if (e.personId == excludePersonId) continue;
    final s = e.scoreAgainst(query);
    if (s >= bestScore) {
      best = e;
      bestScore = s;
    }
  }
  return best;
}

/// What the camera/ML layer measured about one detected face. Kept free
/// of plugin types so the quality rules stay testable here.
class DetectedFaceInfo {
  /// Face box width as a fraction of the image width (0..1).
  final double boxWidthFraction;

  /// Head turn (degrees, ML Kit euler Y) and tilt (euler Z).
  final double headEulerY;
  final double headEulerZ;

  /// Eye-open probabilities when the detector provides them.
  final double? leftEyeOpen;
  final double? rightEyeOpen;

  const DetectedFaceInfo(
      {required this.boxWidthFraction,
      this.headEulerY = 0,
      this.headEulerZ = 0,
      this.leftEyeOpen,
      this.rightEyeOpen});
}

enum EnrollQuality { ok, faceTooSmall, faceTurned, faceTilted, eyesClosed }

/// Enrollment is stricter than scanning: a bad sample poisons every later
/// match, so crooked/small/closed-eye captures are rejected up front with
/// a reason the UI can show in Bangla.
EnrollQuality checkEnrollQuality(DetectedFaceInfo f) {
  if (f.boxWidthFraction < 0.18) return EnrollQuality.faceTooSmall;
  if (f.headEulerY.abs() > 25) return EnrollQuality.faceTurned;
  if (f.headEulerZ.abs() > 20) return EnrollQuality.faceTilted;
  final l = f.leftEyeOpen, r = f.rightEyeOpen;
  if (l != null && r != null && l < 0.3 && r < 0.3) return EnrollQuality.eyesClosed;
  return EnrollQuality.ok;
}
