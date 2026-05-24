import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth_gate.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

class SmartKitchenApp extends StatefulWidget {
  const SmartKitchenApp({
    super.key,
    this.isFirebaseReady = false,
  });

  final bool isFirebaseReady;

  static ThemeModeController themeControllerOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ThemeModeControllerScope>();
    assert(scope != null, 'Theme controller not found in context.');
    return scope!.controller;
  }

  @override
  State<SmartKitchenApp> createState() => _SmartKitchenAppState();
}

class _SmartKitchenAppState extends State<SmartKitchenApp> {
  late final ThemeModeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeModeController()..load();
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeModeControllerScope(
      controller: _themeController,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeController,
        builder: (context, themeMode, _) {
          return MaterialApp(
            title: 'EcoBite',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: widget.isFirebaseReady ? const AuthGate() : const HomeShell(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }
}

class ThemeModeController extends ValueNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.light);

  static const _themeModeKey = 'theme_mode';

  bool get isDarkMode => value == ThemeMode.dark;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final savedMode = preferences.getString(_themeModeKey);
    value = savedMode == ThemeMode.dark.name ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeModeKey, value.name);
  }
}

class _ThemeModeControllerScope extends InheritedWidget {
  const _ThemeModeControllerScope({
    required this.controller,
    required super.child,
  });

  final ThemeModeController controller;

  @override
  bool updateShouldNotify(_ThemeModeControllerScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
