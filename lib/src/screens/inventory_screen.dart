import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/kitchen_controller.dart';
import '../models/ingredient.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/section_header.dart';
import '../widgets/status_chip.dart';

enum _InventoryFilter {
  all,
  urgent,
  expired,
  fresh,
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key, required this.controller});

  final KitchenController controller;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  _InventoryFilter _selectedFilter = _InventoryFilter.all;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final filteredIngredients = _filteredIngredients();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const SectionHeader(
              title: 'Kitchen Inventory',
              subtitle: 'Monitor quantity, category, and expiry date.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _showAddIngredientSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Ingredient'),
            ),
            const SizedBox(height: 16),
            _InventoryFilterBar(
              selectedFilter: _selectedFilter,
              onChanged: (filter) {
                setState(() => _selectedFilter = filter);
              },
            ),
            const SizedBox(height: 16),
            if (filteredIngredients.isEmpty)
              const _EmptyInventoryCard()
            else
              ...filteredIngredients.map(
                (ingredient) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _IngredientTile(
                    ingredient: ingredient,
                    onDelete: () =>
                        widget.controller.removeIngredient(ingredient.id),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _showAddIngredientSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _AddIngredientSheet(controller: widget.controller),
    );
  }

  List<Ingredient> _filteredIngredients() {
    final ingredients = widget.controller.ingredients;

    return switch (_selectedFilter) {
      _InventoryFilter.all => ingredients,
      _InventoryFilter.urgent => ingredients
          .where(
            (ingredient) =>
                ingredient.expiryStatus == ExpiryStatus.today ||
                ingredient.expiryStatus == ExpiryStatus.soon,
          )
          .toList(),
      _InventoryFilter.expired => ingredients
          .where((ingredient) => ingredient.expiryStatus == ExpiryStatus.expired)
          .toList(),
      _InventoryFilter.fresh => ingredients
          .where((ingredient) => ingredient.expiryStatus == ExpiryStatus.fresh)
          .toList(),
    };
  }
}

class _IngredientTile extends StatelessWidget {
  const _IngredientTile({
    required this.ingredient,
    required this.onDelete,
  });

  final Ingredient ingredient;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy').format(ingredient.expiryDate);

    return Card(
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.mintGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_categoryIcon(ingredient.category)),
        ),
        title: Text(ingredient.name),
        subtitle: Text(
          '${ingredient.quantity} - Expiry: $date\n${ingredient.expiryMessage}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusChip(
              days: ingredient.daysUntilExpiry,
              status: ingredient.expiryStatus,
            ),
            IconButton(
              tooltip: 'Remove',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(IngredientCategory category) {
    return switch (category) {
      IngredientCategory.vegetable => Icons.grass,
      IngredientCategory.protein => Icons.egg_alt,
      IngredientCategory.dairy => Icons.local_drink,
      IngredientCategory.grain => Icons.rice_bowl,
      IngredientCategory.fruit => Icons.apple,
      IngredientCategory.pantry => Icons.inventory_2,
    };
  }
}

class _InventoryFilterBar extends StatelessWidget {
  const _InventoryFilterBar({
    required this.selectedFilter,
    required this.onChanged,
  });

  final _InventoryFilter selectedFilter;
  final ValueChanged<_InventoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<_InventoryFilter>(
        selected: {selectedFilter},
        onSelectionChanged: (selection) => onChanged(selection.first),
        segments: const [
          ButtonSegment(
            value: _InventoryFilter.all,
            icon: Icon(Icons.list),
            label: Text('All'),
          ),
          ButtonSegment(
            value: _InventoryFilter.urgent,
            icon: Icon(Icons.notifications_active_outlined),
            label: Text('Urgent'),
          ),
          ButtonSegment(
            value: _InventoryFilter.expired,
            icon: Icon(Icons.warning_amber),
            label: Text('Expired'),
          ),
          ButtonSegment(
            value: _InventoryFilter.fresh,
            icon: Icon(Icons.eco_outlined),
            label: Text('Fresh'),
          ),
        ],
      ),
    );
  }
}

class _AddIngredientSheet extends StatefulWidget {
  const _AddIngredientSheet({required this.controller});

  final KitchenController controller;

  @override
  State<_AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends State<_AddIngredientSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  IngredientCategory _category = IngredientCategory.vegetable;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    final date = DateFormat('dd MMM yyyy').format(_expiryDate);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Ingredient',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingredient name',
                prefixIcon: Icon(Icons.kitchen),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter an ingredient name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                prefixIcon: Icon(Icons.scale),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter the quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<IngredientCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
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
                label: Text('Expiry date: $date'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saveIngredient,
                icon: const Icon(Icons.check),
                label: const Text('Save Ingredient'),
              ),
            ),
          ],
        ),
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

  void _saveIngredient() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.controller.addIngredient(
      name: _nameController.text,
      quantity: _quantityController.text,
      category: _category,
      expiryDate: _expiryDate,
    );

    Navigator.of(context).pop();
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

class _EmptyInventoryCard extends StatelessWidget {
  const _EmptyInventoryCard();

  @override
  Widget build(BuildContext context) {
    return const EmptyStateCard(
      icon: Icons.kitchen_outlined,
      message: 'No ingredients in this view. Add an item or change the filter.',
    );
  }
}
