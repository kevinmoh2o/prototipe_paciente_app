// core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:paciente_app/core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  // Getter que retorna el ThemeData apropiado según _currentMode
  ThemeData get themeData => AppTheme.theme;
}
