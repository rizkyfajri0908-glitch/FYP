import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/user_preferences.dart';

class RecipeRecommendation {
  const RecipeRecommendation({
    required this.recipe,
    required this.matchedIngredients,
    required this.missingIngredients,
    required this.urgentIngredients,
    required this.score,
  });

  final Recipe recipe;
  final List<String> matchedIngredients;
  final List<String> missingIngredients;
  final List<String> urgentIngredients;
  final int score;

  int get totalIngredients => recipe.matchingIngredients.length;

  bool get canCookNow => missingIngredients.isEmpty;
}

class RecipeRecommendationService {
  const RecipeRecommendationService();

  List<RecipeRecommendation> rankRecipes({
    required List<Recipe> recipes,
    required List<Ingredient> inventory,
    UserPreferences? preferences,
  }) {
    final ingredientLookup = {
      for (final ingredient in inventory)
        ingredient.name.toLowerCase(): ingredient,
    };

    final recommendations = recipes.map((recipe) {
      final matched = <String>[];
      final missing = <String>[];
      final urgent = <String>[];

      for (final ingredientName in recipe.matchingIngredients) {
        final ingredient = ingredientLookup[ingredientName.toLowerCase()];

        if (ingredient == null) {
          missing.add(ingredientName);
          continue;
        }

        matched.add(ingredientName);

        if (ingredient.expiryStatus == ExpiryStatus.today ||
            ingredient.expiryStatus == ExpiryStatus.soon) {
          urgent.add(ingredientName);
        }
      }

      final ingredientScore = matched.length * 20;
      final urgencyScore = urgent.length * 12;
      final missingPenalty = missing.length * 8;
      final timePenalty = recipe.minutes.clamp(0, 60) ~/ 10;
      final preferenceScore = _preferenceScore(recipe, preferences);
      final score = ingredientScore +
          urgencyScore +
          preferenceScore -
          missingPenalty -
          timePenalty;

      return RecipeRecommendation(
        recipe: recipe,
        matchedIngredients: matched,
        missingIngredients: missing,
        urgentIngredients: urgent,
        score: score,
      );
    }).toList();

    recommendations.sort((a, b) => b.score.compareTo(a.score));
    return recommendations;
  }

  int _preferenceScore(Recipe recipe, UserPreferences? preferences) {
    if (preferences == null) {
      return 0;
    }

    return switch (preferences.cookingStyle) {
      CookingStyle.quick => recipe.minutes <= 20 ? 8 : 0,
      CookingStyle.budget => recipe.matchingIngredients.length <= 2 ? 6 : 0,
      CookingStyle.healthy => _containsAny(
          recipe.matchingIngredients,
          ['Spinach', 'Tomatoes', 'Carrots'],
        )
            ? 6
            : 0,
    };
  }

  bool _containsAny(List<String> ingredients, List<String> targets) {
    final normalizedIngredients =
        ingredients.map((ingredient) => ingredient.toLowerCase()).toSet();
    return targets.any(
      (target) => normalizedIngredients.contains(target.toLowerCase()),
    );
  }
}
