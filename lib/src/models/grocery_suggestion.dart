class GrocerySuggestion {
  const GrocerySuggestion({
    required this.name,
    required this.reason,
    required this.priority,
    this.quantity = '1 item',
    this.source = GrocerySource.staple,
    this.tags = const [],
  });

  final String name;
  final String reason;
  final GroceryPriority priority;
  final String quantity;
  final GrocerySource source;
  final List<String> tags;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reason': reason,
      'priority': priority.name,
      'quantity': quantity,
      'source': source.name,
      'tags': tags,
    };
  }

  factory GrocerySuggestion.fromJson(Map<String, dynamic> json) {
    return GrocerySuggestion(
      name: json['name'] as String,
      reason: json['reason'] as String? ?? 'Added manually.',
      priority: GroceryPriority.values.byName(
        json['priority'] as String? ?? GroceryPriority.medium.name,
      ),
      quantity: json['quantity'] as String? ?? '1 item',
      source: GrocerySource.values.byName(
        json['source'] as String? ?? GrocerySource.custom.name,
      ),
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
    );
  }
}

enum GroceryPriority { high, medium, low }

enum GrocerySource { staple, recipe, expiryReplacement, frequent, custom }
