import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'database.dart';

class DatabaseManager {
  static DatabaseManager? _instance;
  static AppDatabase? _database;

  static const MethodChannel _storageChannel = MethodChannel(
    'med_reminder/storage',
  );

  DatabaseManager._();

  static DatabaseManager get instance {
    _instance ??= DatabaseManager._();
    return _instance!;
  }

  Future<AppDatabase> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<AppDatabase> _initDatabase() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbDirectory.path, 'med_reminder.db'));
    return AppDatabase(NativeDatabase.createInBackground(file));
  }

  /// Read JSON data from MethodChannel (legacy storage)
  Future<Map<String, dynamic>?> readJsonData() async {
    try {
      final raw = await _storageChannel.invokeMethod<String>('read');
      if (raw == null) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Backup JSON data to a file
  Future<void> backupJsonData() async {
    final raw = await _storageChannel.invokeMethod<String>('read');
    if (raw == null) return;

    final dbDirectory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupFile = File(
      p.join(dbDirectory.path, 'med_reminder_data_v1_backup_$timestamp.json'),
    );
    await backupFile.writeAsString(raw);
  }

  /// Check if migration is needed
  Future<bool> needsMigration() async {
    final db = await database;
    final medications = await db.select(db.medications).get();
    return medications.isEmpty;
  }

  /// Migrate data from JSON to Drift
  Future<void> migrateFromJson(String userId) async {
    final jsonData = await readJsonData();
    if (jsonData == null) return;

    // Backup first
    await backupJsonData();

    final db = await database;

    // Every record is imported in a transaction. Invalid legacy records are
    // ignored instead of stopping the rest of the user's data from importing.
    await db.transaction(() async {
      final medicationsList = jsonData['medications'] as List? ?? [];
      for (final item in medicationsList.whereType<Map>()) {
        final data = _asStringMap(item['data']);
        final id = item['id'] as String?;
        if (id == null || id.isEmpty || data == null) continue;
        await db
            .into(db.medications)
            .insert(
              MedicationsCompanion.insert(
                id: id,
                userId: userId,
                name: data['name'] as String? ?? '',
                quantity: (data['quantity'] as num?)?.toInt() ?? 0,
                lowStockThreshold: Value(
                  (data['lowStockThreshold'] as num?)?.toInt() ?? 5,
                ),
                imageUrl: Value(data['imageUrl'] as String?),
                notes: Value(data['notes'] as String? ?? ''),
                createdAt: _parseDate(data['createdAt']),
                updatedAt: DateTime.now(),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }

      final schedulesList = jsonData['schedules'] as List? ?? [];
      for (final item in schedulesList.whereType<Map>()) {
        final data = _asStringMap(item['data']);
        final id = item['id'] as String?;
        if (id == null || id.isEmpty || data == null) continue;
        await db
            .into(db.schedules)
            .insert(
              SchedulesCompanion.insert(
                id: id,
                medId: data['medId'] as String? ?? '',
                userId: userId,
                times: jsonEncode(data['times'] as List? ?? []),
                daysOfWeek: jsonEncode(data['daysOfWeek'] as List? ?? []),
                dosePerTime: Value((data['dosePerTime'] as num?)?.toInt() ?? 1),
                isActive: Value(data['isActive'] as bool? ?? true),
                updatedAt: DateTime.now(),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }

      final logsList = jsonData['logs'] as List? ?? [];
      for (final item in logsList.whereType<Map>()) {
        final data = _asStringMap(item['data']);
        final id = item['id'] as String?;
        if (id == null || id.isEmpty || data == null) continue;
        await db
            .into(db.intakeLogs)
            .insert(
              IntakeLogsCompanion.insert(
                id: id,
                medId: data['medId'] as String? ?? '',
                userId: userId,
                scheduledAt: _parseDate(data['scheduledAt']),
                actedAt: Value(_parseNullableDate(data['actedAt'])),
                status: data['status'] as String? ?? 'missed',
                dose: (data['dose'] as num?)?.toInt() ?? 1,
                idempotencyKey: id,
                createdAt: DateTime.now(),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }

      final settings = _asStringMap(jsonData['settings']) ?? const {};
      await db
          .into(db.userSettings)
          .insert(
            UserSettingsCompanion.insert(
              userId: userId,
              remindersEnabled: Value(
                settings['remindersEnabled'] as bool? ?? false,
              ),
              lowStockAlertsEnabled: Value(
                settings['lowStockAlertsEnabled'] as bool? ?? true,
              ),
              updatedAt: DateTime.now(),
            ),
            mode: InsertMode.insertOrReplace,
          );
    });
  }

  Map<String, dynamic>? _asStringMap(dynamic value) {
    if (value is! Map) return null;
    return Map<String, dynamic>.from(value);
  }

  DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  DateTime? _parseNullableDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
