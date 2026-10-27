import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../features/logs/models/intake_log.dart';

/// Large accessible primary action button following the shared Figma tokens.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isFullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 8)],
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTheme.fontHeading,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: foregroundColor ?? Colors.white,
          ),
        ),
      ],
    );

    return SizedBox(
      height: AppTheme.minTouchTarget,
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onPressed,
        child: buttonChild,
      ),
    );
  }
}

/// 2. StatusChip: ป้ายสถานะสี สื่อสารด้วยสี + ไอคอน + ข้อความ
class StatusChip extends StatelessWidget {
  final IntakeStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color statusBackground;
    IconData icon;
    String label;

    switch (status) {
      case IntakeStatus.taken:
        color = AppTheme.statusTaken;
        statusBackground = AppTheme.okBackground;
        icon = Icons.check_circle_rounded;
        label = 'ทานแล้ว';
        break;
      case IntakeStatus.skipped:
        color = AppTheme.statusSkipped;
        statusBackground = AppTheme.background;
        icon = Icons.cancel_rounded;
        label = 'ข้าม';
        break;
      case IntakeStatus.missed:
        color = AppTheme.statusMissed;
        statusBackground = AppTheme.dangerBackground;
        icon = Icons.access_time_filled_rounded;
        label = 'พลาด';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusBackground,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTheme.fontBody,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. SectionHeader: หัวข้อจัดหมวดหมู่หน้าจอ
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTheme.fontHeading,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.ink,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// 4. EmptyState: แสดงสถานะเมื่อยังไม่มีข้อมูล
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.medication_rounded,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppTheme.fontHeading,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: AppTheme.fontBody,
                fontSize: 16,
                color: AppTheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                label: buttonLabel!,
                onPressed: onButtonPressed,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
