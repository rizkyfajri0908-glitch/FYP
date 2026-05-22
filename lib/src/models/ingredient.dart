enum IngredientCategory {
  vegetable,
  protein,
  dairy,
  grain,
  fruit,
  pantry,
}

enum ExpiryStatus {
  expired,
  today,
  soon,
  fresh,
}

class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.expiryDate,
  });

  final String id;
  final String name;
  final String quantity;
  final IngredientCategory category;
  final DateTime expiryDate;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      category: IngredientCategory.values.byName(json['category'] as String),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category.name,
      'expiryDate': expiryDate.toIso8601String(),
    };
  }

  int get daysUntilExpiry {
    final today = DateTime.now();
    final currentDate = DateTime(today.year, today.month, today.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(currentDate).inDays;
  }

  bool get isExpiringSoon => daysUntilExpiry <= 3;

  ExpiryStatus get expiryStatus {
    if (daysUntilExpiry < 0) {
      return ExpiryStatus.expired;
    }
    if (daysUntilExpiry == 0) {
      return ExpiryStatus.today;
    }
    if (daysUntilExpiry <= 3) {
      return ExpiryStatus.soon;
    }
    return ExpiryStatus.fresh;
  }

  String get expiryMessage {
    return switch (expiryStatus) {
      ExpiryStatus.expired => 'Expired ${daysUntilExpiry.abs()}d ago',
      ExpiryStatus.today => 'Expires today',
      ExpiryStatus.soon => 'Expires in ${daysUntilExpiry}d',
      ExpiryStatus.fresh => 'Fresh for ${daysUntilExpiry}d',
    };
  }
}
