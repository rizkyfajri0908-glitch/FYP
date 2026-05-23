import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/kitchen_controller.dart';
import '../models/ingredient.dart';
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
              centerTitle: true,
              pinned: true,
              title: Text(
                'EcoBite',
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
                  _WasteSavingTipCard(urgentItem: mostUrgentItem),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WasteSavingTipCard extends StatefulWidget {
  const _WasteSavingTipCard({required this.urgentItem});

  final Ingredient? urgentItem;

  @override
  State<_WasteSavingTipCard> createState() => _WasteSavingTipCardState();
}

class _WasteSavingTipCardState extends State<_WasteSavingTipCard> {
  static const _tips = [
    'Store older ingredients at the front of your fridge so you use them first.',
    'Plan meals around items that expire within the next 1 to 3 days.',
    'Freeze extra portions before they go bad.',
    'Check your kitchen inventory before buying groceries.',
    'Label leftovers with the date they were cooked.',
    'Use a shopping list to avoid buying ingredients you already have.',
    'Keep fruits and vegetables dry before storing them to slow spoilage.',
    'Cook in smaller portions if you often throw away leftovers.',
    'Turn soft vegetables into soup, fried rice, or stir-fry.',
    'Use clear containers so leftovers are easier to notice.',
    'Overripe bananas can be used for smoothies, pancakes, or banana bread.',
    'Stale bread can become toast, breadcrumbs, croutons, or bread pudding.',
    'Soft tomatoes can be cooked into pasta sauce, soup, or curry base.',
    'Leftover rice is best used for fried rice, rice porridge, or rice bowls.',
    'Wilted spinach can still be used in omelettes, pasta, soup, or stir-fry.',
    'Extra milk close to expiry can be used in pancakes, oatmeal, pasta sauce, or scrambled eggs.',
    'Carrot peels and onion ends can be saved for homemade vegetable stock.',
    'Cooked chicken leftovers can be used in sandwiches, fried rice, wraps, or soup.',
    'Potatoes starting to sprout should be trimmed and cooked soon if still firm.',
    'Herbs can be frozen with oil or water in an ice cube tray.',
  ];

  Timer? _timer;
  int _tipIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 7), (_) => _showNextTip());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _WasteSavingTipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.urgentItem?.id != widget.urgentItem?.id) {
      setState(() => _tipIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tip = _currentTip;
    final hasUrgentItem = widget.urgentItem != null && _tipIndex == 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.mintGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                hasUrgentItem ? Icons.notifications_active_outlined : Icons.eco,
                color: AppColors.forestGreen,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                tip,
                key: ValueKey(tip),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.ink,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _showNextTip,
              icon: const Icon(Icons.navigate_next),
              label: const Text('Next Tip'),
            ),
          ],
        ),
      ),
    );
  }

  String get _currentTip {
    final urgentItem = widget.urgentItem;

    if (urgentItem == null) {
      return _tips[_tipIndex % _tips.length];
    }

    if (_tipIndex == 0) {
      return 'Use ${urgentItem.name} first. ${urgentItem.expiryMessage}.';
    }

    return _tips[(_tipIndex - 1) % _tips.length];
  }

  void _showNextTip() {
    if (!mounted) {
      return;
    }

    final totalTips =
        widget.urgentItem == null ? _tips.length : _tips.length + 1;
    setState(() => _tipIndex = (_tipIndex + 1) % totalTips);
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ecobite_logo.png',
            width: 56,
            height: 56,
          ),
          const SizedBox(height: 16),
          Text(
            '$expiringCount items need attention',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tracking $totalCount ingredients. Cook smarter and buy only what your kitchen needs next.',
            style: const TextStyle(color: Color(0xFFD8F2DD), height: 1.4),
            textAlign: TextAlign.center,
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
