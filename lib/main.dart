import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/services/firebase_bootstrap.dart';
import 'src/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isFirebaseReady = await FirebaseBootstrap.initialize();
  await NotificationService.instance.initialize();
  runApp(SmartKitchenApp(isFirebaseReady: isFirebaseReady));
}
