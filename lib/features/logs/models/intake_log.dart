import 'package:cloud_firestore/cloud_firestore.dart';

enum IntakeStatus { taken, skipped, missed }

/// โมเดลบันทึกประวัติการทานยา (IntakeLog)
class IntakeLog {
  final String id;
  final String medId;
  final DateTime scheduledAt;
  final DateTime? actedAt;
  final IntakeStatus status;
  final int dose;

  IntakeLog({
    required this.id,
    required this.medId,
    required this.scheduledAt,
    this.actedAt,
    required this.status,
    this.dose = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'medId': medId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'actedAt': actedAt?.toIso8601String(),
      'status': status.name,
      'dose': dose,
    };
  }

  factory IntakeLog.fromMap(String id, Map<String, dynamic> map) {
    return IntakeLog(
      id: id,
      medId: map['medId'] ?? '',
      scheduledAt: _dateFromMap(map['scheduledAt']) ?? DateTime.now(),
      actedAt: _dateFromMap(map['actedAt']),
      status: IntakeStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => IntakeStatus.missed,
      ),
      dose: (map['dose'] as num?)?.toInt() ?? 1,
    );
  }

  static DateTime? _dateFromMap(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  IntakeLog copyWith({
    String? id,
    String? medId,
    DateTime? scheduledAt,
    DateTime? actedAt,
    IntakeStatus? status,
    int? dose,
  }) {
    return IntakeLog(
      id: id ?? this.id,
      medId: medId ?? this.medId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      actedAt: actedAt ?? this.actedAt,
      status: status ?? this.status,
      dose: dose ?? this.dose,
    );
  }
}
