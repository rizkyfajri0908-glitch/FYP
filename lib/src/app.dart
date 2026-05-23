import 'package:flutter/material.dart';

import 'screens/auth_gate.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

class SmartKitchenApp extends StatelessWidget {
  const SmartKitchenApp({
    super.key,
    this.isFirebaseReady = false,
  });

  final bool isFirebaseReady;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoBite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: isFirebaseReady ? const AuthGate() : const HomeShell(),
    );
  }
}
