import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../features/medications/models/medication.dart';

/// การ์ดแสดงข้อมูลยาในหน้ารายการยา พร้อม progress bar แจ้งระดับยาคงเหลือ
class MedCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onTap;

  const MedCard({super.key, required this.medication, this.onTap});

  @override
  Widget build(BuildContext context) {
    // กำหนดสีและอัตราส่วนจำนวนยาคงเหลือ
    final isLow = medication.isLowStock;
    final stockColor = isLow ? AppTheme.statusLowStock : AppTheme.statusTaken;

    return Semantics(
      label: 'ยา ${medication.name} เหลือ ${medication.quantity} เม็ด',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: isLow ? AppTheme.statusLowStock : AppTheme.border,
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // รูปยา หรือไอคอนเริ่มต้น
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child:
                      medication.imageUrl != null &&
                          medication.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            medication.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.medication_rounded,
                              color: AppTheme.primary,
                              size: 32,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.medication_rounded,
                          color: AppTheme.primary,
                          size: 32,
                        ),
                ),
                const SizedBox(width: 14),
                // รายละเอียด
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontHeading,
                          fontSize: 20,
                          height: 28 / 20,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.ink,
                        ),
                      ),
                      if (medication.notes.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          medication.notes,
                          style: const TextStyle(
                            fontFamily: AppTheme.fontBody,
                            fontSize: 18,
                            height: 28 / 18,
                            color: AppTheme.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      // แถบแสดงจำนวนยาคงเหลือ
                      Row(
                        children: [
                          Icon(
                            isLow
                                ? Icons.warning_amber_rounded
                                : Icons.inventory_2_outlined,
                            size: 16,
                            color: stockColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'เหลือ ${medication.quantity} เม็ด${isLow ? ' • ยาใกล้หมด' : ''}',
                            style: TextStyle(
                              fontFamily: AppTheme.fontBody,
                              fontSize: 16,
                              height: 24 / 16,
                              fontWeight: isLow
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: stockColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.secondary,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
