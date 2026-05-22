import 'package:flutter_test/flutter_test.dart';
import 'package:smart_kitchen_assistant/src/models/ingredient.dart';
import 'package:smart_kitchen_assistant/src/services/assistant_response_service.dart';

void main() {
  test('answers expiry questions from inventory', () {
    const service = AssistantResponseService();
    final inventory = [
      Ingredient(
        id: '1',
        name: 'Spinach',
        quantity: '1 bunch',
        category: IngredientCategory.vegetable,
        expiryDate: DateTime.now().add(const Duration(days: 1)),
      ),
    ];

    final response = service.respond(
      question: 'What expires soon?',
      inventory: inventory,
    );

    expect(response, contains('Spinach'));
  });

  test('answers recipe questions with a recommendation', () {
    const service = AssistantResponseService();
    final inventory = [
      Ingredient(
        id: '1',
        name: 'Chicken breast',
        quantity: '2 pieces',
        category: IngredientCategory.protein,
        expiryDate: DateTime.now().add(const Duration(days: 1)),
      ),
      Ingredient(
        id: '2',
        name: 'Rice',
        quantity: '1 kg',
        category: IngredientCategory.grain,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
    ];

    final response = service.respond(
      question: 'What can I cook?',
      inventory: inventory,
    );

    expect(response, contains('cook'));
  });
}
