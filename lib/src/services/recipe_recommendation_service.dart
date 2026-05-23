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

    final recommendations = recipes
        .where((recipe) => _matchesDietaryPreference(recipe, preferences))
        .map((recipe) {
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
      final personalizationScore = _personalizationScore(recipe, preferences);
      final score = ingredientScore +
          urgencyScore +
          preferenceScore -
          missingPenalty +
          personalizationScore -
          timePenalty;

      return RecipeRecommendation(
        recipe: recipe,
        matchedIngredients: matched,
        missingIngredients: missing,
        urgentIngredients: urgent,
        score: score,
      );
    }).toList();

    recommendations.sort((a, b) {
      final matchCompare =
          b.matchedIngredients.length.compareTo(a.matchedIngredients.length);
      if (matchCompare != 0) {
        return matchCompare;
      }

      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) {
        return scoreCompare;
      }

      return a.recipe.title.compareTo(b.recipe.title);
    });
    return recommendations;
  }

  bool _matchesDietaryPreference(
    Recipe recipe,
    UserPreferences? preferences,
  ) {
    if (preferences == null) {
      return true;
    }

    final recipeDietary = recipe.dietary.toLowerCase();
    final searchableText = _recipeSearchText(recipe);

    if (_containsBlockedIngredient(
      searchableText,
      preferences.allergies,
    )) {
      return false;
    }

    if (_containsBlockedIngredient(
      searchableText,
      preferences.avoidedIngredients,
    )) {
      return false;
    }

    return switch (preferences.dietaryPreference) {
      DietaryPreference.none => true,
      DietaryPreference.halal => !_containsAnyText(
          searchableText,
          [
            'pork',
            'bacon',
            'ham',
            'gelatin',
            'gelatine',
            'wine',
            'beer',
            'alcohol',
          ],
        ),
      DietaryPreference.vegetarian =>
        recipeDietary == 'vegetarian' || recipe.tags.contains('vegetarian'),
      DietaryPreference.dairyFree => !_containsAnyText(
          searchableText,
          ['milk', 'cheese', 'butter', 'cream', 'yogurt', 'yoghurt'],
        ),
    };
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

  int _personalizationScore(Recipe recipe, UserPreferences? preferences) {
    if (preferences == null) {
      return 0;
    }

    final searchableText = _recipeSearchText(recipe);
    var score = 0;

    score += switch (preferences.foodGoal) {
      FoodGoal.reduceWaste => recipe.matchingIngredients.length >= 3 ? 6 : 0,
      FoodGoal.saveMoney => recipe.tags.contains('budget') ? 12 : 0,
      FoodGoal.eatHealthier => recipe.tags.contains('healthy') ? 12 : 0,
      FoodGoal.cookFaster => recipe.tags.contains('quick') ? 12 : 0,
    };

    score += switch (preferences.cookingSkillLevel) {
      CookingSkillLevel.beginner => recipe.minutes <= 20 ? 8 : -4,
      CookingSkillLevel.intermediate => recipe.minutes <= 35 ? 4 : 0,
      CookingSkillLevel.confident => recipe.minutes >= 25 ? 3 : 0,
    };

    if (preferences.preferredMealTypes.any(
      (mealType) => _recipeMatchesMealType(recipe, mealType),
    )) {
      score += 8;
    }

    final requiredTools = _requiredToolsForRecipe(searchableText);
    if (requiredTools.every(preferences.cookingTools.contains)) {
      score += 8;
    } else {
      score -= 16;
    }

    if (preferences.foodHabits.contains(FoodHabit.oftenHasLeftovers) &&
        _containsAnyText(searchableText, ['rice', 'pasta', 'soup', 'wrap'])) {
      score += 5;
    }
    if (preferences.foodHabits.contains(FoodHabit.overbuysVegetables) &&
        _containsAnyText(searchableText, [
          'vegetable',
          'spinach',
          'tomato',
          'carrot',
          'lettuce',
          'cucumber',
          'potato',
        ])) {
      score += 5;
    }

    return score;
  }

  bool _recipeMatchesMealType(Recipe recipe, MealType mealType) {
    final text = _recipeSearchText(recipe);
    return switch (mealType) {
      MealType.breakfast => _containsAnyText(
          text,
          ['breakfast', 'oats', 'pancake', 'toast', 'omelette', 'scrambled'],
        ),
      MealType.lunch => _containsAnyText(
          text,
          ['sandwich', 'wrap', 'salad', 'bowl', 'rice', 'pasta'],
        ),
      MealType.dinner => _containsAnyText(
          text,
          ['curry', 'soup', 'stew', 'bake', 'pasta', 'rice', 'noodles'],
        ),
      MealType.snacks => _containsAnyText(
          text,
          ['smoothie', 'toast', 'yogurt', 'fruit', 'snack'],
        ),
    };
  }

  List<CookingTool> _requiredToolsForRecipe(String searchableText) {
    if (_containsAnyText(searchableText, ['bake', 'baked'])) {
      return const [CookingTool.oven];
    }
    if (_containsAnyText(searchableText, ['smoothie', 'blend'])) {
      return const [CookingTool.blender];
    }
    if (_containsAnyText(searchableText, ['toast'])) {
      return const [CookingTool.stove];
    }
    return const [CookingTool.stove];
  }

  bool _containsAny(List<String> ingredients, List<String> targets) {
    final normalizedIngredients =
        ingredients.map((ingredient) => ingredient.toLowerCase()).toSet();
    return targets.any(
      (target) => normalizedIngredients.contains(target.toLowerCase()),
    );
  }

  bool _containsAnyText(String source, List<String> targets) {
    return targets.any(source.contains);
  }

  bool _containsBlockedIngredient(
      String recipeText, List<String> blockedItems) {
    return blockedItems.any((item) {
      final normalizedItem = item.trim().toLowerCase();
      return normalizedItem.isNotEmpty && recipeText.contains(normalizedItem);
    });
  }

  String _recipeSearchText(Recipe recipe) {
    return [
      recipe.title,
      recipe.description,
      recipe.category,
      recipe.dietary,
      ...recipe.matchingIngredients,
      ...recipe.tags,
    ].join(' ').toLowerCase();
  }
}
