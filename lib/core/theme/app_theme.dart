import 'package:flutter/material.dart';

const Color _baseColor = Color(0xFF5B6BF5); //Color(0xFF5B6BF5)

class AppTheme {
  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _baseColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: _baseColor,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      iconTheme: IconThemeData(
        color: colorScheme.primary,
      ),
      primaryIconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: colorScheme.primary,
        suffixIconColor: colorScheme.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary, // Texto e íconos
        centerTitle: true,
        elevation: 2,
        titleTextStyle: TextStyle(
          fontSize: 15, // Cambia este valor según el tamaño de fuente que desees
          fontWeight: FontWeight.bold, // Opcional: define el grosor del texto
          color: colorScheme.onPrimary, // Asegura la coherencia con el color del tema
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          textStyle: WidgetStateProperty.all(const TextStyle(fontWeight: FontWeight.bold)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
