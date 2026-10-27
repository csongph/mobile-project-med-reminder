import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _setReminders(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final notifier = ref.read(appStateProvider.notifier);
    if (value) {
      final bool granted;
      try {
        granted = await NotificationService().requestPermissions(
          requestFullScreenIntent: true,
        );
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ตรวจสอบสิทธิ์แจ้งเตือนไม่สำเร็จ ลองอีกครั้ง'),
          ),
        );
        return;
      }
      if (!granted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('กรุณาอนุญาตการแจ้งเตือนในการตั้งค่าอุปกรณ์'),
          ),
        );
        return;
      }
    }
    try {
      await notifier.setRemindersEnabled(value);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกการตั้งค่าไม่สำเร็จ กรุณาลองอีกครั้ง'),
        ),
      );
    }
  }

  Future<void> _setLowStockAlerts(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    try {
      await ref.read(appStateProvider.notifier).setLowStockAlertsEnabled(value);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกการตั้งค่าไม่สำเร็จ กรุณาลองอีกครั้ง'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final medicineCount = app.medications.length;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('ตั้งค่า')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _DeviceCard(medicineCount: medicineCount),
          const SizedBox(height: 24),
          const _SectionTitle('การแจ้งเตือน'),
          _SettingsCard(
            children: [
              SwitchListTile.adaptive(
                value: app.remindersEnabled,
                onChanged: (value) => _setReminders(context, ref, value),
                secondary: const _LeadingIcon(
                  Icons.notifications_active_outlined,
                ),
                title: const Text('เตือนเวลาทานยา'),
                subtitle: const Text('ใช้เวลาที่กำหนดในตารางยา'),
                activeTrackColor: AppTheme.primary,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: FutureBuilder<NotificationStatus>(
                  future: NotificationService().getStatus(),
                  builder: (context, snapshot) {
                    final status = snapshot.data;
                    final String label;
                    final IconData icon;
                    final Color color;
                    if (!app.remindersEnabled) {
                      label = 'ระบบเตือนยาปิดอยู่';
                      icon = Icons.notifications_off_outlined;
                      color = AppTheme.secondary;
                    } else if (snapshot.hasError) {
                      label = 'อ่านสถานะระบบแจ้งเตือนไม่ได้';
                      icon = Icons.error_outline_rounded;
                      color = AppTheme.statusMissed;
                    } else if (status == null) {
                      label = 'กำลังตรวจสอบสถานะการแจ้งเตือน…';
                      icon = Icons.hourglass_empty_rounded;
                      color = AppTheme.secondary;
                    } else if (!status.notificationsAllowed) {
                      label = 'Android ยังไม่อนุญาตให้แสดงการแจ้งเตือน';
                      icon = Icons.warning_amber_rounded;
                      color = AppTheme.statusLowStock;
                    } else if (!status.fullScreenAllowed) {
                      label =
                          'อนุญาตการปลุกเต็มหน้าจอใน Android เพื่อให้แสดงเหมือนนาฬิกาปลุก';
                      icon = Icons.open_in_full_rounded;
                      color = AppTheme.statusLowStock;
                    } else if (status.pendingCount == 0) {
                      label = 'ยังไม่มีเวลาทานยาที่ตั้งเตือนไว้';
                      icon = Icons.schedule_outlined;
                      color = AppTheme.statusLowStock;
                    } else {
                      label = 'ตั้งการแจ้งเตือนไว้ ${status.pendingCount} รอบ';
                      icon = Icons.check_circle_outline_rounded;
                      color = AppTheme.statusTaken;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(icon, size: 18, color: color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(color: color, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        if (app.remindersEnabled &&
                            status?.notificationsAllowed == true &&
                            status?.fullScreenAllowed == false)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () =>
                                  _setReminders(context, ref, true),
                              child: const Text('อนุญาตการปลุกเต็มหน้าจอ'),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(height: 1, indent: 64),
              SwitchListTile.adaptive(
                value: app.lowStockAlertsEnabled,
                onChanged: (value) => _setLowStockAlerts(context, ref, value),
                secondary: const _LeadingIcon(Icons.inventory_2_outlined),
                title: const Text('เตือนยาใกล้หมด'),
                subtitle: const Text('แสดงสถานะเมื่อยาเหลือต่ำกว่าเกณฑ์'),
                activeTrackColor: AppTheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _sendTestNotification(context),
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('ส่งการแจ้งเตือนทดสอบ'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primary,
              side: const BorderSide(color: AppTheme.primary),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('ข้อมูลและความเป็นส่วนตัว'),
          _SettingsCard(
            children: [
              ListTile(
                leading: const _LeadingIcon(Icons.lock_outline_rounded),
                title: const Text('จัดเก็บข้อมูลในอุปกรณ์นี้'),
                subtitle: const Text('ยา ตารางเวลา และประวัติของคุณ'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () =>
                    _showStorageInfo(context, medicineCount, app.logs.length),
              ),
              const Divider(height: 1, indent: 64),
              ListTile(
                leading: const _LeadingIcon(Icons.info_outline_rounded),
                title: const Text('เกี่ยวกับ Med Reminder'),
                subtitle: const Text('เวอร์ชัน 1.0.0'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Med Reminder',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'แอปช่วยจัดการตารางยาและประวัติการรับประทานยา',
                ),
              ),
              if (Firebase.apps.isNotEmpty) ...[
                const Divider(height: 1, indent: 64),
                ListTile(
                  leading: const _LeadingIcon(Icons.logout_rounded),
                  title: const Text('ออกจากระบบ'),
                  subtitle: const Text('ออกจากบัญชีผู้ใช้'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _signOut(context),
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: () => _confirmClearData(context, ref),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('ลบข้อมูลทั้งหมดในอุปกรณ์'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.statusMissed,
              side: const BorderSide(color: AppTheme.statusMissed),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendTestNotification(BuildContext context) async {
    final service = NotificationService();
    final bool granted;
    try {
      granted = await service.requestPermissions();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ระบบแจ้งเตือนทำงานผิดพลาด ลองปิดแล้วเปิดแอปใหม่'),
        ),
      );
      return;
    }
    if (!context.mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'เปิดสิทธิ์การแจ้งเตือนให้ Med Reminder ในการตั้งค่า Android ก่อน',
          ),
        ),
      );
      return;
    }
    try {
      await service.showInstantNotification(
        id: 2147483000,
        title: 'ทดสอบการแจ้งเตือน',
        body: 'ระบบแจ้งเตือนของ Med Reminder ใช้งานได้',
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งการแจ้งเตือนไม่สำเร็จ ตรวจสิทธิ์และลองใหม่'),
        ),
      );
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งการแจ้งเตือนทดสอบแล้ว ตรวจแถบแจ้งเตือนของมือถือ'),
        ),
      );
    }
  }

  static void _showStorageInfo(BuildContext context, int medicines, int logs) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ข้อมูลในอุปกรณ์นี้',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'รายการยา $medicines รายการ · ประวัติการรับประทาน $logs รายการ',
              ),
              const SizedBox(height: 8),
              const Text(
                'ข้อมูลบันทึกไว้ในแอปบนอุปกรณ์นี้ และยังไม่มีการซิงก์ข้ามอุปกรณ์',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _confirmClearData(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลบข้อมูลทั้งหมดหรือไม่'),
        content: const Text(
          'รายการยา ตารางเวลา และประวัติในอุปกรณ์นี้จะถูกลบถาวร',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.statusMissed,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบข้อมูล'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(appStateProvider.notifier).clearAllData();
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลบข้อมูลไม่สำเร็จ กรุณาลองอีกครั้ง')),
        );
      }
    }
  }

  static Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await AuthService().signOut();
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ออกจากระบบไม่สำเร็จ: $e')));
      }
    }
  }
}

class _DeviceCard extends StatelessWidget {
  final int medicineCount;
  const _DeviceCard({required this.medicineCount});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      border: Border.all(color: AppTheme.border),
      boxShadow: AppTheme.softShadow,
    ),
    child: Row(
      children: [
        const _LeadingIcon(Icons.medication_rounded, large: true),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Med Reminder',
                style: TextStyle(
                  fontFamily: AppTheme.fontHeading,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'จัดการยา $medicineCount รายการ · บันทึกในอุปกรณ์นี้',
                style: const TextStyle(color: AppTheme.secondary, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      title,
      style: const TextStyle(
        fontFamily: AppTheme.fontHeading,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppTheme.ink,
      ),
    ),
  );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      border: Border.all(color: AppTheme.border),
    ),
    child: Column(children: children),
  );
}

class _LeadingIcon extends StatelessWidget {
  final IconData icon;
  final bool large;
  const _LeadingIcon(this.icon, {this.large = false});
  @override
  Widget build(BuildContext context) => Container(
    width: large ? 48 : 40,
    height: large ? 48 : 40,
    decoration: BoxDecoration(
      color: AppTheme.primaryContainer,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Icon(icon, color: AppTheme.primary, size: large ? 25 : 21),
  );
}
