import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const darkGreen = Color(0xFF0F3D2E);
  static const forestGreen = Color(0xFF1F7A4D);
  static const leafGreen = Color(0xFF7BC47F);
  static const mintGreen = Color(0xFFEAF7EC);
  static const paleGreen = Color(0xFFF6FBF7);
  static const warning = Color(0xFFE7A23B);
  static const danger = Color(0xFFD9534F);
  static const ink = Color(0xFF1D2B24);
  static const muted = Color(0xFF66746C);

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color titleGreen(BuildContext context) {
    return isDarkMode(context) ? mintGreen : darkGreen;
  }

  static Color iconGreen(BuildContext context) {
    return isDarkMode(context) ? leafGreen : forestGreen;
  }

  static Color readableMuted(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFFC9D8CE) : muted;
  }
}
