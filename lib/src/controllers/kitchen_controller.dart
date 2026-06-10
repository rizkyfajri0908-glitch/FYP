import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/assistant_knowledge_base.dart';
import '../data/recipe_catalog.dart';
import '../data/sample_data.dart';
import '../models/assistant_knowledge.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/user_preferences.dart';
import '../services/firestore_kitchen_service.dart';
import '../services/notification_service.dart';

class KitchenController extends ChangeNotifier {
  KitchenController({String? userId})
      : _cloudService =
            userId == null ? null : FirestoreKitchenService(userId: userId) {
    _loadIngredients();
  }

  static const _ingredientsKey = 'kitchen_ingredients';
  static const _preferencesKey = 'user_preferences';

  final FirestoreKitchenService? _cloudService;
  final List<Ingredient> _ingredients = [];
  final List<Recipe> _recipes = [];
  final List<AssistantKnowledge> _assistantKnowledge = [];
  UserPreferences _preferences = UserPreferences.defaults();
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);
  List<Recipe> get recipes => List.unmodifiable(_recipes);
  List<AssistantKnowledge> get assistantKnowledge =>
      List.unmodifiable(_assistantKnowledge);
  UserPreferences get preferences => _preferences;

  List<Ingredient> get expiringSoon {
    final items = _ingredients.where((item) => item.isExpiringSoon).toList();
    items.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    return items;
  }

  Future<void> addIngredient({
    required String name,
    required String quantity,
    required IngredientCategory category,
    required DateTime expiryDate,
  }) async {
    final ingredient = Ingredient(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      quantity: quantity.trim(),
      category: category,
      expiryDate: expiryDate,
    );
    _ingredients.add(ingredient);
    await _saveIngredients();
    await _cloudService?.saveIngredient(ingredient);
    await _rescheduleExpiryReminders();
    notifyListeners();
  }

  Future<void> removeIngredient(String id) async {
    _ingredients.removeWhere((item) => item.id == id);
    await _saveIngredients();
    await _cloudService?.deleteIngredient(id);
    await _rescheduleExpiryReminders();
    notifyListeners();
  }

  Future<void> updateIngredient(Ingredient updatedIngredient) async {
    final index = _ingredients.indexWhere(
      (ingredient) => ingredient.id == updatedIngredient.id,
    );
    if (index == -1) {
      return;
    }

    _ingredients[index] = updatedIngredient;
    await _saveIngredients();
    await _cloudService?.saveIngredient(updatedIngredient);
    await _rescheduleExpiryReminders();
    notifyListeners();
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    _preferences = preferences;
    await _savePreferences();
    await _cloudService?.savePreferences(preferences);
    await _rescheduleExpiryReminders();
    notifyListeners();
  }

  Future<void> showTestNotification() {
    return NotificationService.instance.showTestNotification();
  }

  Future<void> _loadIngredients() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedIngredients = preferences.getStringList(_ingredientsKey);
      final savedPreferences = preferences.getString(_preferencesKey);

      final cloudIngredients = await _loadCloudIngredients();
      final cloudPreferences = await _loadCloudPreferences();
      final cloudRecipes = await _loadCloudRecipes();
      final cloudAssistantKnowledge = await _loadCloudAssistantKnowledge();

      _recipes.addAll(cloudRecipes ?? RecipeCatalog.recipes);
      _assistantKnowledge.addAll(
        cloudAssistantKnowledge ?? AssistantKnowledgeBase.entries,
      );

      if (cloudIngredients != null) {
        _ingredients.addAll(cloudIngredients);
      } else if (savedIngredients == null) {
        _ingredients.addAll(SampleData.ingredients);
        await _saveIngredients();
      } else {
        _ingredients.addAll(
          savedIngredients.map(
            (item) => Ingredient.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            ),
          ),
        );
      }

      if (cloudPreferences != null) {
        _preferences = cloudPreferences;
      } else if (savedPreferences != null) {
        _preferences = UserPreferences.fromJson(
          jsonDecode(savedPreferences) as Map<String, dynamic>,
        );
      }
    } catch (_) {
      if (_ingredients.isEmpty) {
        _ingredients.addAll(SampleData.ingredients);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      unawaited(_rescheduleExpiryReminders().catchError((_) {}));
    }
  }

  Future<List<Ingredient>?> _loadCloudIngredients() async {
    try {
      final cloudIngredients = await _cloudService
          ?.loadIngredients()
          .timeout(const Duration(seconds: 8));
      if (cloudIngredients == null) {
        return null;
      }
      if (cloudIngredients.isEmpty) {
        unawaited(_seedCloudIngredients());
        return SampleData.ingredients;
      }
      return cloudIngredients;
    } catch (_) {
      return null;
    }
  }

  Future<UserPreferences?> _loadCloudPreferences() async {
    try {
      return _cloudService
          ?.loadPreferences()
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      return null;
    }
  }

  Future<List<Recipe>?> _loadCloudRecipes() async {
    try {
      final cloudRecipes = await _cloudService
          ?.loadRecipes()
          .timeout(const Duration(seconds: 8));
      if (cloudRecipes == null) {
        return null;
      }
      if (cloudRecipes.isEmpty) {
        unawaited(_seedCloudRecipes(RecipeCatalog.recipes));
        return RecipeCatalog.recipes;
      }

      return _syncCatalogRecipesToFirestore(cloudRecipes).timeout(
        const Duration(seconds: 8),
        onTimeout: () => _mergeCatalogRecipes(cloudRecipes),
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<AssistantKnowledge>?> _loadCloudAssistantKnowledge() async {
    try {
      final cloudKnowledge = await _cloudService
          ?.loadAssistantKnowledge()
          .timeout(const Duration(seconds: 8));
      if (cloudKnowledge == null) {
        return null;
      }
      if (cloudKnowledge.isEmpty) {
        unawaited(_seedCloudAssistantKnowledge(AssistantKnowledgeBase.entries));
        return AssistantKnowledgeBase.entries;
      }

      return _syncAssistantKnowledgeToFirestore(cloudKnowledge).timeout(
        const Duration(seconds: 8),
        onTimeout: () => _mergeAssistantKnowledge(cloudKnowledge),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _seedCloudIngredients() async {
    try {
      for (final ingredient in SampleData.ingredients) {
        await _cloudService?.saveIngredient(ingredient);
      }
    } catch (_) {
      // Background sync should never block the app from opening.
    }
  }

  Future<void> _seedCloudRecipes(List<Recipe> recipes) async {
    try {
      for (final recipe in recipes) {
        await _cloudService?.saveRecipe(recipe);
      }
    } catch (_) {
      // Background sync should never block the app from opening.
    }
  }

  Future<void> _seedCloudAssistantKnowledge(
    List<AssistantKnowledge> knowledgeBase,
  ) async {
    try {
      for (final knowledge in knowledgeBase) {
        await _cloudService?.saveAssistantKnowledge(knowledge);
      }
    } catch (_) {
      // Background sync should never block the app from opening.
    }
  }

  Future<List<AssistantKnowledge>> _syncAssistantKnowledgeToFirestore(
    List<AssistantKnowledge> cloudKnowledge,
  ) async {
    final cloudKnowledgeById = {
      for (final knowledge in cloudKnowledge) knowledge.id: knowledge,
    };
    final syncedKnowledge = <AssistantKnowledge>[];

    for (final defaultKnowledge in AssistantKnowledgeBase.entries) {
      final cloudEntry = cloudKnowledgeById[defaultKnowledge.id];
      final shouldUpdateKnowledge = cloudEntry == null ||
          cloudEntry.question != defaultKnowledge.question ||
          cloudEntry.answer != defaultKnowledge.answer;

      if (shouldUpdateKnowledge) {
        await _cloudService?.saveAssistantKnowledge(defaultKnowledge);
        syncedKnowledge.add(defaultKnowledge);
      } else {
        syncedKnowledge.add(cloudEntry);
      }
    }

    final customCloudKnowledge = cloudKnowledge.where(
      (knowledge) => !AssistantKnowledgeBase.entries.any(
        (defaultKnowledge) => defaultKnowledge.id == knowledge.id,
      ),
    );

    return [...syncedKnowledge, ...customCloudKnowledge];
  }

  List<AssistantKnowledge> _mergeAssistantKnowledge(
    List<AssistantKnowledge> cloudKnowledge,
  ) {
    final customCloudKnowledge = cloudKnowledge.where(
      (knowledge) => !AssistantKnowledgeBase.entries.any(
        (defaultKnowledge) => defaultKnowledge.id == knowledge.id,
      ),
    );

    return [...AssistantKnowledgeBase.entries, ...customCloudKnowledge];
  }

  Future<List<Recipe>> _syncCatalogRecipesToFirestore(
    List<Recipe> cloudRecipes,
  ) async {
    final cloudRecipesById = {
      for (final recipe in cloudRecipes) recipe.id: recipe,
    };
    final syncedRecipes = <Recipe>[];

    for (final catalogRecipe in RecipeCatalog.recipes) {
      final cloudRecipe = cloudRecipesById[catalogRecipe.id];
      final shouldUpdateRecipe = cloudRecipe == null ||
          cloudRecipe.sourceName == 'BBC Good Food' ||
          cloudRecipe.sourceUrl.isEmpty ||
          cloudRecipe.sourceUrl.contains('bbcgoodfood.com/search');

      if (shouldUpdateRecipe) {
        await _cloudService?.saveRecipe(catalogRecipe);
      }

      syncedRecipes.add(shouldUpdateRecipe ? catalogRecipe : cloudRecipe);
    }

    final customCloudRecipes = cloudRecipes.where(
      (recipe) => !RecipeCatalog.recipes.any(
        (catalogRecipe) => catalogRecipe.id == recipe.id,
      ),
    );

    return [...syncedRecipes, ...customCloudRecipes];
  }

  List<Recipe> _mergeCatalogRecipes(List<Recipe> cloudRecipes) {
    final customCloudRecipes = cloudRecipes.where(
      (recipe) => !RecipeCatalog.recipes.any(
        (catalogRecipe) => catalogRecipe.id == recipe.id,
      ),
    );

    return [...RecipeCatalog.recipes, ...customCloudRecipes];
  }

  Future<void> _saveIngredients() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedIngredients = _ingredients
        .map(
          (ingredient) => jsonEncode(ingredient.toJson()),
        )
        .toList();

    await preferences.setStringList(_ingredientsKey, encodedIngredients);
  }

  Future<void> _savePreferences() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _preferencesKey,
      jsonEncode(_preferences.toJson()),
    );
  }

  Future<void> _rescheduleExpiryReminders() {
    return NotificationService.instance.scheduleExpiryReminders(
      ingredients: _ingredients,
      preferences: _preferences,
    );
  }
}
