/// Face engine boundary (v1.1.0). The domain layer never sees plugin
/// types; an engine turns a photo file into an embedding + measurements.
/// The ML implementation lives in mlkit_face_engine.dart and is verified
/// by compilation here — real camera accuracy is a device test.
library;

import '../../domain/face_recognition.dart';

enum FaceProcessStatus { ok, noFace, modelMissing, engineError }

class FaceProcessOutcome {
  final FaceProcessStatus status;

  /// Embedding of the LARGEST detected face (status == ok).
  final FaceEmbedding? embedding;

  /// Measurements of that same face (quality gates run on this).
  final DetectedFaceInfo? faceInfo;

  /// How many faces were in the photo (enrollment requires exactly 1).
  final int faceCount;

  /// Technical detail for logs; the UI shows its own Bangla messages.
  final String? errorDetail;

  const FaceProcessOutcome(this.status,
      {this.embedding, this.faceInfo, this.faceCount = 0, this.errorDetail});
}

abstract interface class FaceEngine {
  /// Detects faces in the photo at [imagePath] and embeds the largest.
  Future<FaceProcessOutcome> processPhoto(String imagePath);
}
