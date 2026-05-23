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

  test('puts recipes with more available ingredients first', () {
    const service = RecipeRecommendationService();
    final inventory = [
      Ingredient(
        id: '1',
        name: 'Rice',
        quantity: '1 kg',
        category: IngredientCategory.grain,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
      Ingredient(
        id: '2',
        name: 'Eggs',
        quantity: '6 pieces',
        category: IngredientCategory.protein,
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      ),
    ];

    final recipes = [
      const Recipe(
        title: 'One Match',
        description: 'Uses one inventory item.',
        matchingIngredients: ['Rice', 'Chicken breast'],
        minutes: 10,
      ),
      const Recipe(
        title: 'Two Matches',
        description: 'Uses two inventory items.',
        matchingIngredients: ['Rice', 'Eggs', 'Spinach'],
        minutes: 30,
      ),
      const Recipe(
        title: 'No Match',
        description: 'Uses no current items.',
        matchingIngredients: ['Milk', 'Tomatoes'],
        minutes: 5,
      ),
    ];

    final recommendations = service.rankRecipes(
      recipes: recipes,
      inventory: inventory,
    );

    expect(recommendations.map((item) => item.recipe.title), [
      'Two Matches',
      'One Match',
      'No Match',
    ]);
  });

  test('filters recipes by dietary preference', () {
    const service = RecipeRecommendationService();
    const recipes = [
      Recipe(
        title: 'Pork Rice',
        description: 'Contains pork.',
        matchingIngredients: ['Pork', 'Rice'],
        minutes: 20,
      ),
      Recipe(
        title: 'Vegetable Rice',
        description: 'Vegetarian rice meal.',
        matchingIngredients: ['Rice', 'Spinach'],
        minutes: 20,
        dietary: 'vegetarian',
      ),
    ];

    final halalRecommendations = service.rankRecipes(
      recipes: recipes,
      inventory: const [],
      preferences: const UserPreferences(
        dietaryPreference: DietaryPreference.halal,
        cookingStyle: CookingStyle.quick,
        householdSize: 1,
        reminderDaysBefore: 3,
        notificationRepeatCount: 2,
      ),
    );

    final vegetarianRecommendations = service.rankRecipes(
      recipes: recipes,
      inventory: const [],
      preferences: const UserPreferences(
        dietaryPreference: DietaryPreference.vegetarian,
        cookingStyle: CookingStyle.quick,
        householdSize: 1,
        reminderDaysBefore: 3,
        notificationRepeatCount: 2,
      ),
    );

    expect(
      halalRecommendations.map((item) => item.recipe.title),
      isNot(contains('Pork Rice')),
    );
    expect(vegetarianRecommendations.single.recipe.title, 'Vegetable Rice');
  });
}
