import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

import '../../features/medications/models/medication.dart';
import '../../features/schedules/models/schedule.dart';
import '../../features/logs/models/intake_log.dart';
import '../services/notification_service.dart';

class DoseItem {
  final String scheduleId;
  final String time;
  final Medication medication;
  final int dose;
  final IntakeLog? log;
  DoseItem({
    required this.scheduleId,
    required this.time,
    required this.medication,
    required this.dose,
    this.log,
  });
  bool get isCompleted => log != null;
  IntakeStatus? get status => log?.status;
}

class AppState {
  final List<Medication> medications;
  final List<Schedule> schedules;
  final List<IntakeLog> logs;
  final bool remindersEnabled;
  final bool lowStockAlertsEnabled;
  AppState({
    required this.medications,
    required this.schedules,
    required this.logs,
    this.remindersEnabled = false,
    this.lowStockAlertsEnabled = true,
  });
  factory AppState.initial() =>
      AppState(medications: [], schedules: [], logs: []);
  AppState copyWith({
    List<Medication>? medications,
    List<Schedule>? schedules,
    List<IntakeLog>? logs,
    bool? remindersEnabled,
    bool? lowStockAlertsEnabled,
  }) => AppState(
    medications: medications ?? this.medications,
    schedules: schedules ?? this.schedules,
    logs: logs ?? this.logs,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    lowStockAlertsEnabled: lowStockAlertsEnabled ?? this.lowStockAlertsEnabled,
  );
}

class AppStateNotifier extends Notifier<AppState> {
  static const MethodChannel _storageChannel = MethodChannel(
    'med_reminder/storage',
  );
  int _stateRevision = 0;
  Future<void> _persistenceQueue = Future<void>.value();
  late Future<void> _loadingFuture;

  @override
  AppState build() {
    _loadingFuture = _load();
    return AppState.initial();
  }

  Future<void> _load() async {
    final revisionAtStart = _stateRevision;
    try {
      final raw = await _storageChannel.invokeMethod<String>('read');
      if (raw == null) return;
      final data = jsonDecode(raw) as Map<String, dynamic>;
      var loaded = AppState(
        medications: (data['medications'] as List? ?? [])
            .map(
              (m) => Medication.fromMap(
                m['id'] as String,
                Map<String, dynamic>.from(m['data'] as Map),
              ),
            )
            .toList(),
        schedules: (data['schedules'] as List? ?? [])
            .map(
              (s) => Schedule.fromMap(
                s['id'] as String,
                Map<String, dynamic>.from(s['data'] as Map),
              ),
            )
            .toList(),
        logs: (data['logs'] as List? ?? [])
            .map(
              (l) => IntakeLog.fromMap(
                l['id'] as String,
                Map<String, dynamic>.from(l['data'] as Map),
              ),
            )
            .toList(),
        remindersEnabled: data['remindersEnabled'] as bool? ?? false,
        lowStockAlertsEnabled: data['lowStockAlertsEnabled'] as bool? ?? true,
      );
      if (loaded.remindersEnabled) {
        try {
          if (!await NotificationService().notificationsAllowed()) {
            loaded = loaded.copyWith(remindersEnabled: false);
          }
        } catch (_) {
          // Preserve saved reminder preferences if the OS status is unavailable.
        }
      }
      // A user may have changed data while the asynchronous read was in flight.
      if (revisionAtStart != _stateRevision) return;
      state = loaded;
      try {
        await _persist();
      } catch (_) {
        // Keep loaded data available if storage or notification setup fails.
      }
    } catch (_) {
      if (revisionAtStart == _stateRevision) state = AppState.initial();
    }
  }

  Future<void> _persist() {
    final snapshot = state;
    final json = jsonEncode({
      'medications': snapshot.medications
          .map((m) => {'id': m.id, 'data': m.toMap()})
          .toList(),
      'schedules': snapshot.schedules
          .map((s) => {'id': s.id, 'data': s.toMap()})
          .toList(),
      'logs': snapshot.logs
          .map((l) => {'id': l.id, 'data': l.toMap()})
          .toList(),
      'remindersEnabled': snapshot.remindersEnabled,
      'lowStockAlertsEnabled': snapshot.lowStockAlertsEnabled,
    });

    // Serialize disk writes and notification rebuilds so an older snapshot
    // cannot finish after, and replace, a newer one.
    _persistenceQueue = _persistenceQueue.catchError((Object _) {}).then((
      _,
    ) async {
      await _storageChannel.invokeMethod<void>('write', json);
      try {
        await NotificationService().syncMedicationReminders(
          medications: snapshot.medications,
          schedules: snapshot.schedules,
          enabled: snapshot.remindersEnabled,
        );
      } catch (_) {
        // Keep saved medication data even if OS scheduling is unavailable.
      }
    });
    return _persistenceQueue;
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    await _loadingFuture;
    state = state.copyWith(remindersEnabled: enabled);
    _stateRevision++;
    await _persist();
  }

  Future<void> setLowStockAlertsEnabled(bool enabled) async {
    await _loadingFuture;
    state = state.copyWith(lowStockAlertsEnabled: enabled);
    _stateRevision++;
    await _persist();
  }

  Future<void> addMedication({
    required String name,
    required int quantity,
    required int lowStockThreshold,
    required String notes,
    required List<String> times,
    required List<int> daysOfWeek,
    required int dosePerTime,
    String? imageUrl,
  }) async {
    await _loadingFuture;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    state = state.copyWith(
      medications: [
        ...state.medications,
        Medication(
          id: id,
          name: name,
          quantity: quantity,
          lowStockThreshold: lowStockThreshold,
          notes: notes,
          imageUrl: imageUrl,
          createdAt: DateTime.now(),
        ),
      ],
      schedules: [
        ...state.schedules,
        Schedule(
          id: 'sch_$id',
          medId: id,
          times: times,
          daysOfWeek: daysOfWeek,
          dosePerTime: dosePerTime,
        ),
      ],
    );
    _stateRevision++;
    await _persist();
  }

  Future<void> updateMedication(
    Medication medication,
    Schedule schedule,
  ) async {
    await _loadingFuture;
    state = state.copyWith(
      medications: state.medications
          .map((m) => m.id == medication.id ? medication : m)
          .toList(),
      schedules: [
        ...state.schedules.where((s) => s.medId != medication.id),
        schedule,
      ],
    );
    _stateRevision++;
    await _persist();
  }

  Future<void> deleteMedication(String medId) async {
    await _loadingFuture;
    state = state.copyWith(
      medications: state.medications.where((m) => m.id != medId).toList(),
      schedules: state.schedules.where((s) => s.medId != medId).toList(),
      logs: state.logs.where((l) => l.medId != medId).toList(),
    );
    _stateRevision++;
    await _persist();
  }

  Future<void> recordIntake({
    required String medId,
    required DateTime scheduledAt,
    required IntakeStatus status,
    required int dose,
  }) async {
    await _loadingFuture;
    final id = 'log_${scheduledAt.millisecondsSinceEpoch}_$medId';
    final existing = state.logs.where((l) => l.id == id).firstOrNull;
    var meds = state.medications;
    if (status == IntakeStatus.taken &&
        existing?.status != IntakeStatus.taken) {
      meds = meds
          .map(
            (m) => m.id == medId
                ? m.copyWith(quantity: (m.quantity - dose).clamp(0, 99999))
                : m,
          )
          .toList();
    } else if (existing?.status == IntakeStatus.taken &&
        status != IntakeStatus.taken) {
      meds = meds
          .map(
            (m) => m.id == medId ? m.copyWith(quantity: m.quantity + dose) : m,
          )
          .toList();
    }
    final log = IntakeLog(
      id: id,
      medId: medId,
      scheduledAt: scheduledAt,
      actedAt: DateTime.now(),
      status: status,
    );
    state = state.copyWith(
      medications: meds,
      logs: [...state.logs.where((l) => l.id != id), log],
    );
    _stateRevision++;
    await _persist();
  }

  Future<void> clearAllData() async {
    await _loadingFuture;
    state = AppState.initial();
    _stateRevision++;
    await _persist();
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(
  AppStateNotifier.new,
);
