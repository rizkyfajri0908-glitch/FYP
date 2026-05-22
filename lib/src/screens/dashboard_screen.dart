import 'package:flutter/material.dart';

import '../controllers/kitchen_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/section_header.dart';
import '../widgets/status_chip.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.controller});

  final KitchenController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final expiringItems = controller.expiringSoon;
        final mostUrgentItem =
            expiringItems.isEmpty ? null : expiringItems.first;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(
                'Smart Kitchen',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList.list(
                children: [
                  _HeroSummary(
                    expiringCount: expiringItems.length,
                    totalCount: controller.ingredients.length,
                  ),
                  const SizedBox(height: 20),
                  const SectionHeader(
                    title: 'Today Priority',
                    subtitle: 'Use these ingredients first.',
                  ),
                  const SizedBox(height: 12),
                  if (expiringItems.isEmpty)
                    const _EmptyPriorityCard()
                  else
                    ...expiringItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.mintGreen,
                              child: Icon(
                                Icons.schedule,
                                color: AppColors.darkGreen,
                              ),
                            ),
                            title: Text(item.name),
                            subtitle: Text(item.expiryMessage),
                            trailing: StatusChip(
                              days: item.daysUntilExpiry,
                              status: item.expiryStatus,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  const SectionHeader(
                    title: 'Waste Saving Tip',
                    subtitle: 'Plan meals around items expiring within 3 days.',
                  ),
                  const SizedBox(height: 12),
                  _ReminderActionCard(
                    itemName: mostUrgentItem?.name,
                    message: mostUrgentItem == null
                        ? 'No urgent reminders right now. Keep adding expiry dates so the app can warn you early.'
                        : 'Use ${mostUrgentItem.name} first. ${mostUrgentItem.expiryMessage}.',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReminderActionCard extends StatelessWidget {
  const _ReminderActionCard({
    required this.itemName,
    required this.message,
  });

  final String? itemName;
  final String message;

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
              child: Icon(
                itemName == null
                    ? Icons.eco
                    : Icons.notifications_active_outlined,
                color: AppColors.forestGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class _HeroSummary extends StatelessWidget {
  const _HeroSummary({
    required this.expiringCount,
    required this.totalCount,
  });

  final int expiringCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.spa, color: Colors.white, size: 36),
          const SizedBox(height: 16),
          Text(
            '$expiringCount items need attention',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tracking $totalCount ingredients. Cook smarter and buy only what your kitchen needs next.',
            style: const TextStyle(color: Color(0xFFD8F2DD), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _EmptyPriorityCard extends StatelessWidget {
  const _EmptyPriorityCard();

  @override
  Widget build(BuildContext context) {
    return const EmptyStateCard(
      icon: Icons.check_circle_outline,
      message: 'No ingredients are expiring in the next 3 days.',
    );
  }
}
