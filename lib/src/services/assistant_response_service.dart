import '../data/sample_data.dart';
import '../models/ingredient.dart';
import 'recipe_recommendation_service.dart';

class AssistantResponseService {
  const AssistantResponseService();

  static const _recipeService = RecipeRecommendationService();

  String respond({
    required String question,
    required List<Ingredient> inventory,
  }) {
    final normalizedQuestion = question.toLowerCase();

    if (_containsAny(normalizedQuestion, ['expire', 'expiry', 'expiring'])) {
      return _expiryResponse(inventory);
    }

    if (_containsAny(normalizedQuestion, ['cook', 'recipe', 'meal', 'make'])) {
      return _recipeResponse(inventory);
    }

    if (_containsAny(
      normalizedQuestion,
      ['grocery', 'buy', 'shop', 'missing'],
    )) {
      return _groceryResponse(inventory);
    }

    if (_containsAny(normalizedQuestion, ['inventory', 'kitchen', 'have'])) {
      return _inventoryResponse(inventory);
    }

    return 'I can help with expiry checks, recipe ideas, grocery planning, '
        'and your kitchen inventory. Try asking: "What can I cook today?"';
  }

  bool _containsAny(String question, List<String> keywords) {
    return keywords.any(question.contains);
  }

  String _expiryResponse(List<Ingredient> inventory) {
    final urgentItems = inventory
        .where(
          (ingredient) =>
              ingredient.expiryStatus == ExpiryStatus.expired ||
              ingredient.expiryStatus == ExpiryStatus.today ||
              ingredient.expiryStatus == ExpiryStatus.soon,
        )
        .toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    if (urgentItems.isEmpty) {
      return 'No urgent expiry reminders right now. Your listed ingredients are still fresh.';
    }

    final topItems = urgentItems
        .take(3)
        .map((ingredient) => '${ingredient.name} (${ingredient.expiryMessage})')
        .join(', ');

    return 'Use these first: $topItems.';
  }

  String _recipeResponse(List<Ingredient> inventory) {
    final recommendations = _recipeService.rankRecipes(
      recipes: SampleData.recipes,
      inventory: inventory,
    );

    if (recommendations.isEmpty) {
      return 'I do not have recipe suggestions yet. Add more recipes to the '
          'sample data first.';
    }

    final best = recommendations.first;

    if (best.canCookNow) {
      return 'You can cook ${best.recipe.title}. It uses '
          '${best.matchedIngredients.join(', ')} and takes about '
          '${best.recipe.minutes} minutes.';
    }

    return 'Best option: ${best.recipe.title}. You have '
        '${best.matchedIngredients.join(', ')}. Missing: '
        '${best.missingIngredients.join(', ')}.';
  }

  String _groceryResponse(List<Ingredient> inventory) {
    final inventoryNames = inventory
        .map((ingredient) => ingredient.name.toLowerCase())
        .toSet();
    final missingSuggestions = SampleData.grocerySuggestions
        .where((item) => !inventoryNames.contains(item.name.toLowerCase()))
        .map((item) => item.name)
        .take(3)
        .toList();

    if (missingSuggestions.isEmpty) {
      return 'Your current grocery suggestions are already available in your '
          'kitchen.';
    }

    return 'Consider buying: ${missingSuggestions.join(', ')}. These items '
        'support common quick meals.';
  }

  String _inventoryResponse(List<Ingredient> inventory) {
    if (inventory.isEmpty) {
      return 'Your inventory is empty. Add ingredients first so I can help '
          'with recipes and expiry reminders.';
    }

    final itemNames = inventory.take(5).map((item) => item.name).join(', ');
    return 'You currently have ${inventory.length} ingredients listed, '
        'including $itemNames.';
  }
}
