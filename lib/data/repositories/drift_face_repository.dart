/// Drift face enrollments (v1.1.0, schema v3: face_enrollments).
/// LOCAL-ONLY: nothing here touches the sync queue — embeddings stay on
/// the device that captured them.
library;

import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/face_recognition.dart';
import '../db/app_database.dart' hide Person, FaceEnrollment;
import 'repositories.dart';

class DriftFaceEnrollmentRepository implements FaceEnrollmentRepository {
  final AppDatabase db;
  DriftFaceEnrollmentRepository(this.db);

  @override
  Future<FaceEnrollment?> getFor(String personId) async {
    final rows = await db.customSelect(
        'SELECT json FROM face_enrollments WHERE person_id = ?',
        variables: [Variable.withString(personId)]).get();
    if (rows.isEmpty) return null;
    try {
      return FaceEnrollment.fromJson(
          (jsonDecode(rows.first.read<String>('json')) as Map).cast<String, Object?>());
    } catch (_) {
      return null; // corrupt row must never crash a scan
    }
  }

  @override
  Future<List<FaceEnrollment>> all() async {
    final rows = await db.customSelect('SELECT json FROM face_enrollments').get();
    final out = <FaceEnrollment>[];
    for (final r in rows) {
      try {
        out.add(FaceEnrollment.fromJson(
            (jsonDecode(r.read<String>('json')) as Map).cast<String, Object?>()));
      } catch (_) {
        // Skip a corrupt row; one bad record must not block every scan.
      }
    }
    return out;
  }

  @override
  Future<void> save(FaceEnrollment enrollment) async {
    await db.customInsert(
        'INSERT INTO face_enrollments (person_id, json, updated_at) VALUES (?, ?, ?) '
        'ON CONFLICT(person_id) DO UPDATE SET json = excluded.json, updated_at = excluded.updated_at',
        variables: [
          Variable.withString(enrollment.personId),
          Variable.withString(jsonEncode(enrollment.toJson())),
          Variable.withString(
              DateTime.fromMillisecondsSinceEpoch(enrollment.updatedAtMs, isUtc: true)
                  .toIso8601String()),
        ]);
  }

  @override
  Future<void> remove(String personId) async {
    await db.customStatement('DELETE FROM face_enrollments WHERE person_id = ?', [personId]);
  }
}
