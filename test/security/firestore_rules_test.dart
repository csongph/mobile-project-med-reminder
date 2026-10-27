import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Contract tests for the Firestore rules shipped with the app.
///
/// These tests run without network access and prevent an accidental rules
/// change from removing the per-user data boundary.
void main() {
  test('Firestore rules require authentication and owner UID', () {
    final rules = File('firestore.rules').readAsStringSync();

    expect(rules, contains('request.auth != null'));
    expect(rules, contains('request.auth.uid == userId'));
    expect(rules, contains('match /users/{userId}'));
    expect(rules, contains('match /medications/{medId}'));
    expect(rules, contains('match /schedules/{scheduleId}'));
    expect(rules, contains('match /intake_logs/{logId}'));
  });
}
