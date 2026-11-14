import '../../domain/face_recognition.dart';
import 'face_engine.dart';

FaceEngine createFaceEngine() => _UnsupportedFaceEngine();

class _UnsupportedFaceEngine implements FaceEngine {
  @override
  Future<FaceProcessOutcome> processPhoto(String imagePath) async =>
      const FaceProcessOutcome(FaceProcessStatus.engineError,
          errorDetail: 'Face recognition is available on mobile devices only');
}
