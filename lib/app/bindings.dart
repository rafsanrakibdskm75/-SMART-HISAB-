import 'package:get/get.dart';
import '../data/repositories/in_memory_repositories.dart';
import '../data/repositories/repositories.dart';
import '../features/collection/collection_controller.dart';
import '../features/daily/daily_controller.dart';
import '../data/sync/auth_service.dart';
import '../data/sync/in_memory_sync_source.dart';
import '../features/modules/module_controller.dart';
import '../features/stage6/stage6_controller.dart';
import '../features/sync/sync_controller.dart';
import '../features/persons/person_controller.dart';
import '../data/auth/biometric_service.dart';
import '../features/auth/session_controller.dart';
import '../data/face/face_engine.dart';
import '../data/face/face_engine_factory.dart';
import '../features/face/face_controller.dart';

/// App wiring. Stage 2 registers the verified in-memory repositories so the
/// app runs end-to-end today. On device, swap the three registrations to the
/// Drift implementations (same interfaces) once build_runner has generated
/// the database — no screen or controller changes are needed:
///
///   final db = AppDatabase();
///   Get.put<PersonRepository>(DriftPersonRepository(db, userId: uid));
///   Get.put<LedgerRepository>(DriftLedgerRepository(db, userId: uid));
///   Get.put<DailyRepository>(DriftDailyRepository(db, driftLedger, userId: uid));
///   Get.put<CollectionRepository>(DriftCollectionRepository(db, userId: uid));
///   Get.put<ModuleRepository>(DriftModuleRepository(db, userId: uid));
///   Get.put<SettingsRepository>(DriftSettingsRepository(db, userId: uid));
///   Get.put<FaceEnrollmentRepository>(DriftFaceEnrollmentRepository(db));
///   Sync source: swap InMemorySyncSource for a Drift-backed source with
///   the same SyncRecord shape (syncStatus columns in tables.dart).
class AppBindings extends Bindings {
  @override
  void dependencies() {
    final store = InMemoryStore();
    Get.put<PersonRepository>(InMemoryPersonRepository(store), permanent: true);
    Get.put<LedgerRepository>(InMemoryLedgerRepository(store), permanent: true);
    Get.put<DailyRepository>(InMemoryDailyRepository(store), permanent: true);
    Get.put<CollectionRepository>(InMemoryCollectionRepository(store), permanent: true);
    Get.put(PersonController(Get.find<PersonRepository>(), Get.find<LedgerRepository>()), permanent: true);
    Get.put<ModuleRepository>(InMemoryModuleRepository(store), permanent: true);
    Get.put(CollectionController(Get.find<CollectionRepository>(), Get.find<PersonRepository>()), permanent: true);
    Get.put(ModuleController(Get.find<ModuleRepository>(), Get.find<LedgerRepository>()), permanent: true);
    Get.put<SettingsRepository>(InMemorySettingsRepository(store), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(SyncController(InMemorySyncSource(store), Get.find<AuthService>()), permanent: true);
    // v1.1.3 session gate (splash/login/fingerprint)
    Get.put<BiometricService>(LocalAuthBiometricService(), permanent: true);
    Get.put(SessionController(Get.find<SettingsRepository>(), Get.find<AuthService>(), Get.find<BiometricService>()), permanent: true);
    Get.put(Stage6Controller(Get.find<ModuleRepository>(), Get.find<LedgerRepository>(),
        Get.find<SettingsRepository>(), store, Get.find<CollectionRepository>()), permanent: true);
    Get.put(DailyController(Get.find<LedgerRepository>(), Get.find<DailyRepository>()), permanent: true);
    // v1.1.0 face recognition — embeddings are device-local by design.
    Get.put<FaceEnrollmentRepository>(InMemoryFaceEnrollmentRepository(store), permanent: true);
    Get.put<FaceEngine>(createFaceEngine(), permanent: true);
    Get.put(FaceController(Get.find<FaceEnrollmentRepository>(), Get.find<PersonRepository>(), Get.find<FaceEngine>()), permanent: true);
  }
}
