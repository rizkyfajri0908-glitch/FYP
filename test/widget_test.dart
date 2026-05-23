import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_kitchen_assistant/src/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('EcoBite app loads the dashboard', (tester) async {
    await tester.pumpWidget(const SmartKitchenApp(isFirebaseReady: false));
    await _pumpUntilFound(tester, find.text('Home'));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Items'), findsOneWidget);
  });

  testWidgets('Bottom navigation opens inventory screen', (tester) async {
    await tester.pumpWidget(const SmartKitchenApp(isFirebaseReady: false));
    await _pumpUntilFound(tester, find.text('Items'));

    await tester.tap(find.text('Items'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Kitchen Inventory'), findsOneWidget);
    expect(find.text('Add Ingredient'), findsOneWidget);
    expect(find.text('Urgent'), findsOneWidget);
  });

  testWidgets('Bottom navigation opens profile screen', (tester) async {
    await tester.pumpWidget(const SmartKitchenApp(isFirebaseReady: false));
    await _pumpUntilFound(tester, find.text('Profile'));

    if (find.text('Profile').evaluate().isEmpty) {
      await tester.drag(find.byType(NavigationBar), const Offset(-300, 0));
      await tester.pump(const Duration(milliseconds: 500));
    }

    await tester.tap(find.text('Profile'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Profile Preferences'), findsOneWidget);
    expect(find.text('Food Profile'), findsOneWidget);
    expect(find.text('Cooking Preferences'), findsOneWidget);
    expect(find.text('Reminder Settings'), findsOneWidget);
  });
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int attempts = 30,
}) async {
  for (var index = 0; index < attempts; index += 1) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
}
