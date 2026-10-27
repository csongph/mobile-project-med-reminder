/// โมเดลตารางเวลาการทานยา (Schedule)
class Schedule {
  final String id;
  final String medId;
  final List<String> times; // ในรูปแบบ "HH:mm" เช่น "08:00", "20:00"
  final List<int> daysOfWeek; // 1 = จันทร์, ..., 7 = อาทิตย์
  final int dosePerTime; // จำนวนเม็ดต่อมื้อ
  final bool isActive;

  Schedule({
    required this.id,
    required this.medId,
    required this.times,
    required this.daysOfWeek,
    this.dosePerTime = 1,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'medId': medId,
      'times': times,
      'daysOfWeek': daysOfWeek,
      'dosePerTime': dosePerTime,
      'isActive': isActive,
      'isDeleted': false,
    };
  }

  factory Schedule.fromMap(String id, Map<String, dynamic> map) {
    return Schedule(
      id: id,
      medId: map['medId'] ?? '',
      times: List<String>.from(map['times'] ?? []),
      daysOfWeek: List<int>.from(map['daysOfWeek'] ?? [1, 2, 3, 4, 5, 6, 7]),
      dosePerTime: (map['dosePerTime'] as num?)?.toInt() ?? 1,
      isActive: map['isActive'] ?? true,
    );
  }

  Schedule copyWith({
    String? id,
    String? medId,
    List<String>? times,
    List<int>? daysOfWeek,
    int? dosePerTime,
    bool? isActive,
  }) {
    return Schedule(
      id: id ?? this.id,
      medId: medId ?? this.medId,
      times: times ?? this.times,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      dosePerTime: dosePerTime ?? this.dosePerTime,
      isActive: isActive ?? this.isActive,
    );
  }
}
