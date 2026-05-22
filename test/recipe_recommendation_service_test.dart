import 'package:flutter_test/flutter_test.dart';
import 'package:smart_kitchen_assistant/src/models/ingredient.dart';
import 'package:smart_kitchen_assistant/src/models/recipe.dart';
import 'package:smart_kitchen_assistant/src/models/user_preferences.dart';
import 'package:smart_kitchen_assistant/src/services/recipe_recommendation_service.dart';

void main() {
  test('ranks recipes using available and urgent ingredients', () {
    const service = RecipeRecommendationService();
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

    final recipes = [
      const Recipe(
        title: 'Low Match Recipe',
        description: 'Needs missing items.',
        matchingIngredients: ['Milk', 'Tomatoes'],
        minutes: 10,
      ),
      const Recipe(
        title: 'High Match Recipe',
        description: 'Uses urgent chicken.',
        matchingIngredients: ['Chicken breast', 'Rice'],
        minutes: 20,
      ),
    ];

    final recommendations = service.rankRecipes(
      recipes: recipes,
      inventory: inventory,
    );

    expect(recommendations.first.recipe.title, 'High Match Recipe');
    expect(recommendations.first.canCookNow, isTrue);
    expect(recommendations.first.urgentIngredients, ['Chicken breast']);
  });

  test('uses quick cooking preference when ranking close matches', () {
    const service = RecipeRecommendationService();
    final inventory = [
      Ingredient(
        id: '1',
        name: 'Rice',
        quantity: '1 kg',
        category: IngredientCategory.grain,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
    ];

    final recipes = [
      const Recipe(
        title: 'Slow Rice Meal',
        description: 'Takes longer.',
        matchingIngredients: ['Rice'],
        minutes: 45,
      ),
      const Recipe(
        title: 'Quick Rice Meal',
        description: 'Fast option.',
        matchingIngredients: ['Rice'],
        minutes: 15,
      ),
    ];

    final recommendations = service.rankRecipes(
      recipes: recipes,
      inventory: inventory,
      preferences: UserPreferences.defaults(),
    );

    expect(recommendations.first.recipe.title, 'Quick Rice Meal');
  });
}
