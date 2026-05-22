import 'package:flutter_test/flutter_test.dart';
import 'package:smart_kitchen_assistant/src/models/user_preferences.dart';

void main() {
  test('serializes and restores user preferences', () {
    const preferences = UserPreferences(
      dietaryPreference: DietaryPreference.halal,
      cookingStyle: CookingStyle.healthy,
      householdSize: 4,
      reminderDaysBefore: 2,
    );

    final restored = UserPreferences.fromJson(preferences.toJson());

    expect(restored.dietaryPreference, DietaryPreference.halal);
    expect(restored.cookingStyle, CookingStyle.healthy);
    expect(restored.householdSize, 4);
    expect(restored.reminderDaysBefore, 2);
  });
}
