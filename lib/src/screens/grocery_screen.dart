import 'package:flutter/material.dart';

import '../controllers/kitchen_controller.dart';
import '../models/grocery_suggestion.dart';
import '../services/grocery_planning_service.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/section_header.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key, required this.controller});

  final KitchenController controller;

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  static const _planningService = GroceryPlanningService();

  final Set<String> _checkedItems = {};

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final suggestions =
            _planningService.buildPlan(widget.controller.ingredients);
        final checkedCount = suggestions
            .where((item) => _checkedItems.contains(item.name))
            .length;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const SectionHeader(
              title: 'Predictive Grocery Plan',
              subtitle: 'Suggested items based on recipes and missing staples.',
            ),
            const SizedBox(height: 16),
            _GrocerySummaryCard(
              totalCount: suggestions.length,
              checkedCount: checkedCount,
            ),
            const SizedBox(height: 16),
            if (suggestions.isEmpty)
              const _EmptyGroceryCard()
            else
              ...suggestions.map(
                (suggestion) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _GroceryTile(
                    suggestion: suggestion,
                    isChecked: _checkedItems.contains(suggestion.name),
                    onChanged: (isChecked) {
                      setState(() {
                        if (isChecked) {
                          _checkedItems.add(suggestion.name);
                        } else {
                          _checkedItems.remove(suggestion.name);
                        }
                      });
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GrocerySummaryCard extends StatelessWidget {
  const _GrocerySummaryCard({
    required this.totalCount,
    required this.checkedCount,
  });

  final int totalCount;
  final int checkedCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.mintGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_cart_checkout,
                color: AppColors.forestGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$checkedCount of $totalCount planned items selected',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroceryTile extends StatelessWidget {
  const _GroceryTile({
    required this.suggestion,
    required this.isChecked,
    required this.onChanged,
  });

  final GrocerySuggestion suggestion;
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: isChecked,
        onChanged: (value) => onChanged(value ?? false),
        title: Text(suggestion.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(suggestion.reason),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SourceChip(source: suggestion.source),
                _PriorityChip(priority: suggestion.priority),
              ],
            ),
          ],
        ),
        secondary: _PriorityBadge(priority: suggestion.priority),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.source});

  final GrocerySource source;

  @override
  Widget build(BuildContext context) {
    final label = switch (source) {
      GrocerySource.staple => 'Staple',
      GrocerySource.recipe => 'Recipe',
    };

    final icon = switch (source) {
      GrocerySource.staple => Icons.inventory_2_outlined,
      GrocerySource.recipe => Icons.restaurant_menu,
    };

    return Chip(
      avatar: Icon(icon, size: 16, color: AppColors.darkGreen),
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.darkGreen,
          fontWeight: FontWeight.w800,
        ),
      ),
      backgroundColor: const Color(0xFFDDF2E1),
      side: BorderSide.none,
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});

  final GroceryPriority priority;

  @override
  Widget build(BuildContext context) {
    final label = switch (priority) {
      GroceryPriority.high => 'High priority',
      GroceryPriority.medium => 'Medium priority',
      GroceryPriority.low => 'Low priority',
    };

    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFDDEFE1)),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final GroceryPriority priority;

  @override
  Widget build(BuildContext context) {
    final label = switch (priority) {
      GroceryPriority.high => 'High',
      GroceryPriority.medium => 'Med',
      GroceryPriority.low => 'Low',
    };

    final color = switch (priority) {
      GroceryPriority.high => AppColors.danger,
      GroceryPriority.medium => AppColors.warning,
      GroceryPriority.low => AppColors.forestGreen,
    };

    return Container(
      width: 48,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _badgeBackground(priority),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w800),
      ),
    );
  }

  Color _badgeBackground(GroceryPriority priority) {
    return switch (priority) {
      GroceryPriority.high => const Color(0xFFF9D6D4),
      GroceryPriority.medium => const Color(0xFFFFE8BF),
      GroceryPriority.low => const Color(0xFFDDF2E1),
    };
  }
}

class _EmptyGroceryCard extends StatelessWidget {
  const _EmptyGroceryCard();

  @override
  Widget build(BuildContext context) {
    return const EmptyStateCard(
      icon: Icons.shopping_bag_outlined,
      message: 'No grocery suggestions right now.',
    );
  }
}
