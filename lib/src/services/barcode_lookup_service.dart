import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  BarcodeLookupService({
    FirebaseFirestore? firestore,
    http.Client? client,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _client = client ?? http.Client();

  final FirebaseFirestore _firestore;
  final http.Client _client;

  Future<BarcodeProduct?> lookup(String code) async {
    final normalizedCode = code.trim();
    if (normalizedCode.isEmpty) {
      return null;
    }

    final firestoreProduct = await _lookupFirestoreProduct(normalizedCode);
    if (firestoreProduct != null) {
      return firestoreProduct;
    }

    final localProduct = _LocalBarcodeDatabase.lookup(normalizedCode);
    if (localProduct != null) {
      return localProduct;
    }

    if (!RegExp(r'^\d{6,14}$').hasMatch(normalizedCode)) {
      return null;
    }

    return _lookupOpenFoodFacts(normalizedCode);
  }

  Future<BarcodeProduct?> _lookupFirestoreProduct(String code) async {
    try {
      final productId = code.trim().toUpperCase();
      final snapshot =
          await _firestore.collection('products').doc(productId).get();
      final data = snapshot.data();

      if (data == null) {
        return null;
      }

      final name = _firstText([data['name'], data['productName']]);
      if (name == null) {
        return null;
      }

      return BarcodeProduct(
        barcode: productId,
        name: name,
        quantity: _quantityText(data['quantity']),
        category: _categoryFromValue(data['category']),
        source: 'EcoBite product database',
      );
    } catch (_) {
      return null;
    }
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

  String _quantityText(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) {
      return '1 item';
    }
    return text;
  }

  static IngredientCategory _categoryFromValue(dynamic value) {
    final category = value?.toString().trim().toLowerCase();
    if (category == null || category.isEmpty) {
      return IngredientCategory.pantry;
    }

    for (final option in IngredientCategory.values) {
      if (option.name == category) {
        return option;
      }
    }

    return _categoryFromText(category);
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
    'CABBAGE001': BarcodeProduct(
      barcode: 'CABBAGE001',
      name: 'Cabbage',
      quantity: '1',
      category: IngredientCategory.vegetable,
      source: 'EcoBite demo product database',
    ),
    'CHICKENBREAST001': BarcodeProduct(
      barcode: 'CHICKENBREAST001',
      name: 'Chicken Breast',
      quantity: '1',
      category: IngredientCategory.protein,
      source: 'EcoBite demo product database',
    ),
    'FLOUR001': BarcodeProduct(
      barcode: 'FLOUR001',
      name: 'Flour',
      quantity: '1',
      category: IngredientCategory.pantry,
      source: 'EcoBite demo product database',
    ),
    'CARROT001': BarcodeProduct(
      barcode: 'CARROT001',
      name: 'Carrot',
      quantity: '1',
      category: IngredientCategory.vegetable,
      source: 'EcoBite demo product database',
    ),
    'BISCUIT001': BarcodeProduct(
      barcode: 'BISCUIT001',
      name: 'Biscuit',
      quantity: '1',
      category: IngredientCategory.pantry,
      source: 'EcoBite demo product database',
    ),
    'STEAK001': BarcodeProduct(
      barcode: 'STEAK001',
      name: 'Steak',
      quantity: '1',
      category: IngredientCategory.protein,
      source: 'EcoBite demo product database',
    ),
    'ELBOWPASTA001': BarcodeProduct(
      barcode: 'ELBOWPASTA001',
      name: 'Elbow Pasta',
      quantity: '1',
      category: IngredientCategory.grain,
      source: 'EcoBite demo product database',
    ),
    'CHOCOLATEMILK001': BarcodeProduct(
      barcode: 'CHOCOLATEMILK001',
      name: 'Chocolate Milk',
      quantity: '1',
      category: IngredientCategory.dairy,
      source: 'EcoBite demo product database',
    ),
    'RICE001': BarcodeProduct(
      barcode: 'RICE001',
      name: 'Rice',
      quantity: '1',
      category: IngredientCategory.grain,
      source: 'EcoBite demo product database',
    ),
    'BREAD001': BarcodeProduct(
      barcode: 'BREAD001',
      name: 'Bread',
      quantity: '1',
      category: IngredientCategory.grain,
      source: 'EcoBite demo product database',
    ),
    'CEREAL001': BarcodeProduct(
      barcode: 'CEREAL001',
      name: 'Cereal',
      quantity: '1',
      category: IngredientCategory.grain,
      source: 'EcoBite demo product database',
    ),
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
