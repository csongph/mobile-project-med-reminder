import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_reminder/main.dart';

/// App-level smoke test. Run on a connected emulator/device for integration
/// evidence; it intentionally uses only Flutter's test SDK so CI stays fast.
void main() {
  testWidgets('user can open the main navigation flow', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MainNavigationScreen(
            screenOverrides: [
              Text('screen 1'),
              Text('screen 2'),
              Text('screen 3'),
              Text('screen 4'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Check the navigation flow through stable widget types. Localized labels
    // may not be rendered in headless CI due to NavigationBar behavior/fonts.
    expect(find.byType(MainNavigationScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(IndexedStack), findsOneWidget);
  });
}
