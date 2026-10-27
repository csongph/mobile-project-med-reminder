import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/medications/models/medication.dart';
import '../../features/schedules/models/schedule.dart';
import '../../features/logs/models/intake_log.dart';

/// Repository สำหรับจัดการ Firestore operations
class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ดึง user ID ปัจจุบัน
  String? get _userId => _auth.currentUser?.uid;

  /// ตรวจสอบว่า user ล็อกอินอยู่หรือไม่
  bool get _isSignedIn => _auth.currentUser != null;

  /// ============ MEDICATIONS ============

  /// สร้าง medication ใหม่
  Future<String> createMedication(Medication medication) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .doc(medication.id);
    await docRef.set(medication.toMap(), SetOptions(merge: true));

    return docRef.id;
  }

  /// อัปเดต medication
  Future<void> updateMedication(Medication medication) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .doc(medication.id)
        .set(medication.toMap(), SetOptions(merge: true));
  }

  /// ลบ medication (soft delete)
  Future<void> deleteMedication(String medicationId) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .doc(medicationId)
        .update({'isDeleted': true});
  }

  /// ดึง medications ทั้งหมดของ user
  Future<List<Medication>> getMedications() async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .where('isDeleted', isEqualTo: false)
        .get();

    return snapshot.docs.map((doc) {
      return Medication.fromMap(doc.id, doc.data());
    }).toList();
  }

  /// Stream ของ medications (real-time updates)
  Stream<List<Medication>> medicationsStream() {
    if (!_isSignedIn) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Medication.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  /// ============ SCHEDULES ============

  /// สร้าง schedule ใหม่
  Future<String> createSchedule(Schedule schedule) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('schedules')
        .doc(schedule.id);
    await docRef.set(schedule.toMap(), SetOptions(merge: true));

    return docRef.id;
  }

  /// อัปเดต schedule
  Future<void> updateSchedule(Schedule schedule) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('schedules')
        .doc(schedule.id)
        .set(schedule.toMap(), SetOptions(merge: true));
  }

  /// ลบ schedule (soft delete)
  Future<void> deleteSchedule(String scheduleId) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('schedules')
        .doc(scheduleId)
        .update({'isDeleted': true});
  }

  /// ดึง schedules ทั้งหมดของ user
  Future<List<Schedule>> getSchedules() async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('schedules')
        .where('isDeleted', isEqualTo: false)
        .get();

    return snapshot.docs.map((doc) {
      return Schedule.fromMap(doc.id, doc.data());
    }).toList();
  }

  /// Stream ของ schedules (real-time updates)
  Stream<List<Schedule>> schedulesStream() {
    if (!_isSignedIn) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('schedules')
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Schedule.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  /// ============ INTAKE LOGS ============

  /// สร้าง intake log ใหม่
  Future<String> createIntakeLog(IntakeLog log) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('intake_logs')
        .doc(log.id);
    await docRef.set(log.toMap(), SetOptions(merge: true));

    return docRef.id;
  }

  /// อัปเดต intake log
  Future<void> updateIntakeLog(IntakeLog log) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('intake_logs')
        .doc(log.id)
        .set(log.toMap(), SetOptions(merge: true));
  }

  /// ดึง intake logs ทั้งหมดของ user
  Future<List<IntakeLog>> getIntakeLogs() async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('intake_logs')
        .orderBy('scheduledAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return IntakeLog.fromMap(doc.id, doc.data());
    }).toList();
  }

  /// Stream ของ intake logs (real-time updates)
  Stream<List<IntakeLog>> intakeLogsStream() {
    if (!_isSignedIn) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('intake_logs')
        .orderBy('scheduledAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return IntakeLog.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  /// ดึง intake logs ตาม medication ID
  Future<List<IntakeLog>> getIntakeLogsByMedication(String medId) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('intake_logs')
        .where('medId', isEqualTo: medId)
        .orderBy('scheduledAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return IntakeLog.fromMap(doc.id, doc.data());
    }).toList();
  }

  /// ============ BATCH OPERATIONS ============

  /// Sync medications ทั้งหมด (สำหรับ initial sync)
  Future<void> syncMedications(List<Medication> medications) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final batch = _firestore.batch();
    final collection = _firestore
        .collection('users')
        .doc(_userId)
        .collection('medications');

    for (final med in medications) {
      final docRef = collection.doc(med.id);
      batch.set(docRef, med.toMap(), SetOptions(merge: true));
    }

    await batch.commit();
  }

  /// Sync schedules ทั้งหมด (สำหรับ initial sync)
  Future<void> syncSchedules(List<Schedule> schedules) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final batch = _firestore.batch();
    final collection = _firestore
        .collection('users')
        .doc(_userId)
        .collection('schedules');

    for (final schedule in schedules) {
      final docRef = collection.doc(schedule.id);
      batch.set(docRef, schedule.toMap(), SetOptions(merge: true));
    }

    await batch.commit();
  }

  /// Sync intake logs ทั้งหมด (สำหรับ initial sync)
  Future<void> syncIntakeLogs(List<IntakeLog> logs) async {
    if (!_isSignedIn) throw Exception('User not signed in');

    final batch = _firestore.batch();
    final collection = _firestore
        .collection('users')
        .doc(_userId)
        .collection('intake_logs');

    for (final log in logs) {
      final docRef = collection.doc(log.id);
      batch.set(docRef, log.toMap(), SetOptions(merge: true));
    }

    await batch.commit();
  }
}
