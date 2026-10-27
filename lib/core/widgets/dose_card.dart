import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../features/logs/models/intake_log.dart';
import 'common_widgets.dart';

/// การ์ดแสดงรอบทานยาแต่ละมื้อ (ใช้ในหน้า "วันนี้")
class DoseCard extends StatelessWidget {
  final String timeText;
  final String medName;
  final int dose;
  final String? imageUrl;
  final bool isNextDose;
  final IntakeStatus? status;
  final VoidCallback? onTake;
  final VoidCallback? onSkip;

  const DoseCard({
    super.key,
    required this.timeText,
    required this.medName,
    required this.dose,
    this.imageUrl,
    this.isNextDose = false,
    this.status,
    this.onTake,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status != null;

    return Semantics(
      label:
          'มื้อเวลา $timeText ยา $medName ขนาด $dose เม็ด ${status != null ? "สถานะ: ${status!.name}" : ""}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: isNextDose ? AppTheme.softShadow : [],
          border: Border.all(
            color: isNextDose ? AppTheme.primary : AppTheme.border,
            width: isNextDose ? 2 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // เวลาตัวใหญ่
                Text(
                  timeText,
                  style: TextStyle(
                    fontFamily: AppTheme.fontHeading,
                    fontSize: isNextDose ? 26 : 22,
                    height: 34 / 26,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? AppTheme.secondary : AppTheme.primary,
                  ),
                ),
                const Spacer(),
                if (isNextDose && status == null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                    ),
                    child: const Text(
                      'มื้อถัดไป',
                      style: TextStyle(
                        fontFamily: AppTheme.fontBody,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                if (status != null) StatusChip(status: status!),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // รูปยา
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(imageUrl!, fit: BoxFit.cover),
                        )
                      : const Icon(
                          Icons.medication_rounded,
                          color: AppTheme.primary,
                          size: 28,
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medName,
                        style: TextStyle(
                          fontFamily: AppTheme.fontHeading,
                          fontSize: 20,
                          height: 28 / 20,
                          fontWeight: FontWeight.w500,
                          color: isCompleted
                              ? AppTheme.secondary
                              : AppTheme.ink,
                        ),
                      ),
                      Text(
                        'รับประทาน $dose เม็ด',
                        style: const TextStyle(
                          fontFamily: AppTheme.fontBody,
                          fontSize: 18,
                          height: 28 / 18,
                          color: AppTheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status == null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.statusSkipped,
                          side: const BorderSide(color: AppTheme.secondary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.pillRadius,
                            ),
                          ),
                        ),
                        onPressed: onSkip,
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: const Text(
                          'ข้าม',
                          style: TextStyle(
                            fontFamily: AppTheme.fontBody,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.statusTaken,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.pillRadius,
                            ),
                          ),
                        ),
                        onPressed: onTake,
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: const Text(
                          'ทานแล้ว',
                          style: TextStyle(
                            fontFamily: AppTheme.fontBody,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
