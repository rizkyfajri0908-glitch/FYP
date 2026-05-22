class UserPreferences {
  const UserPreferences({
    required this.dietaryPreference,
    required this.cookingStyle,
    required this.householdSize,
    required this.reminderDaysBefore,
  });

  factory UserPreferences.defaults() {
    return const UserPreferences(
      dietaryPreference: DietaryPreference.none,
      cookingStyle: CookingStyle.quick,
      householdSize: 1,
      reminderDaysBefore: 3,
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      dietaryPreference:
          DietaryPreference.values.byName(json['dietaryPreference'] as String),
      cookingStyle: CookingStyle.values.byName(json['cookingStyle'] as String),
      householdSize: json['householdSize'] as int,
      reminderDaysBefore: json['reminderDaysBefore'] as int,
    );
  }

  final DietaryPreference dietaryPreference;
  final CookingStyle cookingStyle;
  final int householdSize;
  final int reminderDaysBefore;

  Map<String, dynamic> toJson() {
    return {
      'dietaryPreference': dietaryPreference.name,
      'cookingStyle': cookingStyle.name,
      'householdSize': householdSize,
      'reminderDaysBefore': reminderDaysBefore,
    };
  }

  UserPreferences copyWith({
    DietaryPreference? dietaryPreference,
    CookingStyle? cookingStyle,
    int? householdSize,
    int? reminderDaysBefore,
  }) {
    return UserPreferences(
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      cookingStyle: cookingStyle ?? this.cookingStyle,
      householdSize: householdSize ?? this.householdSize,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
    );
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
