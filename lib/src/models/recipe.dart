class Recipe {
  const Recipe({
    required this.title,
    required this.description,
    required this.matchingIngredients,
    required this.minutes,
  });

  final String title;
  final String description;
  final List<String> matchingIngredients;
  final int minutes;
}
