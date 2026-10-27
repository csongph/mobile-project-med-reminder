import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/dose_card.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/state/app_state.dart';
import '../../medications/models/medication.dart';
import '../../logs/models/intake_log.dart';
import '../../medications/screens/add_edit_medication_screen.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'สวัสดีตอนเช้า ☀️';
    if (hour < 17) return 'สวัสดีตอนบ่าย 🌤️';
    return 'สวัสดีตอนเย็น 🌙';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final now = DateTime.now();
    final thaiDateFormat = DateFormat('EEEEที่ d MMMM yyyy', 'th');
    final formattedDate = thaiDateFormat.format(now);

    // ดึงมื้อยาวันนี้ทั้งหมด
    final currentDayOfWeek = now.weekday; // 1 = จันทร์, ..., 7 = อาทิตย์
    final List<DoseItem> todayDoses = [];

    for (final schedule in state.schedules.where((s) => s.isActive)) {
      if (!schedule.daysOfWeek.contains(currentDayOfWeek)) continue;

      final med = state.medications.firstWhere(
        (m) => m.id == schedule.medId,
        orElse: () => Medication(
          id: '',
          name: 'ไม่พบชื่อยา',
          quantity: 0,
          createdAt: now,
        ),
      );
      if (med.id.isEmpty) continue;

      for (final timeStr in schedule.times) {
        final parts = timeStr.split(':');
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;

        final log = state.logs.firstWhere(
          (l) =>
              l.medId == med.id &&
              l.scheduledAt.year == now.year &&
              l.scheduledAt.month == now.month &&
              l.scheduledAt.day == now.day &&
              l.scheduledAt.hour == hour &&
              l.scheduledAt.minute == minute,
          orElse: () => IntakeLog(
            id: '',
            medId: '',
            scheduledAt: now,
            status: IntakeStatus.missed,
          ),
        );

        todayDoses.add(
          DoseItem(
            scheduleId: schedule.id,
            time: timeStr,
            medication: med,
            dose: schedule.dosePerTime,
            log: log.id.isNotEmpty ? log : null,
          ),
        );
      }
    }

    // เรียงตามเวลา
    todayDoses.sort((a, b) => a.time.compareTo(b.time));

    final totalDoses = todayDoses.length;
    final takenDoses = todayDoses
        .where((d) => d.status == IntakeStatus.taken)
        .length;
    final progress = totalDoses > 0 ? takenDoses / totalDoses : 0.0;

    // ค้นหามื้อถัดไป
    final nextDose = todayDoses.firstWhere(
      (d) => d.status == null,
      orElse: () => DoseItem(
        scheduleId: '',
        time: '',
        medication: Medication(id: '', name: '', quantity: 0, createdAt: now),
        dose: 0,
      ),
    );

    // ตรวจสอบยาที่ใกล้หมด
    final lowStockMeds = state.medications.where((m) => m.isLowStock).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          _getGreeting(),
          style: const TextStyle(
            fontFamily: AppTheme.fontHeading,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // วันที่
          Text(
            formattedDate,
            style: const TextStyle(
              fontFamily: AppTheme.fontBody,
              fontSize: 16,
              color: AppTheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // แถบเตือนยาใกล้หมด (ถ้ามี)
          if (state.lowStockAlertsEnabled && lowStockMeds.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.warnBackground,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                border: Border.all(color: AppTheme.warnInk),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppTheme.statusLowStock,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'แจ้งเตือน: มียาใกล้หมด ${lowStockMeds.length} รายการ (${lowStockMeds.map((e) => e.name).join(', ')})',
                      style: const TextStyle(
                        fontFamily: AppTheme.fontBody,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.statusLowStock,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // การ์ดสรุปความคืบหน้าของวันนี้
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white,
                        color: AppTheme.primary,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontFamily: AppTheme.fontHeading,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ความคืบหน้าวันนี้',
                        style: TextStyle(
                          fontFamily: AppTheme.fontHeading,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalDoses > 0
                            ? 'ทานแล้ว $takenDoses จากทั้งหมด $totalDoses มื้อ'
                            : 'ไม่มีมื้อยาที่ต้องทานในวันนี้',
                        style: const TextStyle(
                          fontFamily: AppTheme.fontBody,
                          fontSize: 15,
                          color: AppTheme.secondary,
                        ),
                      ),
                      if (totalDoses > 0 && takenDoses == totalDoses)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            '🎉 เก่งมากครับ! วันนี้ทานยาครบทุกมื้อแล้ว',
                            style: TextStyle(
                              fontFamily: AppTheme.fontBody,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.statusTaken,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ไทม์ไลน์มื้อยาวันนี้
          const SectionHeader(title: 'มื้อยาที่ต้องทานวันนี้ 🕒'),
          if (todayDoses.isEmpty)
            EmptyState(
              title: 'ไม่มียาที่ต้องทานวันนี้',
              subtitle: 'กดปุ่มเพิ่มยาเพื่อเริ่มต้นจัดตารางแจ้งเตือน',
              icon: Icons.check_circle_outline_rounded,
              buttonLabel: 'เพิ่มยาตัวแรก',
              onButtonPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddEditMedicationScreen(),
                  ),
                );
              },
            )
          else
            ...todayDoses.map((item) {
              final isNext =
                  item.scheduleId == nextDose.scheduleId &&
                  item.time == nextDose.time;
              final parts = item.time.split(':');
              final scheduleDateTime = DateTime(
                now.year,
                now.month,
                now.day,
                int.parse(parts[0]),
                int.parse(parts[1]),
              );

              return DoseCard(
                timeText: item.time,
                medName: item.medication.name,
                dose: item.dose,
                isNextDose: isNext,
                status: item.status,
                onTake: () async {
                  try {
                    await ref
                        .read(appStateProvider.notifier)
                        .recordIntake(
                          medId: item.medication.id,
                          scheduledAt: scheduleDateTime,
                          status: IntakeStatus.taken,
                          dose: item.dose,
                        );
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('บันทึกไม่สำเร็จ กรุณาลองอีกครั้ง'),
                      ),
                    );
                    return;
                  }
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppTheme.statusTaken,
                      content: Text(
                        'บันทึก: ทานยา ${item.medication.name} แล้วเรียบร้อย',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                onSkip: () async {
                  try {
                    await ref
                        .read(appStateProvider.notifier)
                        .recordIntake(
                          medId: item.medication.id,
                          scheduledAt: scheduleDateTime,
                          status: IntakeStatus.skipped,
                          dose: item.dose,
                        );
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('บันทึกไม่สำเร็จ กรุณาลองอีกครั้ง'),
                      ),
                    );
                    return;
                  }
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppTheme.statusSkipped,
                      content: Text(
                        'บันทึก: ข้ามยา ${item.medication.name} มื้อนี้',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
