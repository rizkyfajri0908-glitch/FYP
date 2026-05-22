import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_data.dart';
import '../models/ingredient.dart';
import '../models/user_preferences.dart';
import '../services/firestore_kitchen_service.dart';
import '../services/notification_service.dart';

class KitchenController extends ChangeNotifier {
  KitchenController({String? userId})
      : _cloudService = userId == null
            ? null
            : FirestoreKitchenService(userId: userId) {
    _loadIngredients();
  }

  static const _ingredientsKey = 'kitchen_ingredients';
  static const _preferencesKey = 'user_preferences';

  final FirestoreKitchenService? _cloudService;
  final List<Ingredient> _ingredients = [];
  UserPreferences _preferences = UserPreferences.defaults();
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);
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
    final preferences = await SharedPreferences.getInstance();
    final savedIngredients = preferences.getStringList(_ingredientsKey);
    final savedPreferences = preferences.getString(_preferencesKey);

    final cloudIngredients = await _loadCloudIngredients();
    final cloudPreferences = await _loadCloudPreferences();

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

    _isLoading = false;
    await _rescheduleExpiryReminders();
    notifyListeners();
  }

  Future<List<Ingredient>?> _loadCloudIngredients() async {
    try {
      final cloudIngredients = await _cloudService?.loadIngredients();
      if (cloudIngredients == null) {
        return null;
      }
      if (cloudIngredients.isEmpty) {
        for (final ingredient in SampleData.ingredients) {
          await _cloudService?.saveIngredient(ingredient);
        }
        return SampleData.ingredients;
      }
      return cloudIngredients;
    } catch (_) {
      return null;
    }
  }

  Future<UserPreferences?> _loadCloudPreferences() async {
    try {
      return _cloudService?.loadPreferences();
    } catch (_) {
      return null;
    }
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
