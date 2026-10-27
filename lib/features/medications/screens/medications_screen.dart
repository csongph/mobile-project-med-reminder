import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/med_card.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/state/app_state.dart';
import 'add_edit_medication_screen.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final medications = state.medications;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('รายการยาทั้งหมด 💊')),
      body: medications.isEmpty
          ? EmptyState(
              title: 'ยังไม่มีรายการยา',
              subtitle: 'กดปุ่มเพิ่มยาด้านล่างเพื่อเริ่มบันทึกรายการยาของคุณ',
              buttonLabel: 'เพิ่มยาใหม่',
              onButtonPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddEditMedicationScreen(),
                  ),
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final med = medications[index];
                return Dismissible(
                  key: Key(med.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.statusMissed,
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'ลบรายการยา',
                          style: TextStyle(
                            fontFamily: AppTheme.fontHeading,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.cardRadius,
                          ),
                        ),
                        title: const Text(
                          'ยืนยันการลบยา',
                          style: TextStyle(fontFamily: AppTheme.fontHeading),
                        ),
                        content: Text(
                          'คุณต้องการลบ "${med.name}" ออกจากระบบหรือไม่? ตารางแจ้งเตือนทั้งหมดของยานี้จะถูกยกเลิกด้วย',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text(
                              'ยกเลิก',
                              style: TextStyle(color: AppTheme.secondary),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.statusMissed,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('ลบยา'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) async {
                    try {
                      await ref
                          .read(appStateProvider.notifier)
                          .deleteMedication(med.id);
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ลบไม่สำเร็จ กรุณาลองอีกครั้ง'),
                        ),
                      );
                      return;
                    }
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ลบ ${med.name} สำเร็จ'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: MedCard(
                    medication: med,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              AddEditMedicationScreen(existingMedication: med),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: medications.isEmpty
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.pillRadius),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'เพิ่มยา',
                style: TextStyle(
                  fontFamily: AppTheme.fontHeading,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddEditMedicationScreen(),
                  ),
                );
              },
            ),
    );
  }
}
