import 'package:flutter/material.dart';

import '../controllers/kitchen_controller.dart';
import 'assistant_screen.dart';
import 'dashboard_screen.dart';
import 'grocery_screen.dart';
import 'inventory_screen.dart';
import 'profile_screen.dart';
import 'recipes_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    this.userId,
    this.isFirebaseMode = false,
  });

  final String? userId;
  final bool isFirebaseMode;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  late final KitchenController _kitchenController;

  @override
  void initState() {
    super.initState();
    _kitchenController = KitchenController(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    const destinations = [
      _AppDestination(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Home',
      ),
      _AppDestination(
        icon: Icons.kitchen_outlined,
        selectedIcon: Icons.kitchen,
        label: 'Items',
      ),
      _AppDestination(
        icon: Icons.restaurant_menu_outlined,
        selectedIcon: Icons.restaurant_menu,
        label: 'Recipes',
      ),
      _AppDestination(
        icon: Icons.chat_bubble_outline,
        selectedIcon: Icons.chat_bubble,
        label: 'AI',
      ),
      _AppDestination(
        icon: Icons.shopping_bag_outlined,
        selectedIcon: Icons.shopping_bag,
        label: 'Shop',
      ),
      _AppDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    final screens = [
      DashboardScreen(controller: _kitchenController),
      InventoryScreen(controller: _kitchenController),
      RecipesScreen(controller: _kitchenController),
      AssistantScreen(controller: _kitchenController),
      GroceryScreen(controller: _kitchenController),
      ProfileScreen(
        controller: _kitchenController,
        isFirebaseMode: widget.isFirebaseMode,
      ),
    ];

    final content = SafeArea(
      child: ListenableBuilder(
        listenable: _kitchenController,
        builder: (context, _) {
          if (_kitchenController.isLoading) {
            return const _LoadingKitchenView();
          }

          return screens[_selectedIndex];
        },
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectDestination,
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: Icon(destination.icon),
                          selectedIcon: Icon(destination.selectedIcon),
                          label: Text(destination.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            ),
          );
        }

        return Scaffold(
          body: content,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectDestination,
            destinations: destinations
                .map(
                  (destination) => NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: destination.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _selectDestination(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    _kitchenController.dispose();
    super.dispose();
  }
}

class _AppDestination {
  const _AppDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _LoadingKitchenView extends StatelessWidget {
  const _LoadingKitchenView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
