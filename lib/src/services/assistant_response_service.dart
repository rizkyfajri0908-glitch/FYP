import '../data/sample_data.dart';
import '../models/assistant_knowledge.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/user_preferences.dart';
import 'recipe_recommendation_service.dart';

class AssistantResponseService {
  const AssistantResponseService();

  static const _recipeService = RecipeRecommendationService();

  String respond({
    required String question,
    required List<Ingredient> inventory,
    required List<Recipe> recipes,
    required List<AssistantKnowledge> knowledgeBase,
    UserPreferences? preferences,
  }) {
    final normalizedQuestion = question.toLowerCase().trim();
    final usableInventory = _usableInventory(inventory);

    if (_containsAny(normalizedQuestion, [
      'expire',
      'expiry',
      'expiring',
      'expired',
      'use first',
      'going bad',
      'old food',
      'spoiling',
      'spoiled',
      'soon',
    ])) {
      return _expiryResponse(inventory);
    }

    final knowledgeResponse = _knowledgeResponse(
      question: normalizedQuestion,
      knowledgeBase: knowledgeBase,
    );
    if (knowledgeResponse != null) {
      return knowledgeResponse;
    }

    if (_containsAny(normalizedQuestion, [
      'cook',
      'recipe',
      'meal',
      'make',
      'eat',
      'hungry',
      'dinner',
      'lunch',
      'breakfast',
      'snack',
      'ideas',
      'idea',
      'what now',
      'what should i do',
      'not sure',
      'dont know',
      "don't know",
    ])) {
      return _recipeResponse(
        inventory: usableInventory,
        recipes: recipes,
        preferences: preferences,
      );
    }

    if (_containsAny(
      normalizedQuestion,
      [
        'grocery',
        'buy',
        'shop',
        'shopping',
        'missing',
        'need',
        'store',
        'supermarket',
        'market',
        'restock',
      ],
    )) {
      return _groceryResponse(usableInventory);
    }

    if (_containsAny(normalizedQuestion, ['inventory', 'kitchen', 'have'])) {
      return _inventoryResponse(usableInventory);
    }

    final vagueFoodResponse = _vagueFoodResponse(
      question: normalizedQuestion,
      inventory: usableInventory,
      recipes: recipes,
      preferences: preferences,
    );
    if (vagueFoodResponse != null) {
      return vagueFoodResponse;
    }

    return 'I can help with expiry checks, recipe ideas, grocery planning, '
        'food storage, food safety, dietary preferences, and waste reduction. '
        'Try asking: "What can I cook?" or "How can I reduce food waste?"';
  }

  bool _containsAny(String question, List<String> keywords) {
    return keywords.any(question.contains);
  }

  List<Ingredient> _usableInventory(List<Ingredient> inventory) {
    return inventory
        .where((ingredient) => ingredient.expiryStatus != ExpiryStatus.expired)
        .toList();
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

  String _recipeResponse({
    required List<Ingredient> inventory,
    required List<Recipe> recipes,
    UserPreferences? preferences,
  }) {
    final recommendations = _recipeService.rankRecipes(
      recipes: recipes,
      inventory: inventory,
      preferences: preferences,
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

  String? _knowledgeResponse({
    required String question,
    required List<AssistantKnowledge> knowledgeBase,
  }) {
    AssistantKnowledge? bestEntry;
    var bestScore = 0;

    for (final entry in knowledgeBase) {
      final score = _knowledgeScore(question, entry);
      if (score > bestScore) {
        bestScore = score;
        bestEntry = entry;
      }
    }

    if (bestEntry == null || bestScore < 2) {
      return null;
    }

    return bestEntry.answer;
  }

  int _knowledgeScore(String question, AssistantKnowledge entry) {
    var score = 0;
    final searchableText =
        '${entry.question} ${entry.answer} ${entry.keywords.join(' ')}'
            .toLowerCase();
    final questionWords = question
        .split(RegExp(r'[^a-z0-9]+'))
        .where((word) => word.length >= 3 && !_stopWords.contains(word))
        .toSet();

    for (final keyword in entry.keywords) {
      if (question.contains(keyword.toLowerCase())) {
        score += 3;
      }
    }

    for (final word in questionWords) {
      if (searchableText.contains(word)) {
        score += 1;
      }
    }

    return score;
  }

  String? _vagueFoodResponse({
    required String question,
    required List<Ingredient> inventory,
    required List<Recipe> recipes,
    UserPreferences? preferences,
  }) {
    if (!_isFoodRelated(question)) {
      return null;
    }

    if (_containsAny(question, [
      'help',
      'what',
      'how',
      'suggest',
      'recommend',
      'idea',
      'ideas',
      'confused',
      'lazy',
      'simple',
      'easy',
    ])) {
      return _recipeResponse(
        inventory: inventory,
        recipes: recipes,
        preferences: preferences,
      );
    }

    return 'For food questions, I can help you decide what to cook, what to use first, how to store ingredients, and what to buy next. Add your ingredients to Inventory for more specific suggestions.';
  }

  bool _isFoodRelated(String question) {
    return _containsAny(question, [
      'food',
      'ingredient',
      'ingredients',
      'kitchen',
      'fridge',
      'pantry',
      'cook',
      'cooking',
      'meal',
      'eat',
      'recipe',
      'grocery',
      'shopping',
      'leftover',
      'leftovers',
      'waste',
      'expiry',
      'expire',
      'storage',
      'store',
      'fresh',
      'safe',
      'healthy',
      'budget',
      'breakfast',
      'lunch',
      'dinner',
      'snack',
      'rice',
      'pasta',
      'bread',
      'milk',
      'chicken',
      'vegetable',
      'fruit',
    ]);
  }

  String _groceryResponse(List<Ingredient> inventory) {
    final inventoryNames =
        inventory.map((ingredient) => ingredient.name.toLowerCase()).toSet();
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

  static const _stopWords = {
    'the',
    'and',
    'for',
    'with',
    'that',
    'this',
    'you',
    'your',
    'can',
    'how',
    'what',
    'why',
    'are',
    'should',
    'have',
    'from',
    'into',
    'about',
    'some',
    'more',
    'make',
  };
}
