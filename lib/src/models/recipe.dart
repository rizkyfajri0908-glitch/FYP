class Recipe {
  const Recipe({
    this.id = '',
    required this.title,
    required this.description,
    required this.matchingIngredients,
    required this.minutes,
    this.steps = const [],
    this.tags = const [],
    this.dietary = 'none',
    this.category = 'balanced',
    this.sourceName = '',
    this.sourceUrl = '',
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String,
      matchingIngredients: List<String>.from(
        json['matchingIngredients'] as List<dynamic>,
      ),
      minutes: json['minutes'] as int,
      steps: List<String>.from(json['steps'] as List<dynamic>? ?? []),
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
      dietary: json['dietary'] as String? ?? 'none',
      category: json['category'] as String? ?? 'balanced',
      sourceName: json['sourceName'] as String? ?? '',
      sourceUrl: json['sourceUrl'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String description;
  final List<String> matchingIngredients;
  final int minutes;
  final List<String> steps;
  final List<String> tags;
  final String dietary;
  final String category;
  final String sourceName;
  final String sourceUrl;

  String get displaySourceName {
    if (_hasCustomSource) {
      return sourceName;
    }
    return _defaultSource.name;
  }

  String get referenceUrl {
    if (_hasCustomSource && sourceUrl.isNotEmpty) {
      return sourceUrl;
    }

    return _defaultSource.searchUrl(title);
  }

  bool get _hasCustomSource {
    if (sourceName.isEmpty) {
      return false;
    }

    final isOldDefault = sourceName == 'BBC Good Food' &&
        (sourceUrl.isEmpty || sourceUrl.contains('/search?q='));
    return !isOldDefault;
  }

  _RecipeSource get _defaultSource {
    final sourceIndex = title.codeUnits.fold<int>(
          0,
          (sum, codeUnit) => sum + codeUnit,
        ) %
        _recipeSources.length;
    return _recipeSources[sourceIndex];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'matchingIngredients': matchingIngredients,
      'minutes': minutes,
      'steps': steps,
      'tags': tags,
      'dietary': dietary,
      'category': category,
      'sourceName': displaySourceName,
      'sourceUrl': referenceUrl,
    };
  }
}

class _RecipeSource {
  const _RecipeSource({
    required this.name,
    required this.urlBuilder,
  });

  final String name;
  final String Function(String title) urlBuilder;

  String searchUrl(String title) {
    return urlBuilder(Uri.encodeComponent(title));
  }
}

final _recipeSources = [
  _RecipeSource(
    name: 'BBC Good Food',
    urlBuilder: (query) => 'https://www.bbcgoodfood.com/search?q=$query',
  ),
  _RecipeSource(
    name: 'Allrecipes',
    urlBuilder: (query) => 'https://www.allrecipes.com/search?q=$query',
  ),
  _RecipeSource(
    name: 'EatingWell',
    urlBuilder: (query) => 'https://www.eatingwell.com/search?q=$query',
  ),
  _RecipeSource(
    name: 'Budget Bytes',
    urlBuilder: (query) => 'https://www.budgetbytes.com/?s=$query',
  ),
  _RecipeSource(
    name: 'The Kitchn',
    urlBuilder: (query) => 'https://www.thekitchn.com/search?q=$query',
  ),
  _RecipeSource(
    name: 'Taste',
    urlBuilder: (query) => 'https://www.taste.com.au/search-recipes/?q=$query',
  ),
];
