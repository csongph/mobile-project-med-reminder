import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:med_reminder/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('th');
  });

  testWidgets('App renders correctly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MedReminderApp()));
    await tester.pumpAndSettle();
    expect(find.text('หน้าหลัก'), findsOneWidget);
    expect(find.text('ยาของฉัน'), findsOneWidget);
    expect(find.text('ประวัติ'), findsOneWidget);
    expect(find.text('ตั้งค่า'), findsOneWidget);
  });
}
