import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:med_reminder/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('th');
  });

  testWidgets('App renders correctly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: MainNavigationScreen()),
      ),
    );
    await tester.pumpAndSettle();
    // Verify the app shell rather than localized label rendering.  Labels can
    // be hidden by Material's NavigationBar label behavior and vary by the
    // font available on the CI runner.
    expect(find.byType(MainNavigationScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(IndexedStack), findsOneWidget);
  });
}
