import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFA3EC3E);
  static const Color secondaryColor = Color(0xFF8D95A7);
  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkBackgroundColor = Color(0xFF000000);
  static const Color cardLightColor = Color(0xFFF5F5F5);
  static const Color cardDarkColor = Color(0xFF191919);
  static const Color textLightColor = Color(0xFF000000);
  static const Color textDarkColor = Color(0xFF000000);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    cardColor: cardLightColor,
    hintColor: secondaryColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textLightColor),
      bodyMedium: TextStyle(color: secondaryColor, fontSize: 18),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white10,
      labelStyle: const TextStyle(color: secondaryColor),
      prefixIconColor: secondaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLightColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: cardDarkColor,
    hintColor: secondaryColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textDarkColor),
      bodyMedium: TextStyle(color: secondaryColor, fontSize: 18),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white10,
      labelStyle: const TextStyle(color: secondaryColor),
      prefixIconColor: secondaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textDarkColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}
