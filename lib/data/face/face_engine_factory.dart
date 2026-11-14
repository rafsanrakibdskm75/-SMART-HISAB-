import '../../domain/face_recognition.dart';
import 'face_engine.dart';
import 'face_engine_factory_stub.dart'
    if (dart.library.io) 'face_engine_factory_native.dart' as platform;

FaceEngine createFaceEngine() => platform.createFaceEngine();
