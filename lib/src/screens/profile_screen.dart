import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/kitchen_controller.dart';
import '../models/user_preferences.dart';
import '../theme/app_colors.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.controller,
    this.isFirebaseMode = false,
  });

  final KitchenController controller;
  final bool isFirebaseMode;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final preferences = controller.preferences;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const SectionHeader(
              title: 'Profile Preferences',
              subtitle: 'Personalise reminders and recommendations.',
            ),
            const SizedBox(height: 16),
            _PreferenceCard(
              title: 'Dietary Preference',
              icon: Icons.restaurant,
              child: SegmentedButton<DietaryPreference>(
                selected: {preferences.dietaryPreference},
                onSelectionChanged: (selection) {
                  controller.updatePreferences(
                    preferences.copyWith(dietaryPreference: selection.first),
                  );
                },
                segments: const [
                  ButtonSegment(
                    value: DietaryPreference.none,
                    label: Text('None'),
                  ),
                  ButtonSegment(
                    value: DietaryPreference.halal,
                    label: Text('Halal'),
                  ),
                  ButtonSegment(
                    value: DietaryPreference.vegetarian,
                    label: Text('Veg'),
                  ),
                  ButtonSegment(
                    value: DietaryPreference.dairyFree,
                    label: Text('Dairy-free'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _PreferenceCard(
              title: 'Cooking Style',
              icon: Icons.soup_kitchen,
              child: SegmentedButton<CookingStyle>(
                selected: {preferences.cookingStyle},
                onSelectionChanged: (selection) {
                  controller.updatePreferences(
                    preferences.copyWith(cookingStyle: selection.first),
                  );
                },
                segments: const [
                  ButtonSegment(
                    value: CookingStyle.quick,
                    icon: Icon(Icons.timer_outlined),
                    label: Text('Quick'),
                  ),
                  ButtonSegment(
                    value: CookingStyle.budget,
                    icon: Icon(Icons.savings_outlined),
                    label: Text('Budget'),
                  ),
                  ButtonSegment(
                    value: CookingStyle.healthy,
                    icon: Icon(Icons.eco_outlined),
                    label: Text('Healthy'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _NumberPreferenceCard(
              title: 'Household Size',
              value: preferences.householdSize,
              min: 1,
              max: 8,
              icon: Icons.groups_outlined,
              onChanged: (value) {
                controller.updatePreferences(
                  preferences.copyWith(householdSize: value),
                );
              },
            ),
            const SizedBox(height: 12),
            _NumberPreferenceCard(
              title: 'Reminder Days Before Expiry',
              value: preferences.reminderDaysBefore,
              min: 1,
              max: 7,
              icon: Icons.notifications_active_outlined,
              onChanged: (value) {
                controller.updatePreferences(
                  preferences.copyWith(reminderDaysBefore: value),
                );
              },
            ),
            const SizedBox(height: 16),
            _ProfileSummary(preferences: preferences),
            const SizedBox(height: 12),
            _NotificationTestCard(controller: controller),
            if (isFirebaseMode) ...[
              const SizedBox(height: 12),
              const _SignOutCard(),
            ],
          ],
        );
      },
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

class _NotificationTestCard extends StatelessWidget {
  const _NotificationTestCard({required this.controller});

  final KitchenController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PreferenceTitle(
              title: 'Notification Check',
              icon: Icons.notifications_active_outlined,
            ),
            const SizedBox(height: 8),
            const Text(
              'Send a test reminder to confirm phone notification permission.',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: controller.showTestNotification,
              icon: const Icon(Icons.notifications),
              label: const Text('Send Test Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PreferenceTitle(title: title, icon: icon),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberPreferenceCard extends StatelessWidget {
  const _NumberPreferenceCard({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.icon,
    required this.onChanged,
  });

  final String title;
  final int value;
  final int min;
  final int max;
  final IconData icon;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PreferenceTitle(title: title, icon: icon),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton.filledTonal(
                  tooltip: 'Decrease',
                  onPressed: value > min ? () => onChanged(value - 1) : null,
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$value',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Increase',
                  onPressed: value < max ? () => onChanged(value + 1) : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferenceTitle extends StatelessWidget {
  const _PreferenceTitle({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.forestGreen),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.mintGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: AppColors.forestGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${_dietLabel(preferences.dietaryPreference)} meals, '
                '${_styleLabel(preferences.cookingStyle)} cooking, '
                '${preferences.reminderDaysBefore}d expiry reminders.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dietLabel(DietaryPreference preference) {
    return switch (preference) {
      DietaryPreference.none => 'Flexible',
      DietaryPreference.halal => 'Halal',
      DietaryPreference.vegetarian => 'Vegetarian',
      DietaryPreference.dairyFree => 'Dairy-free',
    };
  }

  String _styleLabel(CookingStyle style) {
    return switch (style) {
      CookingStyle.quick => 'quick',
      CookingStyle.budget => 'budget',
      CookingStyle.healthy => 'healthy',
    };
  }
}
