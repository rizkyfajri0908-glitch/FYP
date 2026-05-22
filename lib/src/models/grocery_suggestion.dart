class GrocerySuggestion {
  const GrocerySuggestion({
    required this.name,
    required this.reason,
    required this.priority,
    this.source = GrocerySource.staple,
  });

  final String name;
  final String reason;
  final GroceryPriority priority;
  final GrocerySource source;
}

enum GroceryPriority { high, medium, low }

enum GrocerySource { staple, recipe }
