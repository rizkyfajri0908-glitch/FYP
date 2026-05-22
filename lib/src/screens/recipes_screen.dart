import 'package:flutter/material.dart';

import '../controllers/kitchen_controller.dart';
import '../data/sample_data.dart';
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
          recipes: SampleData.recipes,
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

    return Padding(
      padding: padding,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    recommendation.canCookNow
                        ? Icons.check_circle
                        : Icons.restaurant,
                    color: recommendation.canCookNow
                        ? AppColors.forestGreen
                        : AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  Text('${recipe.minutes} min'),
                ],
              ),
              const SizedBox(height: 8),
              Text(recipe.description),
              const SizedBox(height: 8),
              Text(
                '${recommendation.matchedIngredients.length} of ${recommendation.totalIngredients} ingredients available',
                style: const TextStyle(
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(_recommendationReason()),
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
            ],
          ),
        ),
      ),
    );
  }

  String _recommendationReason() {
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

    final backgroundColor = isUrgent
        ? const Color(0xFFFFE8BF)
        : isMatched
            ? AppColors.mintGreen
            : Colors.white;

    final foregroundColor =
        isUrgent ? const Color(0xFF7A4B00) : AppColors.ink;

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
        color: isUrgent ? AppColors.warning : const Color(0xFFDDEFE1),
      ),
    );
  }
}
