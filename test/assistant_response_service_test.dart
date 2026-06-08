import 'package:flutter_test/flutter_test.dart';
import 'package:smart_kitchen_assistant/src/data/assistant_knowledge_base.dart';
import 'package:smart_kitchen_assistant/src/data/recipe_catalog.dart';
import 'package:smart_kitchen_assistant/src/models/ingredient.dart';
import 'package:smart_kitchen_assistant/src/models/user_preferences.dart';
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
      recipes: RecipeCatalog.recipes,
      knowledgeBase: AssistantKnowledgeBase.entries,
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
      recipes: RecipeCatalog.recipes,
      knowledgeBase: AssistantKnowledgeBase.entries,
      preferences: UserPreferences.defaults(),
    );

    expect(response, anyOf(contains('cook'), contains('Best option')));
  });

  test('answers food waste questions from the knowledge base', () {
    const service = AssistantResponseService();

    final response = service.respond(
      question: 'How can I reduce food waste?',
      inventory: const [],
      recipes: RecipeCatalog.recipes,
      knowledgeBase: AssistantKnowledgeBase.entries,
    );

    expect(response, contains('first-in, first-out'));
  });

  test('answers vague food questions with meal guidance', () {
    const service = AssistantResponseService();

    final response = service.respond(
      question: 'I am hungry but I do not know what to eat',
      inventory: const [],
      recipes: RecipeCatalog.recipes,
      knowledgeBase: AssistantKnowledgeBase.entries,
    );

    expect(response, contains('expires first'));
  });

  test('answers ingredient-specific vague questions', () {
    const service = AssistantResponseService();

    final response = service.respond(
      question: 'What can I make with cabbage?',
      inventory: const [],
      recipes: RecipeCatalog.recipes,
      knowledgeBase: AssistantKnowledgeBase.entries,
    );

    expect(response, contains('Cabbage'));
  });
}
