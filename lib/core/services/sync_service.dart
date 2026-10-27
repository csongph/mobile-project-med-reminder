import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_reminder/data/repositories/firestore_repository.dart';
import 'package:med_reminder/data/database/database_manager.dart';
import 'package:med_reminder/data/database/database.dart';
import 'package:med_reminder/features/medications/models/medication.dart';
import 'package:med_reminder/features/schedules/models/schedule.dart';
import 'package:med_reminder/features/logs/models/intake_log.dart';
import 'package:drift/drift.dart';

/// Service จัดการ offline-first sync
class SyncService {
  final FirestoreRepository _firestoreRepo = FirestoreRepository();
  final DatabaseManager _dbManager = DatabaseManager.instance;
  final Connectivity _connectivity = Connectivity();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isSyncing = false;
  final StreamController<bool> _syncStatusController = StreamController<bool>.broadcast();

  /// Stream ของ sync status
  Stream<bool> get syncStatus => _syncStatusController.stream;

  /// ตรวจสอบว่ากำลัง sync อยู่หรือไม่
  bool get isSyncing => _isSyncing;

  /// ตรวจสอบว่ามี internet หรือไม่
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }

  /// ดึง user ID ปัจจุบัน
  String? get _userId => _auth.currentUser?.uid;

  /// เริ่ม sync process
  Future<void> sync() async {
    if (_isSyncing) return;

    final connected = await isConnected;
    if (!connected) {
      _syncStatusController.add(false);
      return;
    }

    _isSyncing = true;
    _syncStatusController.add(true);

    try {
      final db = await _dbManager.database;

      // 1. Process sync queue (local → remote)
      await _processSyncQueue(db);

      // 2. Pull changes from remote (remote → local)
      await _pullFromFirestore(db);

      // 3. Clear completed sync queue items
      await _clearCompletedSyncQueue(db);
    } catch (e) {
      debugPrint('Sync error: $e');
    } finally {
      _isSyncing = false;
      _syncStatusController.add(false);
    }
  }

  /// Process sync queue operations
  Future<void> _processSyncQueue(AppDatabase db) async {
    final pendingItems = await (db.select(db.syncQueue)
          ..where((sq) => sq.status.equals('pending'))
          ..orderBy([(sq) => OrderingTerm.asc(sq.createdAt)]))
        .get();

    for (final item in pendingItems) {
      try {
        await _processSyncQueueItem(db, item);
        // Mark as synced
        await (db.update(db.syncQueue)..where((sq) => sq.id.equals(item.id)))
            .write(SyncQueueCompanion(
          status: const Value('synced'),
          updatedAt: Value(DateTime.now()),
        ));
      } catch (e) {
        // Increment retry count
        final newRetryCount = item.retryCount + 1;
        if (newRetryCount >= 5) {
          // Mark as failed after 5 retries
          await (db.update(db.syncQueue)..where((sq) => sq.id.equals(item.id)))
              .write(SyncQueueCompanion(
            status: const Value('failed'),
            retryCount: Value(newRetryCount),
            errorMessage: Value(e.toString()),
            updatedAt: Value(DateTime.now()),
          ));
        } else {
          await (db.update(db.syncQueue)..where((sq) => sq.id.equals(item.id)))
              .write(SyncQueueCompanion(
            retryCount: Value(newRetryCount),
            updatedAt: Value(DateTime.now()),
          ));
        }
      }
    }
  }

  /// Process single sync queue item
  Future<void> _processSyncQueueItem(AppDatabase db, SyncQueueRecord item) async {
    switch (item.entityType) {
      case 'medication':
        await _syncMedication(item);
        break;
      case 'schedule':
        await _syncSchedule(item);
        break;
      case 'intake_log':
        await _syncIntakeLog(item);
        break;
    }
  }

  /// Sync medication to Firestore
  Future<void> _syncMedication(SyncQueueRecord item) async {
    final data = jsonDecode(item.payload) as Map<String, dynamic>;
    final medication = Medication.fromMap(item.entityId, data);

    switch (item.operation) {
      case 'create':
      case 'update':
        final serverId = await _firestoreRepo.createMedication(medication);
        // Update local record with server ID
        final db = await _dbManager.database;
        await (db.update(db.medications)..where((m) => m.id.equals(item.entityId)))
            .write(MedicationsCompanion(serverId: Value(serverId)));
        break;
      case 'delete':
        await _firestoreRepo.deleteMedication(item.entityId);
        break;
    }
  }

  /// Sync schedule to Firestore
  Future<void> _syncSchedule(SyncQueueRecord item) async {
    final data = jsonDecode(item.payload) as Map<String, dynamic>;
    final schedule = Schedule.fromMap(item.entityId, data);

    switch (item.operation) {
      case 'create':
      case 'update':
        final serverId = await _firestoreRepo.createSchedule(schedule);
        final db = await _dbManager.database;
        await (db.update(db.schedules)..where((s) => s.id.equals(item.entityId)))
            .write(SchedulesCompanion(serverId: Value(serverId)));
        break;
      case 'delete':
        await _firestoreRepo.deleteSchedule(item.entityId);
        break;
    }
  }

  /// Sync intake log to Firestore
  Future<void> _syncIntakeLog(SyncQueueRecord item) async {
    final data = jsonDecode(item.payload) as Map<String, dynamic>;
    final log = IntakeLog.fromMap(item.entityId, data);

    switch (item.operation) {
      case 'create':
      case 'update':
        final serverId = await _firestoreRepo.createIntakeLog(log);
        final db = await _dbManager.database;
        await (db.update(db.intakeLogs)..where((l) => l.id.equals(item.entityId)))
            .write(IntakeLogsCompanion(serverId: const Value(serverId)));
        break;
      case 'delete':
        // Intake logs ไม่ลบ (คงประวัติ)
        break;
    }
  }

  /// Pull changes from Firestore
  Future<void> _pullFromFirestore(AppDatabase db) async {
    // Pull medications
    final remoteMeds = await _firestoreRepo.getMedications();
    for (final med in remoteMeds) {
      await db.into(db.medications).insert(
        MedicationsCompanion.insert(
          id: med.id,
          userId: _userId ?? '',
          name: med.name,
          quantity: med.quantity,
          lowStockThreshold: const Value(5),
          imageUrl: Value(med.imageUrl),
          notes: const Value(''),
          createdAt: med.createdAt,
          updatedAt: DateTime.now(),
          serverId: const Value(med.id),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }

    // Pull schedules
    final remoteSchedules = await _firestoreRepo.getSchedules();
    for (final schedule in remoteSchedules) {
      await db.into(db.schedules).insert(
        SchedulesCompanion.insert(
          id: schedule.id,
          medId: schedule.medId,
          userId: _userId ?? '',
          times: schedule.times.toString(),
          daysOfWeek: schedule.daysOfWeek.toString(),
          dosePerTime: const Value(1),
          isActive: const Value(true),
          updatedAt: DateTime.now(),
          serverId: const Value(schedule.id),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }

    // Pull intake logs
    final remoteLogs = await _firestoreRepo.getIntakeLogs();
    for (final log in remoteLogs) {
      await db.into(db.intakeLogs).insert(
        IntakeLogsCompanion.insert(
          id: log.id,
          medId: log.medId,
          userId: _userId ?? '',
          scheduledAt: log.scheduledAt,
          actedAt: Value(log.actedAt),
          status: log.status.name,
          dose: 1, // Default to 1 if not specified
          idempotencyKey: log.id,
          createdAt: DateTime.now(),
          serverId: const Value(log.id),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  /// Clear completed sync queue items
  Future<void> _clearCompletedSyncQueue(AppDatabase db) async {
    await (db.delete(db.syncQueue)..where((sq) => sq.status.equals('synced'))).go();
  }

  /// Add operation to sync queue
  Future<void> addToSyncQueue({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final db = await _dbManager.database;
    final id = 'sync_${DateTime.now().millisecondsSinceEpoch}';

    await db.into(db.syncQueue).insert(
      SyncQueueCompanion.insert(
        id: id,
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        payload: jsonEncode(payload),
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    // Trigger sync if connected
    if (await isConnected) {
      sync();
    }
  }

  /// Dispose
  void dispose() {
    _syncStatusController.close();
  }
}
