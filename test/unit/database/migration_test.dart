import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:med_reminder/data/database/database.dart';
import 'dart:io';

void main() {
  group('Database Migration Tests', () {
    late AppDatabase db;
    late File dbFile;

    setUp(() async {
      // Create in-memory database for testing
      db = AppDatabase(NativeDatabase.memory());
      dbFile = File('/tmp/test_med_reminder.db');
    });

    tearDown(() async {
      await db.close();
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
    });

    test('Database initializes with empty tables', () async {
      final medications = await db.select(db.medications).get();
      final schedules = await db.select(db.schedules).get();
      final logs = await db.select(db.intakeLogs).get();

      expect(medications, isEmpty);
      expect(schedules, isEmpty);
      expect(logs, isEmpty);
    });

    test('Can insert medication record', () async {
      await db
          .into(db.medications)
          .insert(
            MedicationsCompanion.insert(
              id: 'med_1',
              userId: 'user_1',
              name: 'Paracetamol',
              quantity: 30,
              lowStockThreshold: const Value(5),
              notes: const Value('Take after meals'),
              createdAt: DateTime(2026, 10, 27),
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      final medications = await db.select(db.medications).get();
      expect(medications.length, 1);
      expect(medications.first.name, 'Paracetamol');
      expect(medications.first.quantity, 30);
    });

    test('Can insert schedule record', () async {
      await db
          .into(db.schedules)
          .insert(
            SchedulesCompanion.insert(
              id: 'sch_1',
              medId: 'med_1',
              userId: 'user_1',
              times: '["08:00", "20:00"]',
              daysOfWeek: '[1,2,3,4,5,6,7]',
              dosePerTime: const Value(1),
              isActive: const Value(true),
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      final schedules = await db.select(db.schedules).get();
      expect(schedules.length, 1);
      expect(schedules.first.medId, 'med_1');
      expect(schedules.first.dosePerTime, 1);
    });

    test('Can insert intake log record', () async {
      await db
          .into(db.intakeLogs)
          .insert(
            IntakeLogsCompanion.insert(
              id: 'log_1',
              medId: 'med_1',
              userId: 'user_1',
              scheduledAt: DateTime(2026, 10, 27, 8, 0),
              actedAt: Value(DateTime(2026, 10, 27, 8, 5)),
              status: 'taken',
              dose: 1,
              idempotencyKey: 'log_1',
              createdAt: DateTime(2026, 10, 27, 8, 5),
            ),
          );

      final logs = await db.select(db.intakeLogs).get();
      expect(logs.length, 1);
      expect(logs.first.status, 'taken');
      expect(logs.first.dose, 1);
    });

    test('Unique constraint prevents duplicate intake logs', () async {
      final scheduledAt = DateTime(2026, 10, 27, 8, 0);

      await db
          .into(db.intakeLogs)
          .insert(
            IntakeLogsCompanion.insert(
              id: 'log_1',
              medId: 'med_1',
              userId: 'user_1',
              scheduledAt: scheduledAt,
              status: 'taken',
              dose: 1,
              idempotencyKey: 'log_1',
              createdAt: DateTime(2026, 10, 27, 8, 5),
            ),
          );

      // Attempt to insert duplicate
      expect(
        () async => await db
            .into(db.intakeLogs)
            .insert(
              IntakeLogsCompanion.insert(
                id: 'log_2',
                medId: 'med_1',
                userId: 'user_1',
                scheduledAt: scheduledAt,
                status: 'taken',
                dose: 1,
                idempotencyKey: 'log_2',
                createdAt: DateTime(2026, 10, 27, 8, 10),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('Can insert sync queue record', () async {
      await db
          .into(db.syncQueue)
          .insert(
            SyncQueueCompanion.insert(
              id: 'sync_1',
              entityType: 'medication',
              entityId: 'med_1',
              operation: 'create',
              payload: '{"name":"Paracetamol"}',
              status: 'pending',
              createdAt: DateTime(2026, 10, 27),
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      final syncQueue = await db.select(db.syncQueue).get();
      expect(syncQueue.length, 1);
      expect(syncQueue.first.operation, 'create');
      expect(syncQueue.first.status, 'pending');
    });

    test('Can insert user settings record', () async {
      await db
          .into(db.userSettings)
          .insert(
            UserSettingsCompanion.insert(
              userId: 'user_1',
              remindersEnabled: const Value(true),
              lowStockAlertsEnabled: const Value(true),
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      final settings = await db.select(db.userSettings).get();
      expect(settings.length, 1);
      expect(settings.first.remindersEnabled, true);
    });

    test('Soft delete for medications', () async {
      await db
          .into(db.medications)
          .insert(
            MedicationsCompanion.insert(
              id: 'med_1',
              userId: 'user_1',
              name: 'Paracetamol',
              quantity: 30,
              lowStockThreshold: const Value(5),
              notes: const Value(''),
              createdAt: DateTime(2026, 10, 27),
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      // Soft delete
      await (db.update(db.medications)..where((m) => m.id.equals('med_1')))
          .write(const MedicationsCompanion(isDeleted: Value(true)));

      final medications = await db.select(db.medications).get();
      expect(medications.length, 1);
      expect(medications.first.isDeleted, true);
    });

    test('Query medications by userId filters correctly', () async {
      await db
          .into(db.medications)
          .insert(
            MedicationsCompanion.insert(
              id: 'med_1',
              userId: 'user_1',
              name: 'Paracetamol',
              quantity: 30,
              lowStockThreshold: const Value(5),
              notes: const Value(''),
              createdAt: DateTime(2026, 10, 27),
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      await db
          .into(db.medications)
          .insert(
            MedicationsCompanion.insert(
              id: 'med_2',
              userId: 'user_2',
              name: 'Ibuprofen',
              quantity: 20,
              lowStockThreshold: const Value(5),
              notes: const Value(''),
              createdAt: DateTime(2026, 10, 27),
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      final user1Meds = await (db.select(
        db.medications,
      )..where((m) => m.userId.equals('user_1'))).get();

      expect(user1Meds.length, 1);
      expect(user1Meds.first.name, 'Paracetamol');
    });

    test('Query schedules by medId filters correctly', () async {
      await db
          .into(db.schedules)
          .insert(
            SchedulesCompanion.insert(
              id: 'sch_1',
              medId: 'med_1',
              userId: 'user_1',
              times: '["08:00"]',
              daysOfWeek: '[1,2,3]',
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      await db
          .into(db.schedules)
          .insert(
            SchedulesCompanion.insert(
              id: 'sch_2',
              medId: 'med_2',
              userId: 'user_1',
              times: '["20:00"]',
              daysOfWeek: '[4,5,6]',
              updatedAt: DateTime(2026, 10, 27),
            ),
          );

      final med1Schedules = await (db.select(
        db.schedules,
      )..where((s) => s.medId.equals('med_1'))).get();

      expect(med1Schedules.length, 1);
      expect(med1Schedules.first.id, 'sch_1');
    });
  });
}
