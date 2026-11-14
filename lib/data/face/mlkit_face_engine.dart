/// On-device face engine (v1.1.0): ML Kit face detection + MobileFaceNet
/// (TFLite) embeddings. Fully offline — ML Kit's bundled model and the
/// .tflite asset both live inside the APK; no photo ever leaves the phone.
///
/// Pipeline: photo → bake EXIF orientation → ML Kit largest face → crop
/// with margin → 112×112 → normalise to [-1, 1] → MobileFaceNet →
/// L2-normalised embedding (the model's own output dimension, 192).
library;

import 'dart:io';
import 'dart:math' as math;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../domain/face_recognition.dart';
import 'face_engine.dart';

class MlKitFaceEngine implements FaceEngine {
  static const String modelAsset = 'assets/models/mobilefacenet.tflite';
  static const int inputSize = 112;

  FaceDetector? _detector;
  Interpreter? _interpreter;
  bool _modelFailed = false;

  FaceDetector get _faceDetector => _detector ??= FaceDetector(
        options: FaceDetectorOptions(
          enableClassification: true, // eye-open probabilities
          performanceMode: FaceDetectorMode.accurate,
          minFaceSize: 0.12,
        ),
      );

  Future<Interpreter?> _loadInterpreter() async {
    if (_interpreter != null) return _interpreter;
    if (_modelFailed) return null;
    try {
      _interpreter = await Interpreter.fromAsset(modelAsset);
      return _interpreter;
    } catch (_) {
      _modelFailed = true;
      return null;
    }
  }

  @override
  Future<FaceProcessOutcome> processPhoto(String imagePath) async {
    final interpreter = await _loadInterpreter();
    if (interpreter == null) {
      return const FaceProcessOutcome(FaceProcessStatus.modelMissing,
          errorDetail: 'mobilefacenet.tflite could not be loaded');
    }

    final List<Face> faces;
    try {
      faces = await _faceDetector.processImage(InputImage.fromFilePath(imagePath));
    } catch (e) {
      return FaceProcessOutcome(FaceProcessStatus.engineError, errorDetail: '$e');
    }
    if (faces.isEmpty) return const FaceProcessOutcome(FaceProcessStatus.noFace);

    // The subject is the largest face; others are bystanders.
    var face = faces.first;
    for (final f in faces) {
      if (f.boundingBox.width * f.boundingBox.height >
          face.boundingBox.width * face.boundingBox.height) {
        face = f;
      }
    }

    try {
      final bytes = await File(imagePath).readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        return const FaceProcessOutcome(FaceProcessStatus.engineError,
            errorDetail: 'photo could not be decoded');
      }
      // Bake EXIF orientation so pixel space matches ML Kit's box space.
      final image = img.bakeOrientation(decoded);

      final box = face.boundingBox;
      final marginX = box.width * 0.25, marginY = box.height * 0.25;
      final x0 = math.max(0, (box.left - marginX).floor());
      final y0 = math.max(0, (box.top - marginY).floor());
      final x1 = math.min(image.width, (box.right + marginX).ceil());
      final y1 = math.min(image.height, (box.bottom + marginY).ceil());
      if (x1 - x0 < 20 || y1 - y0 < 20) {
        return FaceProcessOutcome(FaceProcessStatus.noFace, faceCount: faces.length,
            errorDetail: 'face box too small after crop');
      }
      final crop = img.copyCrop(image, x: x0, y: y0, width: x1 - x0, height: y1 - y0);
      final resized = img.copyResize(crop, width: inputSize, height: inputSize);

      final input = List.generate(
          1,
          (_) => List.generate(
              inputSize,
              (y) => List.generate(inputSize, (x) {
                    final p = resized.getPixel(x, y);
                    return [
                      (p.r.toDouble() - 127.5) / 127.5,
                      (p.g.toDouble() - 127.5) / 127.5,
                      (p.b.toDouble() - 127.5) / 127.5,
                    ];
                  })));
      final outShape = interpreter.getOutputTensor(0).shape; // [1, dim]
      final dim = outShape.last;
      final output = List.generate(1, (_) => List.filled(dim, 0.0));
      interpreter.run(input, output);

      final embedding =
          FaceEmbedding(normalizeEmbedding(output.first.cast<double>()));
      return FaceProcessOutcome(FaceProcessStatus.ok,
          embedding: embedding,
          faceCount: faces.length,
          faceInfo: DetectedFaceInfo(
            boxWidthFraction: box.width / image.width,
            headEulerY: face.headEulerAngleY ?? 0,
            headEulerZ: face.headEulerAngleZ ?? 0,
            leftEyeOpen: face.leftEyeOpenProbability,
            rightEyeOpen: face.rightEyeOpenProbability,
          ));
    } catch (e) {
      return FaceProcessOutcome(FaceProcessStatus.engineError,
          faceCount: faces.length, errorDetail: '$e');
    }
  }
}
