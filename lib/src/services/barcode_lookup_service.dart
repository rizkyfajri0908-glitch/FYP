import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ingredient.dart';

class BarcodeProduct {
  const BarcodeProduct({
    required this.barcode,
    required this.name,
    required this.quantity,
    required this.category,
    required this.source,
  });

  final String barcode;
  final String name;
  final String quantity;
  final IngredientCategory category;
  final String source;
}

class BarcodeLookupService {
  BarcodeLookupService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<BarcodeProduct?> lookup(String barcode) async {
    final normalizedBarcode = barcode.trim();
    if (normalizedBarcode.isEmpty ||
        !RegExp(r'^\d{6,14}$').hasMatch(normalizedBarcode)) {
      return null;
    }

    final localProduct = _LocalBarcodeDatabase.lookup(normalizedBarcode);
    if (localProduct != null) {
      return localProduct;
    }

    return _lookupOpenFoodFacts(normalizedBarcode);
  }

  Future<BarcodeProduct?> _lookupOpenFoodFacts(String barcode) async {
    try {
      final response = await _client.get(
        Uri.https(
          'world.openfoodfacts.org',
          '/api/v2/product/$barcode.json',
          {
            'fields':
                'code,status,product_name,product_name_en,brands,quantity,categories,categories_tags',
          },
        ),
        headers: const {
          'User-Agent':
              'SmartKitchenAssistant/0.1 (student-project@example.com)',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] != 1) {
        return null;
      }

      final product = data['product'] as Map<String, dynamic>?;
      if (product == null) {
        return null;
      }

      final name = _firstText([
        product['product_name'],
        product['product_name_en'],
        product['brands'],
      ]);

      if (name == null) {
        return null;
      }

      final quantity = _firstText([product['quantity']]) ?? '1 item';
      final categoryText = [
        product['categories'],
        ...(product['categories_tags'] as List<dynamic>? ?? []),
      ].whereType<String>().join(' ');

      return BarcodeProduct(
        barcode: barcode,
        name: name,
        quantity: quantity,
        category: _categoryFromText('$name $categoryText'),
        source: 'Open Food Facts',
      );
    } catch (_) {
      return null;
    }
  }

  String? _firstText(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }

  static IngredientCategory _categoryFromText(String text) {
    final normalized = text.toLowerCase();

    if (_containsAny(normalized, [
      'milk',
      'cheese',
      'yogurt',
      'yoghurt',
      'dairy',
      'cream',
      'butter',
    ])) {
      return IngredientCategory.dairy;
    }
    if (_containsAny(normalized, [
      'rice',
      'pasta',
      'bread',
      'oats',
      'cereal',
      'noodle',
      'grain',
    ])) {
      return IngredientCategory.grain;
    }
    if (_containsAny(normalized, [
      'chicken',
      'egg',
      'fish',
      'beef',
      'tuna',
      'salmon',
      'meat',
      'protein',
    ])) {
      return IngredientCategory.protein;
    }
    if (_containsAny(normalized, [
      'banana',
      'apple',
      'orange',
      'fruit',
      'berries',
      'mango',
    ])) {
      return IngredientCategory.fruit;
    }
    if (_containsAny(normalized, [
      'spinach',
      'tomato',
      'carrot',
      'vegetable',
      'lettuce',
      'cucumber',
      'potato',
    ])) {
      return IngredientCategory.vegetable;
    }
    return IngredientCategory.pantry;
  }

  static bool _containsAny(String source, List<String> targets) {
    return targets.any(source.contains);
  }
}

class _LocalBarcodeDatabase {
  const _LocalBarcodeDatabase._();

  static const _products = {
    '9556041600017': BarcodeProduct(
      barcode: '9556041600017',
      name: 'Milk',
      quantity: '1 carton',
      category: IngredientCategory.dairy,
      source: 'Local barcode database',
    ),
    '9556001211092': BarcodeProduct(
      barcode: '9556001211092',
      name: 'Rice',
      quantity: '1 pack',
      category: IngredientCategory.grain,
      source: 'Local barcode database',
    ),
    '9555021500022': BarcodeProduct(
      barcode: '9555021500022',
      name: 'Eggs',
      quantity: '1 tray',
      category: IngredientCategory.protein,
      source: 'Local barcode database',
    ),
  };

  static BarcodeProduct? lookup(String barcode) {
    return _products[barcode];
  }
}
