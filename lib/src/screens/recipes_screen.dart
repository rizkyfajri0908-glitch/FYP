import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/kitchen_controller.dart';
import '../models/grocery_suggestion.dart';
import '../services/recipe_recommendation_service.dart';
import '../theme/app_colors.dart';
import '../widgets/section_header.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key, required this.controller});

  static const _recommendationService = RecipeRecommendationService();

  final KitchenController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final recommendations = _recommendationService.rankRecipes(
          recipes: controller.recipes,
          inventory: controller.ingredients,
          preferences: controller.preferences,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const SectionHeader(
              title: 'Recipe Suggestions',
              subtitle: 'Recommendations based on available ingredients.',
            ),
            const SizedBox(height: 16),
            ...recommendations.map(
              (recommendation) {
                return _RecipeRecommendationCard(
                  recommendation: recommendation,
                  padding: const EdgeInsets.only(bottom: 12),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _RecipeRecommendationCard extends StatelessWidget {
  const _RecipeRecommendationCard({
    required this.recommendation,
    required this.padding,
  });

  final RecipeRecommendation recommendation;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final recipe = recommendation.recipe;
    final hasInventoryMatch = recommendation.matchedIngredients.isNotEmpty;
    final isDarkMode = AppColors.isDarkMode(context);
    final contentColor = hasInventoryMatch
        ? Theme.of(context).colorScheme.onSurface
        : AppColors.readableMuted(context);
    final cardColor = isDarkMode
        ? hasInventoryMatch
            ? const Color(0xFF2A302C)
            : const Color(0xFF202622)
        : hasInventoryMatch
            ? Colors.white
            : const Color(0xFFF2F4F2);

    return Padding(
      padding: padding,
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _leadingIcon(hasInventoryMatch),
                    color: _leadingColor(context, hasInventoryMatch),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: contentColor,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  Text(
                    '${recipe.minutes} min',
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                recipe.description,
                style: TextStyle(color: contentColor),
              ),
              const SizedBox(height: 8),
              Text(
                '${recommendation.matchedIngredients.length} of ${recommendation.totalIngredients} ingredients available',
                style: TextStyle(
                  color: hasInventoryMatch
                      ? AppColors.iconGreen(context)
                      : AppColors.readableMuted(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _recommendationReason(),
                style: TextStyle(color: contentColor),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recipe.matchingIngredients
                    .map((item) => _IngredientChip(
                          item: item,
                          recommendation: recommendation,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  FilledButton.icon(
                    onPressed: recommendation.missingIngredients.isEmpty
                        ? null
                        : () => _addMissingItemsToGrocery(context),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add Missing'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.black : Colors.white,
                      foregroundColor:
                          isDarkMode ? Colors.white : AppColors.darkGreen,
                      side: BorderSide(
                        color: isDarkMode
                            ? const Color(0xFF4B5B51)
                            : const Color(0xFFDDEFE1),
                      ),
                    ),
                    onPressed: () => _openRecipeSource(context),
                    icon: const Icon(Icons.open_in_new),
                    label: Text('View on ${recipe.displaySourceName}'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openRecipeSource(BuildContext context) async {
    final url = Uri.parse(recommendation.recipe.referenceUrl);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final didLaunch = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (didLaunch) {
        return;
      }
    } catch (_) {
      // Fall through to a clear user-facing message below.
    }

    try {
      final didLaunch = await launchUrl(url, mode: LaunchMode.platformDefault);
      if (didLaunch) {
        return;
      }
    } catch (_) {
      // Fall through to a clear user-facing message below.
    }

    if (!context.mounted) {
      return;
    }

    messenger.showSnackBar(
      const SnackBar(content: Text('Could not open recipe link.')),
    );
  }

  Future<void> _addMissingItemsToGrocery(BuildContext context) async {
    if (recommendation.missingIngredients.isEmpty) {
      return;
    }

    const customItemsKey = 'grocery_custom_items';
    final preferences = await SharedPreferences.getInstance();
    final savedItems = preferences.getStringList(customItemsKey) ?? [];
    final savedNames = savedItems
        .map((item) {
          try {
            final decoded = jsonDecode(item) as Map<String, dynamic>;
            return (decoded['name'] as String? ?? '').toLowerCase();
          } catch (_) {
            return '';
          }
        })
        .where((name) => name.isNotEmpty)
        .toSet();

    final nextItems = [...savedItems];
    for (final item in recommendation.missingIngredients) {
      if (savedNames.contains(item.toLowerCase())) {
        continue;
      }

      nextItems.add(
        jsonEncode(
          GrocerySuggestion(
            name: item,
            reason: 'Added from ${recommendation.recipe.title}.',
            priority: GroceryPriority.high,
            source: GrocerySource.custom,
            tags: recommendation.recipe.tags.take(3).toList(),
          ).toJson(),
        ),
      );
    }

    await preferences.setStringList(customItemsKey, nextItems);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${recommendation.missingIngredients.length} missing item(s) added to Grocery Plan.',
        ),
      ),
    );
  }

  IconData _leadingIcon(bool hasInventoryMatch) {
    if (!hasInventoryMatch) {
      return Icons.visibility_off_outlined;
    }
    return recommendation.canCookNow ? Icons.check_circle : Icons.restaurant;
  }

  Color _leadingColor(BuildContext context, bool hasInventoryMatch) {
    if (!hasInventoryMatch) {
      return AppColors.readableMuted(context);
    }
    return recommendation.canCookNow
        ? AppColors.iconGreen(context)
        : AppColors.warning;
  }

  String _recommendationReason() {
    if (recommendation.matchedIngredients.isEmpty) {
      return 'Add at least one ingredient from this recipe to unlock this suggestion.';
    }

    if (recommendation.urgentIngredients.isNotEmpty) {
      return 'Recommended because ${recommendation.urgentIngredients.join(', ')} should be used soon.';
    }

    if (recommendation.canCookNow) {
      return 'You have all required ingredients for this recipe.';
    }

    if (recommendation.missingIngredients.isNotEmpty) {
      return 'Missing: ${recommendation.missingIngredients.join(', ')}.';
    }

    return 'Balanced option based on your current kitchen inventory.';
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({
    required this.item,
    required this.recommendation,
  });

  final String item;
  final RecipeRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final isMatched = recommendation.matchedIngredients.contains(item);
    final isUrgent = recommendation.urgentIngredients.contains(item);
    final isDarkMode = AppColors.isDarkMode(context);

    final backgroundColor = isDarkMode
        ? isUrgent
            ? const Color(0xFF4A3300)
            : isMatched
                ? const Color(0xFF244533)
                : const Color(0xFF151A17)
        : isUrgent
            ? const Color(0xFFFFE8BF)
            : isMatched
                ? AppColors.mintGreen
                : Colors.white;

    final foregroundColor = isDarkMode
        ? isUrgent
            ? const Color(0xFFFFE8BF)
            : Colors.white
        : isUrgent
            ? const Color(0xFF7A4B00)
            : AppColors.ink;

    final icon = isUrgent
        ? Icons.schedule
        : isMatched
            ? Icons.check
            : Icons.add_shopping_cart;

    return Chip(
      avatar: Icon(icon, size: 16, color: foregroundColor),
      label: Text(
        item,
        style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w700),
      ),
      backgroundColor: backgroundColor,
      side: BorderSide(
        color: isDarkMode
            ? const Color(0xFF4B5B51)
            : isUrgent
                ? AppColors.warning
                : const Color(0xFFDDEFE1),
      ),
    );
  }
}
