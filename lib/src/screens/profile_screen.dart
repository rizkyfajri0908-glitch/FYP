import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/kitchen_controller.dart';
import '../models/user_preferences.dart';
import '../theme/app_colors.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.controller,
    this.isFirebaseMode = false,
  });

  final KitchenController controller;
  final bool isFirebaseMode;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _setupGuideDismissedKey = 'profile_setup_guide_dismissed';

  bool _showSetupGuide = true;

  @override
  void initState() {
    super.initState();
    _loadSetupGuidePreference();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final preferences = widget.controller.preferences;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const SectionHeader(
              title: 'Profile Preferences',
              subtitle: 'Personalise reminders and recommendations.',
            ),
            const SizedBox(height: 16),
            _ProfileSummaryCard(preferences: preferences),
            if (_showSetupGuide) ...[
              const SizedBox(height: 12),
              _SetupGuideCard(
                preferences: preferences,
                onDismiss: _dismissSetupGuide,
              ),
            ],
            if (widget.isFirebaseMode) ...[
              const SizedBox(height: 12),
              _AccountSettingsCard(
                controller: widget.controller,
                preferences: preferences,
              ),
            ],
            const SizedBox(height: 12),
            _FoodProfileSection(
              controller: widget.controller,
              preferences: preferences,
            ),
            const SizedBox(height: 12),
            _CookingPreferencesSection(
              controller: widget.controller,
              preferences: preferences,
            ),
            const SizedBox(height: 12),
            _ReminderSettingsSection(
              controller: widget.controller,
              preferences: preferences,
            ),
            const SizedBox(height: 12),
            _ResetPreferencesCard(controller: widget.controller),
          ],
        );
      },
    );
  }

  Future<void> _loadSetupGuidePreference() async {
    final preferences = await SharedPreferences.getInstance();
    final isDismissed = preferences.getBool(_setupGuideDismissedKey) ?? false;
    if (!mounted) {
      return;
    }
    setState(() => _showSetupGuide = !isDismissed);
  }

  Future<void> _dismissSetupGuide() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_setupGuideDismissedKey, true);
    if (!mounted) {
      return;
    }
    setState(() => _showSetupGuide = false);
  }
}

class _SetupGuideCard extends StatelessWidget {
  const _SetupGuideCard({
    required this.preferences,
    required this.onDismiss,
  });

  final UserPreferences preferences;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final completedItems = [
      preferences.dietaryPreference != DietaryPreference.none,
      preferences.householdSize > 1,
      preferences.allergies.isNotEmpty ||
          preferences.avoidedIngredients.isNotEmpty,
      preferences.preferredMealTypes.length < MealType.values.length,
    ].where((item) => item).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Hide setup guide',
                onPressed: onDismiss,
                icon: const Icon(Icons.close),
              ),
            ),
            const Icon(Icons.auto_awesome, color: AppColors.forestGreen),
            const SizedBox(height: 8),
            Text(
              completedItems == 0
                  ? 'Quick Setup'
                  : 'Profile Setup: $completedItems of 4 improved',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              'These settings improve recipes, grocery planning, reminders, and item suggestions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.35),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                Chip(label: Text('Diet')),
                Chip(label: Text('Household')),
                Chip(label: Text('Allergies')),
                Chip(label: Text('Meals')),
                Chip(label: Text('Cooking Preferences')),
                Chip(label: Text('Reminder Settings')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SignOutCard extends StatelessWidget {
  const _SignOutCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: FirebaseAuth.instance.signOut,
          icon: const Icon(Icons.logout),
          label: const Text('Log Out'),
        ),
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final summaryItems = [
      _foodGoalLabel(preferences.foodGoal),
      _dietaryLabel(preferences.dietaryPreference),
      _cookingStyleLabel(preferences.cookingStyle),
      '${preferences.householdSize} people',
      '${preferences.reminderDaysBefore}d reminders',
    ];

    return Card(
      color: AppColors.mintGreen,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.tune, color: AppColors.forestGreen, size: 32),
            const SizedBox(height: 10),
            Text(
              'Your EcoBite Profile',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w900,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              summaryItems.join(' • '),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodProfileSection extends StatelessWidget {
  const _FoodProfileSection({
    required this.controller,
    required this.preferences,
  });

  final KitchenController controller;
  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: 'Food Profile',
      icon: Icons.restaurant,
      children: [
        _SingleChoiceChips<FoodGoal>(
          title: 'Main Goal',
          values: FoodGoal.values,
          selectedValue: preferences.foodGoal,
          labelFor: _foodGoalLabel,
          onChanged: (value) {
            controller.updatePreferences(preferences.copyWith(foodGoal: value));
          },
        ),
        const SizedBox(height: 14),
        _SingleChoiceChips<DietaryPreference>(
          title: 'Dietary Preference',
          values: DietaryPreference.values,
          selectedValue: preferences.dietaryPreference,
          labelFor: _dietaryLabel,
          onChanged: (value) {
            controller.updatePreferences(
              preferences.copyWith(dietaryPreference: value),
            );
          },
        ),
        const SizedBox(height: 14),
        _InlineNumberPreference(
          title: 'Household Size',
          value: preferences.householdSize,
          min: 1,
          max: 8,
          icon: Icons.groups_outlined,
          suffix: 'people',
          onChanged: (value) {
            controller.updatePreferences(
              preferences.copyWith(householdSize: value),
            );
          },
        ),
        const SizedBox(height: 14),
        _EditableChipList(
          title: 'Allergies',
          hint: 'e.g. peanuts, seafood',
          values: preferences.allergies,
          onChanged: (values) {
            controller
                .updatePreferences(preferences.copyWith(allergies: values));
          },
        ),
        const SizedBox(height: 14),
        _EditableChipList(
          title: 'Avoid Ingredients',
          hint: 'e.g. mushrooms, beef',
          values: preferences.avoidedIngredients,
          onChanged: (values) {
            controller.updatePreferences(
              preferences.copyWith(avoidedIngredients: values),
            );
          },
        ),
      ],
    );
  }
}

class _CookingPreferencesSection extends StatelessWidget {
  const _CookingPreferencesSection({
    required this.controller,
    required this.preferences,
  });

  final KitchenController controller;
  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: 'Cooking Preferences',
      icon: Icons.soup_kitchen,
      children: [
        _SingleChoiceChips<CookingStyle>(
          title: 'Cooking Style',
          values: CookingStyle.values,
          selectedValue: preferences.cookingStyle,
          labelFor: _cookingStyleLabel,
          onChanged: (value) {
            controller.updatePreferences(
              preferences.copyWith(cookingStyle: value),
            );
          },
        ),
        const SizedBox(height: 14),
        _SingleChoiceChips<CookingSkillLevel>(
          title: 'Skill Level',
          values: CookingSkillLevel.values,
          selectedValue: preferences.cookingSkillLevel,
          labelFor: _skillLabel,
          onChanged: (value) {
            controller.updatePreferences(
              preferences.copyWith(cookingSkillLevel: value),
            );
          },
        ),
        const SizedBox(height: 14),
        _MultiChoiceChips<CookingTool>(
          title: 'Cooking Tools',
          values: CookingTool.values,
          selectedValues: preferences.cookingTools,
          labelFor: _toolLabel,
          onChanged: (values) {
            controller
                .updatePreferences(preferences.copyWith(cookingTools: values));
          },
        ),
        const SizedBox(height: 14),
        _MultiChoiceChips<MealType>(
          title: 'Preferred Meals',
          values: MealType.values,
          selectedValues: preferences.preferredMealTypes,
          labelFor: _mealTypeLabel,
          onChanged: (values) {
            controller.updatePreferences(
              preferences.copyWith(preferredMealTypes: values),
            );
          },
        ),
        const SizedBox(height: 14),
        _MultiChoiceChips<FoodHabit>(
          title: 'Food Habits',
          values: FoodHabit.values,
          selectedValues: preferences.foodHabits,
          labelFor: _foodHabitLabel,
          onChanged: (values) {
            controller
                .updatePreferences(preferences.copyWith(foodHabits: values));
          },
        ),
      ],
    );
  }
}

class _ReminderSettingsSection extends StatelessWidget {
  const _ReminderSettingsSection({
    required this.controller,
    required this.preferences,
  });

  final KitchenController controller;
  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: 'Reminder Settings',
      icon: Icons.notifications_active_outlined,
      children: [
        _InlineNumberPreference(
          title: 'Reminder Starts',
          value: preferences.reminderDaysBefore,
          min: 1,
          max: 7,
          icon: Icons.event_available_outlined,
          suffix: 'days before expiry',
          onChanged: (value) {
            controller.updatePreferences(
              preferences.copyWith(reminderDaysBefore: value),
            );
          },
        ),
        const SizedBox(height: 12),
        _InlineNumberPreference(
          title: 'Notification Frequency',
          value: preferences.notificationRepeatCount,
          min: 1,
          max: 5,
          icon: Icons.repeat_outlined,
          suffix: 'reminders before stopping',
          onChanged: (value) {
            controller.updatePreferences(
              preferences.copyWith(notificationRepeatCount: value),
            );
          },
        ),
        const SizedBox(height: 12),
        _InlineNumberPreference(
          title: 'Reminder Time',
          value: preferences.preferredReminderHour,
          min: 0,
          max: 23,
          icon: Icons.schedule,
          suffix: ':00',
          onChanged: (value) {
            controller.updatePreferences(
              preferences.copyWith(preferredReminderHour: value),
            );
          },
        ),
      ],
    );
  }
}

class _ResetPreferencesCard extends StatelessWidget {
  const _ResetPreferencesCard({required this.controller});

  final KitchenController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Preference Controls',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmReset(context),
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Reset Preferences?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 18),
              const Text(
                'This will return profile, cooking, and reminder settings to the EcoBite defaults.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.35),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldReset == true) {
      await controller.updatePreferences(UserPreferences.defaults());
    }
  }
}

class _AccountSettingsCard extends StatefulWidget {
  const _AccountSettingsCard({
    required this.controller,
    required this.preferences,
  });

  final KitchenController controller;
  final UserPreferences preferences;

  @override
  State<_AccountSettingsCard> createState() => _AccountSettingsCardState();
}

class _AccountSettingsCardState extends State<_AccountSettingsCard> {
  String? _message;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No email found';

    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: const Icon(
          Icons.manage_accounts_outlined,
          color: AppColors.forestGreen,
        ),
        title: Text(
          'Account Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        children: [
          _AccountRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email,
          ),
          const SizedBox(height: 10),
          const _AccountRow(
            icon: Icons.lock_outline,
            label: 'Password',
            value: '********',
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: user == null ? null : _showChangePasswordDialog,
              icon: const Icon(Icons.password),
              label: const Text('Change Password'),
            ),
          ),
          if (_message != null) ...[
            const SizedBox(height: 10),
            Text(
              _message!,
              style: const TextStyle(
                color: AppColors.forestGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 24),
          const _SignOutCard(),
        ],
      ),
    );
  }

  Future<void> _showChangePasswordDialog() async {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if ((value ?? '').length < 6) {
                      return 'Use at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: Icon(Icons.lock_reset),
                  ),
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    if (shouldUpdate != true) {
      return;
    }

    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(
        newPasswordController.text,
      );
      if (!mounted) {
        return;
      }
      setState(() => _message = 'Password updated successfully.');
    } on FirebaseAuthException catch (error) {
      final email = FirebaseAuth.instance.currentUser?.email;
      if (error.code == 'requires-recent-login' && email != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        if (!mounted) {
          return;
        }
        setState(
          () => _message =
              'For security, Firebase needs recent login. A reset email was sent.',
        );
      } else {
        if (!mounted) {
          return;
        }
        setState(() => _message = error.message ?? 'Password update failed.');
      }
    }
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.forestGreen),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineNumberPreference extends StatelessWidget {
  const _InlineNumberPreference({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.icon,
    required this.suffix,
    required this.onChanged,
  });

  final String title;
  final int value;
  final int min;
  final int max;
  final IconData icon;
  final String suffix;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.leafGreen),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.forestGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  '$value $suffix',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Decrease',
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          const SizedBox(width: 4),
          IconButton.filledTonal(
            tooltip: 'Increase',
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Icon(icon, color: AppColors.forestGreen),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        children: children,
      ),
    );
  }
}

class _SingleChoiceChips<T> extends StatelessWidget {
  const _SingleChoiceChips({
    required this.title,
    required this.values,
    required this.selectedValue,
    required this.labelFor,
    required this.onChanged,
  });

  final String title;
  final List<T> values;
  final T selectedValue;
  final String Function(T value) labelFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return _PreferenceBlock(
      title: title,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values
            .map(
              (value) => ChoiceChip(
                label: Text(labelFor(value)),
                selected: value == selectedValue,
                onSelected: (_) => onChanged(value),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MultiChoiceChips<T> extends StatelessWidget {
  const _MultiChoiceChips({
    required this.title,
    required this.values,
    required this.selectedValues,
    required this.labelFor,
    required this.onChanged,
  });

  final String title;
  final List<T> values;
  final List<T> selectedValues;
  final String Function(T value) labelFor;
  final ValueChanged<List<T>> onChanged;

  @override
  Widget build(BuildContext context) {
    return _PreferenceBlock(
      title: title,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values
            .map(
              (value) => FilterChip(
                label: Text(labelFor(value)),
                selected: selectedValues.contains(value),
                onSelected: (isSelected) {
                  final nextValues = [...selectedValues];
                  if (isSelected) {
                    nextValues.add(value);
                  } else {
                    nextValues.remove(value);
                  }
                  onChanged(nextValues.isEmpty ? [value] : nextValues);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _EditableChipList extends StatefulWidget {
  const _EditableChipList({
    required this.title,
    required this.hint,
    required this.values,
    required this.onChanged,
  });

  final String title;
  final String hint;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_EditableChipList> createState() => _EditableChipListState();
}

class _EditableChipListState extends State<_EditableChipList> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PreferenceBlock(
      title: widget.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...widget.values.map(
                (value) => InputChip(
                  label: Text(value),
                  onDeleted: () {
                    widget.onChanged(
                      widget.values.where((item) => item != value).toList(),
                    );
                  },
                ),
              ),
              if (widget.values.isEmpty)
                const Text(
                  'None added',
                  style: TextStyle(color: AppColors.muted),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addValue(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: 'Add',
                onPressed: _addValue,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addValue() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }

    final existingValues =
        widget.values.map((item) => item.toLowerCase()).toSet();
    if (!existingValues.contains(value.toLowerCase())) {
      widget.onChanged([...widget.values, value]);
    }
    _controller.clear();
  }
}

class _PreferenceBlock extends StatelessWidget {
  const _PreferenceBlock({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

String _dietaryLabel(DietaryPreference preference) {
  return switch (preference) {
    DietaryPreference.none => 'None',
    DietaryPreference.halal => 'Halal',
    DietaryPreference.vegetarian => 'Vegetarian',
    DietaryPreference.dairyFree => 'Dairy-free',
  };
}

String _cookingStyleLabel(CookingStyle style) {
  return switch (style) {
    CookingStyle.quick => 'Quick',
    CookingStyle.budget => 'Budget',
    CookingStyle.healthy => 'Healthy',
  };
}

String _foodGoalLabel(FoodGoal goal) {
  return switch (goal) {
    FoodGoal.reduceWaste => 'Reduce waste',
    FoodGoal.saveMoney => 'Save money',
    FoodGoal.eatHealthier => 'Eat healthier',
    FoodGoal.cookFaster => 'Cook faster',
  };
}

String _skillLabel(CookingSkillLevel skill) {
  return switch (skill) {
    CookingSkillLevel.beginner => 'Beginner',
    CookingSkillLevel.intermediate => 'Intermediate',
    CookingSkillLevel.confident => 'Confident',
  };
}

String _toolLabel(CookingTool tool) {
  return switch (tool) {
    CookingTool.stove => 'Stove',
    CookingTool.oven => 'Oven',
    CookingTool.microwave => 'Microwave',
    CookingTool.blender => 'Blender',
    CookingTool.airFryer => 'Air fryer',
  };
}

String _mealTypeLabel(MealType mealType) {
  return switch (mealType) {
    MealType.breakfast => 'Breakfast',
    MealType.lunch => 'Lunch',
    MealType.dinner => 'Dinner',
    MealType.snacks => 'Snacks',
  };
}

String _foodHabitLabel(FoodHabit habit) {
  return switch (habit) {
    FoodHabit.oftenHasLeftovers => 'Often has leftovers',
    FoodHabit.overbuysVegetables => 'Overbuys vegetables',
    FoodHabit.forgetExpiryDates => 'Forgets expiry dates',
  };
}
