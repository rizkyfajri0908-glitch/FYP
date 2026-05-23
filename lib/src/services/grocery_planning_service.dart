import '../data/sample_data.dart';
import '../models/grocery_suggestion.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/user_preferences.dart';
import 'recipe_recommendation_service.dart';

class GroceryPlanningService {
  const GroceryPlanningService();

  static const _recipeService = RecipeRecommendationService();

  List<GrocerySuggestion> buildPlan(
    List<Ingredient> inventory, {
    List<Recipe>? recipes,
    UserPreferences? preferences,
    List<GrocerySuggestion> customItems = const [],
  }) {
    final inventoryNames =
        inventory.map((ingredient) => ingredient.name.toLowerCase()).toSet();

    final suggestionsByName = <String, GrocerySuggestion>{};

    for (final suggestion in SampleData.grocerySuggestions) {
      if (!inventoryNames.contains(suggestion.name.toLowerCase()) &&
          _isAllowedItem(suggestion.name, preferences)) {
        suggestionsByName[suggestion.name.toLowerCase()] = _personalizeStaple(
          suggestion,
          preferences,
        );
      }
    }

    final recipeRecommendations = _recipeService.rankRecipes(
      recipes: recipes ?? SampleData.recipes,
      inventory: inventory,
      preferences: preferences,
    );

    for (final recommendation in recipeRecommendations.take(4)) {
      for (final missingItem in recommendation.missingIngredients) {
        final key = missingItem.toLowerCase();
        final existingSuggestion = suggestionsByName[key];

        if (existingSuggestion == null ||
            existingSuggestion.source != GrocerySource.recipe) {
          if (!_isAllowedItem(missingItem, preferences)) {
            continue;
          }

          suggestionsByName[key] = GrocerySuggestion(
            name: missingItem,
            reason: 'Needed for ${recommendation.recipe.title}.',
            priority: GroceryPriority.high,
            quantity: _quantityFor(missingItem, preferences),
            source: GrocerySource.recipe,
            tags: recommendation.recipe.tags,
          );
        }
      }
    }

    for (final ingredient in inventory.where(
      (ingredient) =>
          ingredient.expiryStatus == ExpiryStatus.expired ||
          ingredient.expiryStatus == ExpiryStatus.today,
    )) {
      final key = ingredient.name.toLowerCase();
      suggestionsByName.putIfAbsent(
        key,
        () => GrocerySuggestion(
          name: ingredient.name,
          reason: 'Replacement for ${ingredient.expiryMessage.toLowerCase()}.',
          priority: GroceryPriority.medium,
          quantity: ingredient.quantity,
          source: GrocerySource.expiryReplacement,
          tags: const ['replacement'],
        ),
      );
    }

    for (final customItem in customItems) {
      if (!inventoryNames.contains(customItem.name.toLowerCase())) {
        suggestionsByName[customItem.name.toLowerCase()] = customItem;
      }
    }

    _addProfileStaples(suggestionsByName, inventoryNames, preferences);

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

  GrocerySuggestion _personalizeStaple(
    GrocerySuggestion suggestion,
    UserPreferences? preferences,
  ) {
    if (preferences == null) {
      return suggestion;
    }

    final tags = <String>[...suggestion.tags];
    var priority = suggestion.priority;
    var reason = suggestion.reason;

    if (preferences.householdSize >= 3) {
      reason = '${suggestion.reason} Quantity is adjusted for your household.';
    }
    if (preferences.foodGoal == FoodGoal.saveMoney) {
      tags.add('budget');
      reason = '$reason Useful for budget meal planning.';
    }
    if (preferences.foodGoal == FoodGoal.eatHealthier &&
        _containsAny(suggestion.name, ['Carrots', 'Spinach', 'Tomatoes'])) {
      tags.add('healthy');
      priority = GroceryPriority.medium;
      reason = '$reason Supports healthier meal choices.';
    }
    if (preferences.cookingStyle == CookingStyle.quick) {
      tags.add('quick');
    }
    if (preferences.cookingStyle == CookingStyle.budget) {
      tags.add('budget');
    }
    if (preferences.cookingStyle == CookingStyle.healthy) {
      tags.add('healthy');
    }

    return GrocerySuggestion(
      name: suggestion.name,
      reason: reason,
      priority: priority,
      quantity: _quantityFor(suggestion.name, preferences),
      source: suggestion.source,
      tags: tags.toSet().toList(),
    );
  }

  void _addProfileStaples(
    Map<String, GrocerySuggestion> suggestionsByName,
    Set<String> inventoryNames,
    UserPreferences? preferences,
  ) {
    if (preferences == null) {
      return;
    }

    if (preferences.foodGoal == FoodGoal.eatHealthier) {
      _putProfileItem(
        suggestionsByName,
        inventoryNames,
        preferences,
        const GrocerySuggestion(
          name: 'Spinach',
          reason: 'Optional healthy addition for bowls, omelettes, and soup.',
          priority: GroceryPriority.low,
          quantity: '1 bunch',
          source: GrocerySource.frequent,
          tags: ['healthy'],
        ),
      );
    }

    if (preferences.foodGoal == FoodGoal.cookFaster) {
      _putProfileItem(
        suggestionsByName,
        inventoryNames,
        preferences,
        const GrocerySuggestion(
          name: 'Eggs',
          reason: 'Useful for quick meals like fried rice and omelettes.',
          priority: GroceryPriority.medium,
          quantity: '6 pieces',
          source: GrocerySource.frequent,
          tags: ['quick'],
        ),
      );
    }

    if (preferences.foodGoal == FoodGoal.saveMoney ||
        preferences.cookingStyle == CookingStyle.budget) {
      _putProfileItem(
        suggestionsByName,
        inventoryNames,
        preferences,
        GrocerySuggestion(
          name: 'Lentils',
          reason: 'Budget-friendly protein for soups, bowls, and curries.',
          priority: GroceryPriority.medium,
          quantity: _quantityFor('Lentils', preferences),
          source: GrocerySource.frequent,
          tags: const ['budget'],
        ),
      );
    }

    if (preferences.preferredMealTypes.contains(MealType.breakfast)) {
      _putProfileItem(
        suggestionsByName,
        inventoryNames,
        preferences,
        GrocerySuggestion(
          name: 'Oats',
          reason: 'Breakfast staple that works with fruit, milk, or yogurt.',
          priority: GroceryPriority.low,
          quantity: _quantityFor('Oats', preferences),
          source: GrocerySource.frequent,
          tags: const ['breakfast', 'budget'],
        ),
      );
    }

    if (preferences.preferredMealTypes.contains(MealType.snacks)) {
      _putProfileItem(
        suggestionsByName,
        inventoryNames,
        preferences,
        GrocerySuggestion(
          name: 'Bananas',
          reason: 'Easy snack option and useful for smoothies or oats.',
          priority: GroceryPriority.low,
          quantity: _quantityFor('Bananas', preferences),
          source: GrocerySource.frequent,
          tags: const ['snacks'],
        ),
      );
    }

    if (preferences.foodHabits.contains(FoodHabit.overbuysVegetables)) {
      _putProfileItem(
        suggestionsByName,
        inventoryNames,
        preferences,
        GrocerySuggestion(
          name: 'Frozen mixed vegetables',
          reason: 'Longer-lasting vegetable backup for low-waste meals.',
          priority: GroceryPriority.low,
          quantity: _quantityFor('Frozen mixed vegetables', preferences),
          source: GrocerySource.frequent,
          tags: const ['healthy', 'low waste'],
        ),
      );
    }

    if (preferences.cookingTools.contains(CookingTool.blender)) {
      _putProfileItem(
        suggestionsByName,
        inventoryNames,
        preferences,
        GrocerySuggestion(
          name: 'Yogurt',
          reason: 'Useful for smoothies and quick breakfast bowls.',
          priority: GroceryPriority.low,
          quantity: _quantityFor('Yogurt', preferences),
          source: GrocerySource.frequent,
          tags: const ['quick'],
        ),
      );
    }
  }

  void _putProfileItem(
    Map<String, GrocerySuggestion> suggestionsByName,
    Set<String> inventoryNames,
    UserPreferences preferences,
    GrocerySuggestion suggestion,
  ) {
    final key = suggestion.name.toLowerCase();
    if (!inventoryNames.contains(key) &&
        _isAllowedItem(suggestion.name, preferences)) {
      suggestionsByName.putIfAbsent(key, () => suggestion);
    }
  }

  int _priorityRank(GroceryPriority priority) {
    return switch (priority) {
      GroceryPriority.high => 0,
      GroceryPriority.medium => 1,
      GroceryPriority.low => 2,
    };
  }

  String _quantityFor(String name, [UserPreferences? preferences]) {
    final normalized = name.toLowerCase();
    final multiplier = preferences == null
        ? 1
        : preferences.householdSize <= 2
            ? 1
            : preferences.householdSize <= 4
                ? 2
                : 3;

    if (normalized.contains('egg')) return '${6 * multiplier} pieces';
    if (normalized.contains('rice')) return '${1 * multiplier} kg';
    if (normalized.contains('oat')) return '${500 * multiplier} g';
    if (normalized.contains('milk')) return '$multiplier carton';
    if (normalized.contains('yogurt')) return '$multiplier tub';
    if (normalized.contains('chicken')) return '${2 * multiplier} pieces';
    if (normalized.contains('tomato')) return '${4 * multiplier} pieces';
    if (normalized.contains('carrot')) return '${3 * multiplier} pieces';
    if (normalized.contains('onion')) return '${3 * multiplier} pieces';
    if (normalized.contains('banana')) return '${6 * multiplier} pieces';
    if (normalized.contains('lentil')) return '${500 * multiplier} g';
    if (normalized.contains('frozen mixed vegetables')) {
      return '$multiplier pack';
    }
    if (normalized.contains('spinach') || normalized.contains('lettuce')) {
      return '$multiplier bunch';
    }
    return '1 item';
  }

  bool _isAllowedItem(String item, UserPreferences? preferences) {
    if (preferences == null) {
      return true;
    }

    final normalized = item.toLowerCase();
    final blockedItems = [
      ...preferences.allergies,
      ...preferences.avoidedIngredients,
    ];

    if (_containsAnyText(normalized, blockedItems)) {
      return false;
    }

    return switch (preferences.dietaryPreference) {
      DietaryPreference.none => true,
      DietaryPreference.halal => !_containsAnyText(
          normalized,
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
      DietaryPreference.vegetarian => !_containsAnyText(
          normalized,
          ['chicken', 'beef', 'pork', 'fish', 'tuna', 'shrimp', 'prawn'],
        ),
      DietaryPreference.dairyFree => !_containsAnyText(
          normalized,
          ['milk', 'cheese', 'butter', 'cream', 'yogurt', 'yoghurt'],
        ),
    };
  }

  bool _containsAny(String source, List<String> targets) {
    final normalized = source.toLowerCase();
    return targets.any((target) => normalized.contains(target.toLowerCase()));
  }

  bool _containsAnyText(String source, List<String> targets) {
    return targets.any((target) {
      final normalizedTarget = target.trim().toLowerCase();
      return normalizedTarget.isNotEmpty && source.contains(normalizedTarget);
    });
  }
}
