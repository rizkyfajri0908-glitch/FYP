import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/kitchen_controller.dart';
import '../models/grocery_suggestion.dart';
import '../models/ingredient.dart';
import '../services/grocery_planning_service.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/section_header.dart';

enum _GroceryFilter {
  all,
  recipes,
  staples,
  highPriority,
  budget,
  healthy,
}

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key, required this.controller});

  final KitchenController controller;

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  static const _planningService = GroceryPlanningService();
  static const _checkedItemsKey = 'grocery_checked_items';
  static const _customItemsKey = 'grocery_custom_items';

  final Set<String> _checkedItems = {};
  final List<GrocerySuggestion> _customItems = [];
  _GroceryFilter _selectedFilter = _GroceryFilter.all;
  bool _hideCheckedItems = false;

  @override
  void initState() {
    super.initState();
    _loadSavedGroceryState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final suggestions = _planningService.buildPlan(
          widget.controller.ingredients,
          recipes: widget.controller.recipes,
          preferences: widget.controller.preferences,
          customItems: _customItems,
        );
        final visibleSuggestions = _filteredSuggestions(suggestions);
        final checkedCount = suggestions
            .where((item) => _checkedItems.contains(_keyFor(item)))
            .length;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const SectionHeader(
              title: 'Predictive Grocery Plan',
              subtitle:
                  'Suggested items based on recipes, missing staples, and your EcoBite profile.',
            ),
            const SizedBox(height: 16),
            _GrocerySummaryCard(
              totalCount: suggestions.length,
              checkedCount: checkedCount,
              hideCheckedItems: _hideCheckedItems,
              onToggleHideChecked: (value) {
                setState(() => _hideCheckedItems = value);
              },
              onFinishShopping:
                  checkedCount == 0 ? null : () => _finishShopping(suggestions),
            ),
            const SizedBox(height: 12),
            _GroceryFilterBar(
              selectedFilter: _selectedFilter,
              onChanged: (filter) => setState(() => _selectedFilter = filter),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _showCustomItemDialog,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add Custom Grocery Item'),
            ),
            const SizedBox(height: 16),
            if (visibleSuggestions.isEmpty)
              const _EmptyGroceryCard()
            else
              ..._groupedSuggestions(visibleSuggestions).entries.map(
                    (entry) => _GroceryGroup(
                      title: entry.key,
                      suggestions: entry.value,
                      checkedItems: _checkedItems,
                      onChanged: _setChecked,
                      onAddToInventory: _showAddToInventorySheet,
                      onRemoveCustom: _removeCustomItem,
                    ),
                  ),
          ],
        );
      },
    );
  }

  List<GrocerySuggestion> _filteredSuggestions(List<GrocerySuggestion> items) {
    return switch (_selectedFilter) {
      _GroceryFilter.all => items,
      _GroceryFilter.recipes =>
        items.where((item) => item.source == GrocerySource.recipe).toList(),
      _GroceryFilter.staples =>
        items.where((item) => item.source == GrocerySource.staple).toList(),
      _GroceryFilter.highPriority =>
        items.where((item) => item.priority == GroceryPriority.high).toList(),
      _GroceryFilter.budget =>
        items.where((item) => item.tags.contains('budget')).toList(),
      _GroceryFilter.healthy =>
        items.where((item) => item.tags.contains('healthy')).toList(),
    }
        .where((item) {
      if (!_hideCheckedItems) {
        return true;
      }
      return !_checkedItems.contains(_keyFor(item));
    }).toList();
  }

  Map<String, List<GrocerySuggestion>> _groupedSuggestions(
    List<GrocerySuggestion> suggestions,
  ) {
    final groups = <String, List<GrocerySuggestion>>{};
    for (final suggestion in suggestions) {
      groups.putIfAbsent(_groupTitleFor(suggestion), () => []).add(suggestion);
    }
    return groups;
  }

  String _groupTitleFor(GrocerySuggestion suggestion) {
    return switch (suggestion.source) {
      GrocerySource.recipe => 'Needed for Recipes',
      GrocerySource.staple => 'Common Staples',
      GrocerySource.expiryReplacement => 'Expiry Replacements',
      GrocerySource.frequent => 'Optional Profile Picks',
      GrocerySource.custom => 'Custom Items',
    };
  }

  Future<void> _loadSavedGroceryState() async {
    final preferences = await SharedPreferences.getInstance();
    final checkedItems = preferences.getStringList(_checkedItemsKey) ?? [];
    final customItems = preferences.getStringList(_customItemsKey) ?? [];

    if (!mounted) {
      return;
    }

    setState(() {
      _checkedItems.addAll(checkedItems);
      _customItems.addAll(
        customItems.map(
          (item) => GrocerySuggestion.fromJson(
            jsonDecode(item) as Map<String, dynamic>,
          ),
        ),
      );
    });
  }

  Future<void> _saveGroceryState() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_checkedItemsKey, _checkedItems.toList());
    await preferences.setStringList(
      _customItemsKey,
      _customItems.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  void _setChecked(GrocerySuggestion suggestion, bool isChecked) {
    setState(() {
      if (isChecked) {
        _checkedItems.add(_keyFor(suggestion));
      } else {
        _checkedItems.remove(_keyFor(suggestion));
      }
    });
    _saveGroceryState();
  }

  Future<void> _showCustomItemDialog() async {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1 item');

    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Grocery Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (shouldAdd != true || nameController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _customItems.add(
        GrocerySuggestion(
          name: nameController.text.trim(),
          quantity: quantityController.text.trim().isEmpty
              ? '1 item'
              : quantityController.text.trim(),
          reason: 'Added manually to your grocery plan.',
          priority: GroceryPriority.medium,
          source: GrocerySource.custom,
        ),
      );
    });
    _saveGroceryState();
  }

  void _removeCustomItem(GrocerySuggestion suggestion) {
    if (suggestion.source != GrocerySource.custom) {
      return;
    }

    setState(() {
      _customItems.removeWhere((item) => _keyFor(item) == _keyFor(suggestion));
      _checkedItems.remove(_keyFor(suggestion));
    });
    _saveGroceryState();
  }

  Future<void> _showAddToInventorySheet(GrocerySuggestion suggestion) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _AddPurchasedItemSheet(
        suggestion: suggestion,
        controller: widget.controller,
        onSaved: () => _setChecked(suggestion, true),
      ),
    );
  }

  String _keyFor(GrocerySuggestion suggestion) {
    return suggestion.name.toLowerCase();
  }

  Future<void> _finishShopping(List<GrocerySuggestion> suggestions) async {
    final checkedSuggestions = suggestions
        .where((suggestion) => _checkedItems.contains(_keyFor(suggestion)))
        .toList();
    if (checkedSuggestions.isEmpty) {
      return;
    }

    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Finish Shopping?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 18),
              Text(
                '${checkedSuggestions.length} checked item(s) will be cleared from this shopping session. Add bought items to Inventory first if needed.',
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.35),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Finish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldClear != true) {
      return;
    }

    setState(() {
      for (final suggestion in checkedSuggestions) {
        _checkedItems.remove(_keyFor(suggestion));
        if (suggestion.source == GrocerySource.custom) {
          _customItems.removeWhere(
            (item) => _keyFor(item) == _keyFor(suggestion),
          );
        }
      }
    });
    _saveGroceryState();
  }
}

class _GrocerySummaryCard extends StatelessWidget {
  const _GrocerySummaryCard({
    required this.totalCount,
    required this.checkedCount,
    required this.hideCheckedItems,
    required this.onToggleHideChecked,
    required this.onFinishShopping,
  });

  final int totalCount;
  final int checkedCount;
  final bool hideCheckedItems;
  final ValueChanged<bool> onToggleHideChecked;
  final VoidCallback? onFinishShopping;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : checkedCount / totalCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_checkout,
              color: AppColors.forestGreen,
              size: 34,
            ),
            const SizedBox(height: 10),
            Text(
              '$checkedCount of $totalCount planned items selected',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.mintGreen,
                color: AppColors.forestGreen,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: hideCheckedItems,
              onChanged: onToggleHideChecked,
              title: const Text(
                'Hide checked items',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onFinishShopping,
                icon: const Icon(Icons.done_all),
                label: const Text('Finish Shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroceryFilterBar extends StatelessWidget {
  const _GroceryFilterBar({
    required this.selectedFilter,
    required this.onChanged,
  });

  final _GroceryFilter selectedFilter;
  final ValueChanged<_GroceryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _GroceryFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_filterLabel(filter)),
              selected: selectedFilter == filter,
              onSelected: (_) => onChanged(filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(_GroceryFilter filter) {
    return switch (filter) {
      _GroceryFilter.all => 'All',
      _GroceryFilter.recipes => 'Recipes',
      _GroceryFilter.staples => 'Staples',
      _GroceryFilter.highPriority => 'High Priority',
      _GroceryFilter.budget => 'Budget',
      _GroceryFilter.healthy => 'Healthy',
    };
  }
}

class _GroceryGroup extends StatelessWidget {
  const _GroceryGroup({
    required this.title,
    required this.suggestions,
    required this.checkedItems,
    required this.onChanged,
    required this.onAddToInventory,
    required this.onRemoveCustom,
  });

  final String title;
  final List<GrocerySuggestion> suggestions;
  final Set<String> checkedItems;
  final void Function(GrocerySuggestion suggestion, bool isChecked) onChanged;
  final ValueChanged<GrocerySuggestion> onAddToInventory;
  final ValueChanged<GrocerySuggestion> onRemoveCustom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          ...suggestions.map(
            (suggestion) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GroceryTile(
                suggestion: suggestion,
                isChecked: checkedItems.contains(suggestion.name.toLowerCase()),
                onChanged: (isChecked) => onChanged(suggestion, isChecked),
                onAddToInventory: () => onAddToInventory(suggestion),
                onRemoveCustom: () => onRemoveCustom(suggestion),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroceryTile extends StatelessWidget {
  const _GroceryTile({
    required this.suggestion,
    required this.isChecked,
    required this.onChanged,
    required this.onAddToInventory,
    required this.onRemoveCustom,
  });

  final GrocerySuggestion suggestion;
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onAddToInventory;
  final VoidCallback onRemoveCustom;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) => onChanged(value ?? false),
                ),
                Expanded(
                  child: Text(
                    suggestion.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          decoration:
                              isChecked ? TextDecoration.lineThrough : null,
                        ),
                  ),
                ),
                _PriorityBadge(priority: suggestion.priority),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.quantity,
                    style: const TextStyle(
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(suggestion.reason),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SourceChip(source: suggestion.source),
                      ...suggestion.tags.take(2).map(_TagChip.new),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: onAddToInventory,
                          icon: const Icon(Icons.kitchen_outlined),
                          label: const Text('Add to Inventory'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: () => onChanged(true),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Already Have This'),
                        ),
                      ),
                      if (suggestion.source == GrocerySource.custom)
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: onRemoveCustom,
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Remove Custom Item'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPurchasedItemSheet extends StatefulWidget {
  const _AddPurchasedItemSheet({
    required this.suggestion,
    required this.controller,
    required this.onSaved,
  });

  final GrocerySuggestion suggestion;
  final KitchenController controller;
  final VoidCallback onSaved;

  @override
  State<_AddPurchasedItemSheet> createState() => _AddPurchasedItemSheetState();
}

class _AddPurchasedItemSheetState extends State<_AddPurchasedItemSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  IngredientCategory _category = IngredientCategory.pantry;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.suggestion.name);
    _quantityController =
        TextEditingController(text: widget.suggestion.quantity);
    _category = _categoryFromSuggestion(widget.suggestion);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    final expiryLabel =
        '${_expiryDate.day.toString().padLeft(2, '0')}/${_expiryDate.month.toString().padLeft(2, '0')}/${_expiryDate.year}';

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Purchased Item',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Item name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<IngredientCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: IngredientCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(_categoryLabel(category)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _category = value);
              }
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickExpiryDate,
              icon: const Icon(Icons.calendar_month),
              label: Text('Expiry date: $expiryLabel'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Save to Inventory'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickExpiryDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      initialDate: _expiryDate,
    );

    if (pickedDate != null) {
      setState(() => _expiryDate = pickedDate);
    }
  }

  void _save() {
    if (_nameController.text.trim().isEmpty ||
        _quantityController.text.trim().isEmpty) {
      return;
    }

    widget.controller.addIngredient(
      name: _nameController.text.trim(),
      quantity: _quantityController.text.trim(),
      category: _category,
      expiryDate: _expiryDate,
    );
    widget.onSaved();
    Navigator.of(context).pop();
  }

  IngredientCategory _categoryFromSuggestion(GrocerySuggestion suggestion) {
    final name = suggestion.name.toLowerCase();
    if (name.contains('milk') || name.contains('cheese')) {
      return IngredientCategory.dairy;
    }
    if (name.contains('rice') ||
        name.contains('pasta') ||
        name.contains('egg')) {
      return name.contains('egg')
          ? IngredientCategory.protein
          : IngredientCategory.grain;
    }
    if (name.contains('chicken') || name.contains('tuna')) {
      return IngredientCategory.protein;
    }
    if (name.contains('banana') || name.contains('apple')) {
      return IngredientCategory.fruit;
    }
    if (name.contains('carrot') ||
        name.contains('tomato') ||
        name.contains('spinach') ||
        name.contains('onion')) {
      return IngredientCategory.vegetable;
    }
    return IngredientCategory.pantry;
  }

  String _categoryLabel(IngredientCategory category) {
    return switch (category) {
      IngredientCategory.vegetable => 'Vegetable',
      IngredientCategory.protein => 'Protein',
      IngredientCategory.dairy => 'Dairy',
      IngredientCategory.grain => 'Grain',
      IngredientCategory.fruit => 'Fruit',
      IngredientCategory.pantry => 'Pantry',
    };
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
      GrocerySource.expiryReplacement => 'Replacement',
      GrocerySource.frequent => 'Profile',
      GrocerySource.custom => 'Custom',
    };

    final icon = switch (source) {
      GrocerySource.staple => Icons.inventory_2_outlined,
      GrocerySource.recipe => Icons.restaurant_menu,
      GrocerySource.expiryReplacement => Icons.update,
      GrocerySource.frequent => Icons.person_outline,
      GrocerySource.custom => Icons.edit_note,
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

class _TagChip extends StatelessWidget {
  const _TagChip(this.tag);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        tag,
        style: const TextStyle(
          color: AppColors.darkGreen,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: AppColors.mintGreen,
      side: BorderSide.none,
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
