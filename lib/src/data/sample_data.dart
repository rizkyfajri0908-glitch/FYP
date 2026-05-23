import '../models/grocery_suggestion.dart';
import '../models/ingredient.dart';
import 'recipe_catalog.dart';

class SampleData {
  const SampleData._();

  static List<Ingredient> ingredients = [
    Ingredient(
      id: '1',
      name: 'Chicken breast',
      quantity: '2 pieces',
      category: IngredientCategory.protein,
      expiryDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Ingredient(
      id: '2',
      name: 'Spinach',
      quantity: '1 bunch',
      category: IngredientCategory.vegetable,
      expiryDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Ingredient(
      id: '3',
      name: 'Milk',
      quantity: '1 carton',
      category: IngredientCategory.dairy,
      expiryDate: DateTime.now().add(const Duration(days: 4)),
    ),
    Ingredient(
      id: '4',
      name: 'Rice',
      quantity: '2 kg',
      category: IngredientCategory.grain,
      expiryDate: DateTime.now().add(const Duration(days: 60)),
    ),
    Ingredient(
      id: '5',
      name: 'Tomatoes',
      quantity: '5 pieces',
      category: IngredientCategory.vegetable,
      expiryDate: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  static const recipes = RecipeCatalog.recipes;

  static const grocerySuggestions = [
    GrocerySuggestion(
      name: 'Eggs',
      reason: 'Often used in quick meals and currently missing.',
      priority: GroceryPriority.high,
      source: GrocerySource.staple,
    ),
    GrocerySuggestion(
      name: 'Onions',
      reason: 'Frequently paired with chicken and rice recipes.',
      priority: GroceryPriority.medium,
      source: GrocerySource.staple,
    ),
    GrocerySuggestion(
      name: 'Carrots',
      reason: 'Useful for balanced meals and longer fridge storage.',
      priority: GroceryPriority.low,
      source: GrocerySource.staple,
    ),
  ];
}
