import 'package:flutter_test/flutter_test.dart';
import 'package:smart_kitchen_assistant/src/models/grocery_suggestion.dart';
import 'package:smart_kitchen_assistant/src/models/ingredient.dart';
import 'package:smart_kitchen_assistant/src/services/grocery_planning_service.dart';

void main() {
  test('adds missing recipe ingredients to grocery plan', () {
    const service = GroceryPlanningService();
    final inventory = [
      Ingredient(
        id: '1',
        name: 'Rice',
        quantity: '1 kg',
        category: IngredientCategory.grain,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
    ];

    final plan = service.buildPlan(inventory);

    expect(
      plan.where((item) => item.source == GrocerySource.recipe),
      isNotEmpty,
    );
  });

  test('does not suggest staple items already in inventory', () {
    const service = GroceryPlanningService();
    final inventory = [
      Ingredient(
        id: '1',
        name: 'Eggs',
        quantity: '6 pieces',
        category: IngredientCategory.protein,
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      ),
    ];

    final plan = service.buildPlan(inventory);

    expect(plan.map((item) => item.name), isNot(contains('Eggs')));
  });
}
