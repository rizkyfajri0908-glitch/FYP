import 'package:flutter_test/flutter_test.dart';
import 'package:smart_kitchen_assistant/src/models/user_preferences.dart';

void main() {
  test('serializes and restores user preferences', () {
    const preferences = UserPreferences(
      dietaryPreference: DietaryPreference.halal,
      cookingStyle: CookingStyle.healthy,
      householdSize: 4,
      reminderDaysBefore: 2,
      notificationRepeatCount: 3,
      foodGoal: FoodGoal.eatHealthier,
      allergies: ['peanuts'],
      avoidedIngredients: ['mushrooms'],
      cookingSkillLevel: CookingSkillLevel.intermediate,
      cookingTools: [CookingTool.stove, CookingTool.oven],
      preferredMealTypes: [MealType.lunch, MealType.dinner],
      foodHabits: [FoodHabit.oftenHasLeftovers],
      preferredReminderHour: 18,
    );

    final restored = UserPreferences.fromJson(preferences.toJson());

    expect(restored.dietaryPreference, DietaryPreference.halal);
    expect(restored.cookingStyle, CookingStyle.healthy);
    expect(restored.householdSize, 4);
    expect(restored.reminderDaysBefore, 2);
    expect(restored.notificationRepeatCount, 3);
    expect(restored.foodGoal, FoodGoal.eatHealthier);
    expect(restored.allergies, ['peanuts']);
    expect(restored.avoidedIngredients, ['mushrooms']);
    expect(restored.cookingSkillLevel, CookingSkillLevel.intermediate);
    expect(restored.cookingTools, [CookingTool.stove, CookingTool.oven]);
    expect(restored.preferredMealTypes, [MealType.lunch, MealType.dinner]);
    expect(restored.foodHabits, [FoodHabit.oftenHasLeftovers]);
    expect(restored.preferredReminderHour, 18);
  });
}
