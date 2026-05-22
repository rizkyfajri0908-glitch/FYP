import '../data/sample_data.dart';
import '../models/grocery_suggestion.dart';
import '../models/ingredient.dart';
import 'recipe_recommendation_service.dart';

class GroceryPlanningService {
  const GroceryPlanningService();

  static const _recipeService = RecipeRecommendationService();

  List<GrocerySuggestion> buildPlan(List<Ingredient> inventory) {
    final inventoryNames = inventory
        .map((ingredient) => ingredient.name.toLowerCase())
        .toSet();

    final suggestionsByName = <String, GrocerySuggestion>{};

    for (final suggestion in SampleData.grocerySuggestions) {
      if (!inventoryNames.contains(suggestion.name.toLowerCase())) {
        suggestionsByName[suggestion.name.toLowerCase()] = suggestion;
      }
    }

    final recipeRecommendations = _recipeService.rankRecipes(
      recipes: SampleData.recipes,
      inventory: inventory,
    );

    for (final recommendation in recipeRecommendations.take(2)) {
      for (final missingItem in recommendation.missingIngredients) {
        final key = missingItem.toLowerCase();
        suggestionsByName.putIfAbsent(
          key,
          () => GrocerySuggestion(
            name: missingItem,
            reason: 'Needed for ${recommendation.recipe.title}.',
            priority: GroceryPriority.high,
            source: GrocerySource.recipe,
          ),
        );
      }
    }

    final suggestions = suggestionsByName.values.toList();
    suggestions.sort((a, b) {
      final priorityCompare =
          _priorityRank(a.priority).compareTo(_priorityRank(b.priority));
      if (priorityCompare != 0) {
        return priorityCompare;
      }
      return a.name.compareTo(b.name);
    });

    return suggestions;
  }

  int _priorityRank(GroceryPriority priority) {
    return switch (priority) {
      GroceryPriority.high => 0,
      GroceryPriority.medium => 1,
      GroceryPriority.low => 2,
    };
  }
}
