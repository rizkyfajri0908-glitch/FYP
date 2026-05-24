import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../controllers/kitchen_controller.dart';
import '../models/ingredient.dart';
import '../services/barcode_lookup_service.dart';
import '../theme/app_colors.dart';
import '../widgets/section_header.dart';
import '../widgets/status_chip.dart';

enum _InventoryFilter {
  all,
  today,
  urgent,
  expired,
  fresh,
}

enum _CategoryFilter {
  all,
  vegetable,
  protein,
  dairy,
  grain,
  fruit,
  pantry,
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key, required this.controller});

  final KitchenController controller;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _barcodeLookupService = BarcodeLookupService();
  final _searchController = TextEditingController();

  _InventoryFilter _selectedFilter = _InventoryFilter.all;
  _CategoryFilter _selectedCategory = _CategoryFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              subtitle: 'Monitor quantity, category and expiry date',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search items',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showAddIngredientSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Ingredient'),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filledTonal(
                  tooltip: 'Scan QR or barcode',
                  onPressed: () => _scanIngredientCode(context),
                  icon: const Icon(Icons.qr_code_scanner),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InventoryFilterBar(
              selectedFilter: _selectedFilter,
              onChanged: (filter) {
                setState(() => _selectedFilter = filter);
              },
            ),
            const SizedBox(height: 12),
            _CategoryFilterBar(
              selectedCategory: _selectedCategory,
              onChanged: (category) {
                setState(() => _selectedCategory = category);
              },
            ),
            const SizedBox(height: 16),
            if (filteredIngredients.isEmpty)
              _EmptyInventoryCard(
                onAdd: () => _showAddIngredientSheet(context),
                onScan: () => _scanIngredientCode(context),
                hasSearchOrFilter: _searchController.text.trim().isNotEmpty ||
                    _selectedFilter != _InventoryFilter.all ||
                    _selectedCategory != _CategoryFilter.all,
                onClearFilters: _clearFilters,
              )
            else
              ...filteredIngredients.map(
                (ingredient) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _IngredientTile(
                    ingredient: ingredient,
                    onEdit: () => _showEditIngredientSheet(
                      context,
                      ingredient,
                    ),
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

  Future<void> _scanIngredientCode(BuildContext context) async {
    final scannedValue = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const _IngredientScannerScreen()),
    );

    if (!context.mounted || scannedValue == null || scannedValue.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checking barcode details...')),
    );

    final scannedIngredient = await _resolveScannedIngredient(scannedValue);

    if (!context.mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _AddIngredientSheet(
        controller: widget.controller,
        scannedIngredient: scannedIngredient,
      ),
    );
  }

  Future<_ScannedIngredient> _resolveScannedIngredient(
      String scannedValue) async {
    final parsedIngredient = _ScannedIngredient.fromRawValue(scannedValue);
    final product = await _barcodeLookupService.lookup(scannedValue);

    if (product == null) {
      return parsedIngredient;
    }

    return _ScannedIngredient.fromBarcodeProduct(product);
  }

  Future<void> _showEditIngredientSheet(
    BuildContext context,
    Ingredient ingredient,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _AddIngredientSheet(
        controller: widget.controller,
        ingredient: ingredient,
      ),
    );
  }

  List<Ingredient> _filteredIngredients() {
    final query = _searchController.text.trim().toLowerCase();
    final ingredients = widget.controller.ingredients.where((ingredient) {
      if (query.isNotEmpty &&
          !ingredient.name.toLowerCase().contains(query) &&
          !ingredient.quantity.toLowerCase().contains(query)) {
        return false;
      }

      if (_selectedCategory != _CategoryFilter.all &&
          ingredient.category.name != _selectedCategory.name) {
        return false;
      }

      return true;
    }).toList();

    return switch (_selectedFilter) {
      _InventoryFilter.all => ingredients,
      _InventoryFilter.today => ingredients
          .where((ingredient) => ingredient.expiryStatus == ExpiryStatus.today)
          .toList(),
      _InventoryFilter.urgent => ingredients
          .where(
            (ingredient) =>
                ingredient.expiryStatus == ExpiryStatus.today ||
                ingredient.expiryStatus == ExpiryStatus.soon,
          )
          .toList(),
      _InventoryFilter.expired => ingredients
          .where(
              (ingredient) => ingredient.expiryStatus == ExpiryStatus.expired)
          .toList(),
      _InventoryFilter.fresh => ingredients
          .where((ingredient) => ingredient.expiryStatus == ExpiryStatus.fresh)
          .toList(),
    };
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedFilter = _InventoryFilter.all;
      _selectedCategory = _CategoryFilter.all;
    });
  }
}

class _IngredientTile extends StatelessWidget {
  const _IngredientTile({
    required this.ingredient,
    required this.onEdit,
    required this.onDelete,
  });

  final Ingredient ingredient;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy').format(ingredient.expiryDate);
    final cardColor = _cardColor(ingredient);

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.mintGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_categoryIcon(ingredient.category)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ingredient.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ingredient.quantity,
                    style: TextStyle(color: AppColors.readableMuted(context)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Expiry: $date',
                    style: TextStyle(color: AppColors.readableMuted(context)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _IngredientActions(
              ingredient: ingredient,
              onEdit: onEdit,
              onDelete: onDelete,
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

  Color _cardColor(Ingredient ingredient) {
    return switch (ingredient.expiryStatus) {
      ExpiryStatus.expired => const Color(0xFFF7C9C5),
      ExpiryStatus.today => const Color(0xFFF7C9C5),
      ExpiryStatus.soon => const Color(0xFFFFF3D8),
      ExpiryStatus.fresh => Colors.white,
    };
  }
}

class _IngredientActions extends StatelessWidget {
  const _IngredientActions({
    required this.ingredient,
    required this.onEdit,
    required this.onDelete,
  });

  final Ingredient ingredient;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    if (ingredient.expiryStatus == ExpiryStatus.expired) {
      return SizedBox(
        width: 70,
        height: 74,
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusChip(
                days: ingredient.daysUntilExpiry,
                status: ingredient.expiryStatus,
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 34,
                height: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Remove expired item',
                  visualDensity: VisualDensity.compact,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: 70,
      height: 86,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatusChip(
            days: ingredient.daysUntilExpiry,
            status: ingredient.expiryStatus,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit',
                  visualDensity: VisualDensity.compact,
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                ),
              ),
              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Remove',
                  visualDensity: VisualDensity.compact,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
            value: _InventoryFilter.today,
            icon: Icon(Icons.today),
            label: Text('Today'),
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

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({
    required this.selectedCategory,
    required this.onChanged,
  });

  final _CategoryFilter selectedCategory;
  final ValueChanged<_CategoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _CategoryFilter.values.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_categoryFilterLabel(category)),
              selected: selectedCategory == category,
              onSelected: (_) => onChanged(category),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _categoryFilterLabel(_CategoryFilter category) {
    return switch (category) {
      _CategoryFilter.all => 'All Categories',
      _CategoryFilter.vegetable => 'Vegetables',
      _CategoryFilter.protein => 'Protein',
      _CategoryFilter.dairy => 'Dairy',
      _CategoryFilter.grain => 'Grain',
      _CategoryFilter.fruit => 'Fruit',
      _CategoryFilter.pantry => 'Pantry',
    };
  }
}

class _IngredientScannerScreen extends StatefulWidget {
  const _IngredientScannerScreen();

  @override
  State<_IngredientScannerScreen> createState() =>
      _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<_IngredientScannerScreen> {
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scan Item'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_hasScanned) {
                return;
              }

              final value = capture.barcodes.isEmpty
                  ? null
                  : capture.barcodes.first.rawValue;
              if (value == null || value.trim().isEmpty) {
                return;
              }

              setState(() => _hasScanned = true);
              Navigator.of(context).pop(value.trim());
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.black.withValues(alpha: 0.65),
              child: const SafeArea(
                top: false,
                child: Text(
                  'Point the camera at a QR code or product barcode.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannedIngredient {
  const _ScannedIngredient({
    required this.rawValue,
    required this.name,
    required this.quantity,
    required this.category,
    required this.source,
  });

  factory _ScannedIngredient.fromRawValue(String rawValue) {
    final fields = _fieldsFromRawValue(rawValue);
    final name = fields['name'] ??
        fields['item'] ??
        fields['ingredient'] ??
        _nameFromRawValue(rawValue);

    return _ScannedIngredient(
      rawValue: rawValue,
      name: name,
      quantity: fields['quantity'] ?? fields['qty'] ?? '1 item',
      category: _categoryFromText(fields['category'] ?? name),
      source: 'Scanned code',
    );
  }

  factory _ScannedIngredient.fromBarcodeProduct(BarcodeProduct product) {
    return _ScannedIngredient(
      rawValue: product.barcode,
      name: product.name,
      quantity: product.quantity,
      category: product.category,
      source: product.source,
    );
  }

  final String rawValue;
  final String name;
  final String quantity;
  final IngredientCategory category;
  final String source;

  static Map<String, String> _fieldsFromRawValue(String rawValue) {
    final fields = <String, String>{};
    final normalized = rawValue.replaceAll('\n', ';');
    final parts = normalized.split(RegExp('[;,|]'));

    for (final part in parts) {
      final separatorIndex = part.indexOf(RegExp('[:=]'));
      if (separatorIndex <= 0) {
        continue;
      }

      final key = part.substring(0, separatorIndex).trim().toLowerCase();
      final value = part.substring(separatorIndex + 1).trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        fields[key] = value;
      }
    }

    return fields;
  }

  static String _nameFromRawValue(String rawValue) {
    final trimmedValue = rawValue.trim();
    final uri = Uri.tryParse(trimmedValue);
    final nameFromUri =
        uri?.queryParameters['name'] ?? uri?.queryParameters['item'];

    if (nameFromUri != null && nameFromUri.trim().isNotEmpty) {
      return nameFromUri.trim();
    }

    if (RegExp(r'^\d+$').hasMatch(trimmedValue)) {
      return 'Scanned item $trimmedValue';
    }

    return trimmedValue.length > 40
        ? trimmedValue.substring(0, 40)
        : trimmedValue;
  }

  static IngredientCategory _categoryFromText(String text) {
    final normalized = text.toLowerCase();

    if (_containsAny(normalized, ['milk', 'cheese', 'yogurt', 'yoghurt'])) {
      return IngredientCategory.dairy;
    }
    if (_containsAny(normalized, ['rice', 'pasta', 'bread', 'oats'])) {
      return IngredientCategory.grain;
    }
    if (_containsAny(normalized, ['chicken', 'egg', 'fish', 'beef', 'tuna'])) {
      return IngredientCategory.protein;
    }
    if (_containsAny(normalized, ['banana', 'apple', 'orange', 'fruit'])) {
      return IngredientCategory.fruit;
    }
    if (_containsAny(
        normalized, ['spinach', 'tomato', 'carrot', 'vegetable'])) {
      return IngredientCategory.vegetable;
    }
    return IngredientCategory.pantry;
  }

  static bool _containsAny(String source, List<String> targets) {
    return targets.any(source.contains);
  }
}

class _AddIngredientSheet extends StatefulWidget {
  const _AddIngredientSheet({
    required this.controller,
    this.ingredient,
    this.scannedIngredient,
  });

  final KitchenController controller;
  final Ingredient? ingredient;
  final _ScannedIngredient? scannedIngredient;

  @override
  State<_AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends State<_AddIngredientSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  IngredientCategory _category = IngredientCategory.vegetable;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));

  bool get _isEditing => widget.ingredient != null;

  @override
  void initState() {
    super.initState();
    final ingredient = widget.ingredient;
    if (ingredient != null) {
      _nameController.text = ingredient.name;
      _quantityController.text = ingredient.quantity;
      _category = ingredient.category;
      _expiryDate = ingredient.expiryDate;
      return;
    }

    final scannedIngredient = widget.scannedIngredient;
    if (scannedIngredient != null) {
      _nameController.text = scannedIngredient.name;
      _quantityController.text = scannedIngredient.quantity;
      _category = scannedIngredient.category;
    }
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
              _isEditing ? 'Edit Ingredient' : 'Add Ingredient',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.titleGreen(context),
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
            if (widget.scannedIngredient != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Found from ${widget.scannedIngredient!.source}. Confirm the item details before saving',
                  style: TextStyle(
                    color: AppColors.titleGreen(context),
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
            ],
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
                label: Text(
                  _isEditing ? 'Update Ingredient' : 'Save Ingredient',
                ),
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

    if (_isEditing) {
      widget.controller.updateIngredient(
        Ingredient(
          id: widget.ingredient!.id,
          name: _nameController.text.trim(),
          quantity: _quantityController.text.trim(),
          category: _category,
          expiryDate: _expiryDate,
        ),
      );
    } else {
      widget.controller.addIngredient(
        name: _nameController.text,
        quantity: _quantityController.text,
        category: _category,
        expiryDate: _expiryDate,
      );
    }

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
  const _EmptyInventoryCard({
    required this.onAdd,
    required this.onScan,
    required this.hasSearchOrFilter,
    required this.onClearFilters,
  });

  final VoidCallback onAdd;
  final VoidCallback onScan;
  final bool hasSearchOrFilter;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.kitchen_outlined,
              color: AppColors.iconGreen(context),
              size: 36,
            ),
            const SizedBox(height: 10),
            Text(
              hasSearchOrFilter
                  ? 'No items match this search or filter.'
                  : 'No items yet, Add your first kitchen item',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (hasSearchOrFilter)
              OutlinedButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.filter_alt_off),
                label: const Text('Clear Filters'),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Item'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'Scan item',
                    onPressed: onScan,
                    icon: const Icon(Icons.qr_code_scanner),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
