/// Drift settings storage (schema v3: app_settings single JSON row).
library;

import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/stage6.dart';
import '../db/app_database.dart' hide Person;
import 'repositories.dart';

class DriftSettingsRepository implements SettingsRepository {
  final AppDatabase db;
  final String userId;
  DriftSettingsRepository(this.db, {required this.userId});

  @override
  Future<AppSettings> load() async {
    final rows = await db.customSelect('SELECT json FROM app_settings WHERE user_id = ?',
        variables: [Variable.withString(userId)]).get();
    if (rows.isEmpty) return const AppSettings();
    return AppSettings.fromJson((jsonDecode(rows.first.read<String>('json')) as Map).cast<String, Object?>());
  }

  @override
  Future<void> save(AppSettings settings) async {
    await db.customInsert(
        'INSERT INTO app_settings (user_id, json, updated_at) VALUES (?, ?, ?) ON CONFLICT(user_id) DO UPDATE SET json = excluded.json, updated_at = excluded.updated_at',
        variables: [
          Variable.withString(userId), Variable.withString(jsonEncode(settings.toJson())),
          Variable.withString(DateTime.now().toUtc().toIso8601String()),
        ]);
  }
}
