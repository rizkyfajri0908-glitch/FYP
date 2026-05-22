import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_kitchen_assistant/src/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Smart Kitchen app loads the dashboard', (tester) async {
    await tester.pumpWidget(const SmartKitchenApp(isFirebaseReady: false));
    await tester.pumpAndSettle();

    expect(find.text('Smart Kitchen'), findsOneWidget);
    expect(find.text('Today Priority'), findsOneWidget);
    expect(find.text('Items'), findsOneWidget);
  });

  testWidgets('Bottom navigation opens inventory screen', (tester) async {
    await tester.pumpWidget(const SmartKitchenApp(isFirebaseReady: false));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Items'));
    await tester.pumpAndSettle();

    expect(find.text('Kitchen Inventory'), findsOneWidget);
    expect(find.text('Add Ingredient'), findsOneWidget);
    expect(find.text('Urgent'), findsOneWidget);
  });

  testWidgets('Bottom navigation opens profile screen', (tester) async {
    await tester.pumpWidget(const SmartKitchenApp(isFirebaseReady: false));
    await tester.pumpAndSettle();

    if (find.text('Profile').evaluate().isEmpty) {
      await tester.drag(find.byType(NavigationBar), const Offset(-300, 0));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile Preferences'), findsOneWidget);
    expect(find.text('Dietary Preference'), findsOneWidget);
  });
}
