import 'dart:convert';

class AlarmDetails {
  final String medicationId;
  final String medicationName;
  final String time;
  final int dose;
  final int notificationId;

  const AlarmDetails({
    required this.medicationId,
    required this.medicationName,
    required this.time,
    required this.dose,
    required this.notificationId,
  });

  String toPayload() => jsonEncode({
    'medicationId': medicationId,
    'medicationName': medicationName,
    'time': time,
    'dose': dose,
    'notificationId': notificationId,
  });

  static AlarmDetails? fromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final medicationId = data['medicationId'] as String?;
      final medicationName = data['medicationName'] as String?;
      final time = data['time'] as String?;
      final dose = (data['dose'] as num?)?.toInt();
      final notificationId = (data['notificationId'] as num?)?.toInt();
      if (medicationId == null ||
          medicationName == null ||
          time == null ||
          dose == null ||
          notificationId == null) {
        return null;
      }
      return AlarmDetails(
        medicationId: medicationId,
        medicationName: medicationName,
        time: time,
        dose: dose,
        notificationId: notificationId,
      );
    } catch (_) {
      return null;
    }
  }

  AlarmDetails copyWith({int? notificationId}) => AlarmDetails(
    medicationId: medicationId,
    medicationName: medicationName,
    time: time,
    dose: dose,
    notificationId: notificationId ?? this.notificationId,
  );
}
