import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/services.dart';
import '../../features/medications/models/medication.dart';
import '../../features/schedules/models/schedule.dart';
import '../../features/alarms/models/alarm_details.dart';
import '../navigation/app_navigation.dart';

/// Service จัดการระบบแจ้งเตือนของ Med Reminder
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final Int64List _notificationVibrationPattern = Int64List.fromList([
    0,
    ...List<int>.generate(60, (index) => index.isEven ? 1000 : 500),
  ]);

  static final AndroidNotificationDetails _alarmNotificationDetails =
      AndroidNotificationDetails(
        'med_reminder_alarm_v2',
        'ปลุกทานยา',
        channelDescription: 'ปลุกเต็มหน้าจอตามเวลาทานยา',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        fullScreenIntent: true,
        autoCancel: true,
        ongoing: false,
        visibility: NotificationVisibility.public,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        enableVibration: true,
        vibrationPattern: _notificationVibrationPattern,
        color: const Color(0xFF0A6B66),
      );

  Future<void> initialize() async {
    // 1. ตั้งค่า Timezone ให้ตรงกับเวลาท้องถิ่น หรือ Asia/Bangkok
    tz.initializeTimeZones();
    try {
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));
    }

    // 2. ตั้งค่าไอคอนสำหรับ Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
    final launchDetails = await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    final launchPayload = launchDetails?.notificationResponse?.payload;
    if (launchDetails?.didNotificationLaunchApp == true) {
      _openAlarmFromPayload(launchPayload);
    }
  }

  void _handleNotificationResponse(NotificationResponse response) {
    _openAlarmFromPayload(response.payload);
  }

  void _openAlarmFromPayload(String? payload) {
    final details = AlarmDetails.fromPayload(payload);
    if (details != null) AppNavigation.openAlarm(details);
  }

  /// ขอสิทธิ์แจ้งเตือนสำหรับ Android 13+
  Future<bool> requestPermissions({
    bool requestFullScreenIntent = false,
  }) async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      var allowed =
          await androidImplementation.areNotificationsEnabled() == true;
      if (!allowed) {
        final granted = await androidImplementation
            .requestNotificationsPermission();
        allowed =
            granted == true ||
            (await androidImplementation.areNotificationsEnabled() ?? false);
      }
      if (!allowed) return false;
      // Android 14+ requires a separate special-access grant for full-screen
      // alarms. Denying it still leaves the standard reminder notification.
      if (requestFullScreenIntent) {
        try {
          await androidImplementation.requestFullScreenIntentPermission();
        } catch (_) {
          // Older Android versions or OEM builds may not expose this setting.
        }
      }
      return true;
    }
    final iosImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosImplementation != null) {
      return await iosImplementation.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  Future<int> pendingReminderCount() async =>
      (await flutterLocalNotificationsPlugin.pendingNotificationRequests())
          .length;

  Future<NotificationStatus> getStatus() async => NotificationStatus(
    notificationsAllowed: await notificationsAllowed(),
    pendingCount: await pendingReminderCount(),
    fullScreenAllowed: await fullScreenIntentsAllowed(),
  );

  Future<bool> fullScreenIntentsAllowed() async {
    final android = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return true;
    try {
      return await const MethodChannel(
            'med_reminder/alarm',
          ).invokeMethod<bool>('canUseFullScreenIntent') ??
          false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> notificationsAllowed() async {
    final android = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }
    return true;
  }

  /// Rebuild the recurring local reminders from the user's saved schedules.
  Future<void> syncMedicationReminders({
    required List<Medication> medications,
    required List<Schedule> schedules,
    required bool enabled,
  }) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    if (!enabled) return;

    final medicineById = {
      for (final medicine in medications) medicine.id: medicine,
    };
    for (final schedule in schedules.where((item) => item.isActive)) {
      final medicine = medicineById[schedule.medId];
      if (medicine == null) continue;
      for (final day in schedule.daysOfWeek.toSet()) {
        for (final time in schedule.times.toSet()) {
          final parts = time.split(':');
          if (parts.length != 2) continue;
          final hour = int.tryParse(parts[0]);
          final minute = int.tryParse(parts[1]);
          if (hour == null ||
              minute == null ||
              hour > 23 ||
              minute > 59 ||
              day < 1 ||
              day > 7) {
            continue;
          }
          final now = tz.TZDateTime.now(tz.local);
          var next = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );
          while (next.weekday != day || !next.isAfter(now)) {
            next = next.add(const Duration(days: 1));
          }
          await flutterLocalNotificationsPlugin.zonedSchedule(
            id: _notificationId(schedule.medId, day, hour, minute),
            title: 'ถึงเวลาทานยา',
            body: '${medicine.name} · ${schedule.dosePerTime} เม็ด',
            scheduledDate: next,
            notificationDetails: NotificationDetails(
              android: _alarmNotificationDetails,
              iOS: const DarwinNotificationDetails(),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            payload: AlarmDetails(
              medicationId: schedule.medId,
              medicationName: medicine.name,
              time: time,
              dose: schedule.dosePerTime,
              notificationId: _notificationId(
                schedule.medId,
                day,
                hour,
                minute,
              ),
            ).toPayload(),
          );
        }
      }
    }
  }

  int _notificationId(String medId, int day, int hour, int minute) =>
      (Object.hash(medId, day, hour, minute) & 0x7fffffff);

  Future<void> snoozeAlarm(AlarmDetails details) async {
    final snoozeId =
        0x40000000 | (DateTime.now().microsecondsSinceEpoch & 0x3fffffff);
    final snoozedDetails = details.copyWith(notificationId: snoozeId);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: snoozeId,
      title: 'ถึงเวลาทานยาแล้ว',
      body: '${details.medicationName} · ${details.dose} เม็ด',
      scheduledDate: tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(minutes: 5)),
      notificationDetails: NotificationDetails(
        android: _alarmNotificationDetails,
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: snoozedDetails.toPayload(),
    );
  }

  /// แสดงการแจ้งเตือนทันที (สำหรับทดสอบ)
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'med_reminder_channel',
          'การแจ้งเตือนทานยา',
          channelDescription: 'แจ้งเตือนเมื่อถึงเวลาทานยา',
          importance: Importance.max,
          priority: Priority.high,
          color: Color(0xFF0A6B66), // Figma primary token
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformDetails,
      payload: payload,
    );
  }
}

class NotificationStatus {
  final bool notificationsAllowed;
  final int pendingCount;
  final bool fullScreenAllowed;

  const NotificationStatus({
    required this.notificationsAllowed,
    required this.pendingCount,
    required this.fullScreenAllowed,
  });
}
