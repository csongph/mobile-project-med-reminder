import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_reminder/main.dart';

/// App-level smoke test. Run on a connected emulator/device for integration
/// evidence; it intentionally uses only Flutter's test SDK so CI stays fast.
void main() {
  testWidgets('user can open the main navigation flow', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MedReminderApp()));
    await tester.pumpAndSettle();

    expect(find.text('หน้าหลัก'), findsOneWidget);
    expect(find.text('ยาของฉัน'), findsOneWidget);
    expect(find.text('ประวัติ'), findsOneWidget);
    expect(find.text('ตั้งค่า'), findsOneWidget);
  });
}
