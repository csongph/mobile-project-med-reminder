import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme.dart';
import '../models/alarm_details.dart';
import '../../logs/models/intake_log.dart';

class MedicationAlarmScreen extends ConsumerStatefulWidget {
  final AlarmDetails details;

  const MedicationAlarmScreen({super.key, required this.details});

  @override
  ConsumerState<MedicationAlarmScreen> createState() =>
      _MedicationAlarmScreenState();
}

class _MedicationAlarmScreenState extends ConsumerState<MedicationAlarmScreen> {
  static const _alarmChannel = MethodChannel('med_reminder/alarm');
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _startVibration();
  }

  Future<void> _startVibration() async {
    try {
      await _alarmChannel.invokeMethod<void>('startAlarmVibration');
    } on PlatformException {
      // The alarm remains usable when vibration hardware is unavailable.
    } on MissingPluginException {
      // Desktop and web do not expose the Android alarm channel.
    }
  }

  Future<void> _record(IntakeStatus status) async {
    if (_working) return;
    setState(() => _working = true);
    final timeParts = widget.details.time.split(':');
    final hour = int.tryParse(timeParts.first) ?? DateTime.now().hour;
    final minute = timeParts.length > 1
        ? int.tryParse(timeParts[1]) ?? DateTime.now().minute
        : DateTime.now().minute;
    final now = DateTime.now();
    try {
      await ref
          .read(appStateProvider.notifier)
          .recordIntake(
            medId: widget.details.medicationId,
            scheduledAt: DateTime(now.year, now.month, now.day, hour, minute),
            status: status,
            dose: widget.details.dose,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _working = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกไม่สำเร็จ กรุณาลองอีกครั้ง')),
      );
    }
  }

  Future<void> _snooze() async {
    if (_working) return;
    setState(() => _working = true);
    try {
      await NotificationService().snoozeAlarm(widget.details);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _working = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เลื่อนการเตือนไม่สำเร็จ กรุณาลองอีกครั้ง'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _alarmChannel.invokeMethod<void>('stopAlarmVibration').ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.details;
    return Scaffold(
      backgroundColor: const Color(0xFF0B302E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFF174C48),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  size: 46,
                  color: Color(0xFF86DED3),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'ถึงเวลาทานยาแล้ว',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTheme.fontHeading,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                details.time,
                style: const TextStyle(
                  color: Color(0xFF86DED3),
                  fontSize: 56,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTheme.fontHeading,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      details.medicationName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTheme.fontHeading,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'รับประทาน ${details.dose} เม็ด',
                      style: const TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 18,
                        fontFamily: AppTheme.fontBody,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton.icon(
                  onPressed: _working
                      ? null
                      : () => _record(IntakeStatus.taken),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF53C8A7),
                    foregroundColor: const Color(0xFF062B27),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text(
                    'ทานแล้ว',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: _working ? null : _snooze,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF86DED3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.snooze_rounded),
                  label: const Text('เลื่อนเตือน 5 นาที'),
                ),
              ),
              TextButton(
                onPressed: _working
                    ? null
                    : () => _record(IntakeStatus.skipped),
                child: const Text(
                  'ข้ามมื้อนี้',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
