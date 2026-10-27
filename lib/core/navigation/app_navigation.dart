import 'package:flutter/material.dart';
import '../../features/alarms/models/alarm_details.dart';

typedef AlarmScreenBuilder = Widget Function(AlarmDetails details);

class AppNavigation {
  AppNavigation._();

  static final navigatorKey = GlobalKey<NavigatorState>();
  static AlarmScreenBuilder? alarmScreenBuilder;
  static AlarmDetails? _pendingAlarm;

  static void openAlarm(AlarmDetails details) {
    final navigator = navigatorKey.currentState;
    final builder = alarmScreenBuilder;
    if (navigator == null || builder == null) {
      _pendingAlarm = details;
      return;
    }
    navigator.push(MaterialPageRoute<void>(builder: (_) => builder(details)));
  }

  static void openPendingAlarm() {
    final pending = _pendingAlarm;
    if (pending == null) return;
    _pendingAlarm = null;
    openAlarm(pending);
  }
}
