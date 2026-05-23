class UserPreferences {
  const UserPreferences({
    required this.dietaryPreference,
    required this.cookingStyle,
    required this.householdSize,
    required this.reminderDaysBefore,
    required this.notificationRepeatCount,
    this.foodGoal = FoodGoal.reduceWaste,
    this.allergies = const [],
    this.avoidedIngredients = const [],
    this.cookingSkillLevel = CookingSkillLevel.beginner,
    this.cookingTools = const [CookingTool.stove, CookingTool.microwave],
    this.preferredMealTypes = const [
      MealType.breakfast,
      MealType.lunch,
      MealType.dinner,
    ],
    this.foodHabits = const [FoodHabit.forgetExpiryDates],
    this.preferredReminderHour = 9,
  });

  factory UserPreferences.defaults() {
    return const UserPreferences(
      dietaryPreference: DietaryPreference.none,
      cookingStyle: CookingStyle.quick,
      householdSize: 1,
      reminderDaysBefore: 3,
      notificationRepeatCount: 2,
      foodGoal: FoodGoal.reduceWaste,
      cookingSkillLevel: CookingSkillLevel.beginner,
      cookingTools: [CookingTool.stove, CookingTool.microwave],
      preferredMealTypes: [
        MealType.breakfast,
        MealType.lunch,
        MealType.dinner,
      ],
      foodHabits: [FoodHabit.forgetExpiryDates],
      preferredReminderHour: 9,
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      dietaryPreference:
          _enumByName(DietaryPreference.values, json['dietaryPreference']) ??
              DietaryPreference.none,
      cookingStyle: _enumByName(CookingStyle.values, json['cookingStyle']) ??
          CookingStyle.quick,
      householdSize: json['householdSize'] as int? ?? 1,
      reminderDaysBefore: json['reminderDaysBefore'] as int? ?? 3,
      notificationRepeatCount: json['notificationRepeatCount'] as int? ?? 2,
      foodGoal: _enumByName(FoodGoal.values, json['foodGoal']) ??
          FoodGoal.reduceWaste,
      allergies: _stringList(json['allergies']),
      avoidedIngredients: _stringList(json['avoidedIngredients']),
      cookingSkillLevel:
          _enumByName(CookingSkillLevel.values, json['cookingSkillLevel']) ??
              CookingSkillLevel.beginner,
      cookingTools: _enumList(
        CookingTool.values,
        json['cookingTools'],
        const [CookingTool.stove, CookingTool.microwave],
      ),
      preferredMealTypes: _enumList(
        MealType.values,
        json['preferredMealTypes'],
        const [MealType.breakfast, MealType.lunch, MealType.dinner],
      ),
      foodHabits: _enumList(
        FoodHabit.values,
        json['foodHabits'],
        const [FoodHabit.forgetExpiryDates],
      ),
      preferredReminderHour: json['preferredReminderHour'] as int? ?? 9,
    );
  }

  final DietaryPreference dietaryPreference;
  final CookingStyle cookingStyle;
  final int householdSize;
  final int reminderDaysBefore;
  final int notificationRepeatCount;
  final FoodGoal foodGoal;
  final List<String> allergies;
  final List<String> avoidedIngredients;
  final CookingSkillLevel cookingSkillLevel;
  final List<CookingTool> cookingTools;
  final List<MealType> preferredMealTypes;
  final List<FoodHabit> foodHabits;
  final int preferredReminderHour;

  Map<String, dynamic> toJson() {
    return {
      'dietaryPreference': dietaryPreference.name,
      'cookingStyle': cookingStyle.name,
      'householdSize': householdSize,
      'reminderDaysBefore': reminderDaysBefore,
      'notificationRepeatCount': notificationRepeatCount,
      'foodGoal': foodGoal.name,
      'allergies': allergies,
      'avoidedIngredients': avoidedIngredients,
      'cookingSkillLevel': cookingSkillLevel.name,
      'cookingTools': cookingTools.map((tool) => tool.name).toList(),
      'preferredMealTypes':
          preferredMealTypes.map((meal) => meal.name).toList(),
      'foodHabits': foodHabits.map((habit) => habit.name).toList(),
      'preferredReminderHour': preferredReminderHour,
    };
  }

  UserPreferences copyWith({
    DietaryPreference? dietaryPreference,
    CookingStyle? cookingStyle,
    int? householdSize,
    int? reminderDaysBefore,
    int? notificationRepeatCount,
    FoodGoal? foodGoal,
    List<String>? allergies,
    List<String>? avoidedIngredients,
    CookingSkillLevel? cookingSkillLevel,
    List<CookingTool>? cookingTools,
    List<MealType>? preferredMealTypes,
    List<FoodHabit>? foodHabits,
    int? preferredReminderHour,
  }) {
    return UserPreferences(
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      cookingStyle: cookingStyle ?? this.cookingStyle,
      householdSize: householdSize ?? this.householdSize,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
      notificationRepeatCount:
          notificationRepeatCount ?? this.notificationRepeatCount,
      foodGoal: foodGoal ?? this.foodGoal,
      allergies: allergies ?? this.allergies,
      avoidedIngredients: avoidedIngredients ?? this.avoidedIngredients,
      cookingSkillLevel: cookingSkillLevel ?? this.cookingSkillLevel,
      cookingTools: cookingTools ?? this.cookingTools,
      preferredMealTypes: preferredMealTypes ?? this.preferredMealTypes,
      foodHabits: foodHabits ?? this.foodHabits,
      preferredReminderHour:
          preferredReminderHour ?? this.preferredReminderHour,
    );
  }

  static T? _enumByName<T extends Enum>(List<T> values, Object? name) {
    if (name is! String) {
      return null;
    }
    for (final value in values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }

  static List<T> _enumList<T extends Enum>(
    List<T> values,
    Object? names,
    List<T> fallback,
  ) {
    if (names is! List) {
      return fallback;
    }

    final parsed =
        names.map((name) => _enumByName(values, name)).whereType<T>().toList();

    return parsed.isEmpty ? fallback : parsed;
  }

  static List<String> _stringList(Object? values) {
    if (values is! List) {
      return const [];
    }

    return values
        .map((value) => value.toString().trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }
}

enum DietaryPreference {
  none,
  halal,
  vegetarian,
  dairyFree,
}

enum CookingStyle {
  quick,
  budget,
  healthy,
}

enum FoodGoal {
  reduceWaste,
  saveMoney,
  eatHealthier,
  cookFaster,
}

enum CookingSkillLevel {
  beginner,
  intermediate,
  confident,
}

enum CookingTool {
  stove,
  oven,
  microwave,
  blender,
  airFryer,
}

enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks,
}

enum FoodHabit {
  oftenHasLeftovers,
  overbuysVegetables,
  forgetExpiryDates,
}
