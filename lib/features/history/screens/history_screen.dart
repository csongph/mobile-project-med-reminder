import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/state/app_state.dart';
import '../../medications/models/medication.dart';
import '../../logs/models/intake_log.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final now = DateTime.now();
    final thaiDateFormat = DateFormat('d MMMM yyyy', 'th');

    // กรอง log ตามวันที่เลือก
    final dayLogs = state.logs.where((l) {
      return l.scheduledAt.year == _selectedDate.year &&
          l.scheduledAt.month == _selectedDate.month &&
          l.scheduledAt.day == _selectedDate.day;
    }).toList()..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    // สรุปมื้อที่ถึงเวลาแล้วจากตารางยา เพื่อให้นับมื้อที่ยังไม่ได้กดบันทึกด้วย
    final past7Days = List.generate(
      7,
      (i) => DateTime(now.year, now.month, now.day - (6 - i)),
    );
    final plannedByDay = <String, Set<String>>{};
    final takenByDay = <String, Set<String>>{};
    String dateKey(DateTime date) => '${date.year}-${date.month}-${date.day}';

    for (final day in past7Days) {
      final key = dateKey(day);
      plannedByDay[key] = <String>{};
      takenByDay[key] = <String>{};
      for (final schedule in state.schedules.where((item) => item.isActive)) {
        if (!schedule.daysOfWeek.contains(day.weekday) ||
            !state.medications.any((med) => med.id == schedule.medId)) {
          continue;
        }
        for (final time in schedule.times) {
          final parts = time.split(':');
          if (parts.length != 2) continue;
          final hour = int.tryParse(parts[0]);
          final minute = int.tryParse(parts[1]);
          if (hour == null || minute == null || hour > 23 || minute > 59) {
            continue;
          }
          final scheduledAt = DateTime(
            day.year,
            day.month,
            day.day,
            hour,
            minute,
          );
          if (scheduledAt.isAfter(now)) continue;
          final doseKey = '${schedule.medId}-$time';
          plannedByDay[key]!.add(doseKey);
          if (state.logs.any(
            (log) =>
                log.medId == schedule.medId &&
                log.scheduledAt.year == day.year &&
                log.scheduledAt.month == day.month &&
                log.scheduledAt.day == day.day &&
                log.scheduledAt.hour == hour &&
                log.scheduledAt.minute == minute &&
                log.status == IntakeStatus.taken,
          )) {
            takenByDay[key]!.add(doseKey);
          }
        }
      }
    }

    final weekTotal = plannedByDay.values.fold<int>(
      0,
      (sum, doses) => sum + doses.length,
    );
    final weekTaken = takenByDay.values.fold<int>(
      0,
      (sum, doses) => sum + doses.length,
    );

    final double complianceRate = weekTotal > 0
        ? (weekTaken / weekTotal) * 100
        : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('ประวัติการทานยา 📊')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // การ์ดสรุปอัตราการทานยาตรงเวลา 7 วัน
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              boxShadow: AppTheme.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'สถิติในรอบ 7 วันที่ผ่านมา',
                      style: TextStyle(
                        fontFamily: AppTheme.fontHeading,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    Text(
                      weekTotal > 0
                          ? '${complianceRate.toStringAsFixed(0)}%'
                          : '—',
                      style: const TextStyle(
                        fontFamily: AppTheme.fontHeading,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.statusTaken,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  weekTotal > 0
                      ? 'นับจากมื้อที่ถึงเวลาแล้ว $weekTaken จาก $weekTotal มื้อ'
                      : 'ยังไม่มีมื้อยาที่ถึงเวลาในช่วง 7 วันนี้',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontBody,
                    fontSize: 14,
                    color: AppTheme.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                // Custom Bar Chart 7 วัน (เขียนเองตาม Requirement ไม่พึ่งแพ็กเกจภายนอก)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: past7Days.map((date) {
                    final isToday =
                        date.day == now.day && date.month == now.month;
                    final dayTotal = plannedByDay[dateKey(date)]?.length ?? 0;
                    final dayTaken = takenByDay[dateKey(date)]?.length ?? 0;

                    final double ratio = dayTotal > 0
                        ? (dayTaken / dayTotal)
                        : 0.0;
                    final double barHeight = (ratio * 60).clamp(4.0, 60.0);

                    return Column(
                      children: [
                        Container(
                          width: 24,
                          height: dayTotal > 0 ? barHeight : 4,
                          decoration: BoxDecoration(
                            color: ratio == 1.0
                                ? AppTheme.statusTaken
                                : AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          DateFormat('E', 'th').format(date),
                          style: TextStyle(
                            fontFamily: AppTheme.fontBody,
                            fontSize: 13,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isToday
                                ? AppTheme.primary
                                : AppTheme.secondary,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // แถบเลือกวัน 7 วันล่าสุดแนวนอน
          const SectionHeader(title: 'เลือกดูตามวัน 📅'),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (ctx, index) {
                final date = now.subtract(Duration(days: 6 - index));
                final isSelected =
                    date.day == _selectedDate.day &&
                    date.month == _selectedDate.month &&
                    date.year == _selectedDate.year;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    width: 56,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.border,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E', 'th').format(date),
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected
                                ? Colors.white70
                                : AppTheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontFamily: AppTheme.fontHeading,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // ประวัติของวันที่เลือก
          SectionHeader(
            title: 'บันทึกของวันที่ ${thaiDateFormat.format(_selectedDate)}',
          ),
          if (dayLogs.isEmpty)
            const EmptyState(
              title: 'ไม่มีบันทึกในวันนี้',
              subtitle: 'ไม่พบรายการทานยา หรือยังไม่มีการบันทึกสถานะ',
              icon: Icons.history_rounded,
            )
          else
            ...dayLogs.map((log) {
              final med = state.medications.firstWhere(
                (m) => m.id == log.medId,
                orElse: () => Medication(
                  id: '',
                  name: 'ยาที่ถูกลบ',
                  quantity: 0,
                  createdAt: DateTime.now(),
                ),
              );

              final timeStr = DateFormat('HH:mm').format(log.scheduledAt);
              final actTimeStr = log.actedAt != null
                  ? DateFormat('HH:mm').format(log.actedAt!)
                  : '';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Row(
                  children: [
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontFamily: AppTheme.fontHeading,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med.name,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontHeading,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (actTimeStr.isNotEmpty)
                            Text(
                              'กดบันทึกเมื่อ: $actTimeStr น.',
                              style: const TextStyle(
                                fontFamily: AppTheme.fontBody,
                                fontSize: 13,
                                color: AppTheme.secondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    StatusChip(status: log.status),
                  ],
                ),
              );
            }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
