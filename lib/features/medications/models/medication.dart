import 'package:cloud_firestore/cloud_firestore.dart';

/// โมเดลข้อมูลยา (Medication)
class Medication {
  final String id;
  final String name;
  final int quantity;
  final int lowStockThreshold;
  final String? imageUrl;
  final String notes;
  final DateTime createdAt;

  Medication({
    required this.id,
    required this.name,
    required this.quantity,
    this.lowStockThreshold = 5,
    this.imageUrl,
    this.notes = '',
    required this.createdAt,
  });

  bool get isLowStock => quantity <= lowStockThreshold;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'lowStockThreshold': lowStockThreshold,
      'imageUrl': imageUrl,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Medication.fromMap(String id, Map<String, dynamic> map) {
    return Medication(
      id: id,
      name: map['name'] ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      lowStockThreshold: (map['lowStockThreshold'] as num?)?.toInt() ?? 5,
      imageUrl: map['imageUrl'],
      notes: map['notes'] ?? '',
      createdAt: _dateFromMap(map['createdAt']),
    );
  }

  static DateTime _dateFromMap(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  Medication copyWith({
    String? id,
    String? name,
    int? quantity,
    int? lowStockThreshold,
    String? imageUrl,
    String? notes,
    DateTime? createdAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
