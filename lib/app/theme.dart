import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores de la aplicación
  static const Color primaryColor = Color(0xFF92C08D);
  static const Color secondaryColor = Color(0xFF72A6EC);
  static const Color tertiaryColor = Color(0xFFC0B28D);
  static const Color backgroundColor = Color(0xFFF5F7F5);
  static const Color darkBackgroundColor = Color(0xFF21272F);
  static const Color errorColor = Color(0xFFD50B17);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color textColor = Color(0xFF2E2E2E);
  static const Color textLightColor = Color(0xFFFAFAFA);
  
  // Tema claro
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      background: backgroundColor,
      error: errorColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textColor,
      onSurface: textColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: Colors.white,
    ),
    textTheme: GoogleFonts.latoTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: textColor),
        displayMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textColor),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
        bodyLarge: TextStyle(fontSize: 16, color: textColor),
        bodyMedium: TextStyle(fontSize: 14, color: textColor),
        bodySmall: TextStyle(fontSize: 12, color: textColor),
      ),
    ).apply(
      displayColor: textColor,
      bodyColor: textColor,
    ),
  );
  
  // Tema oscuro
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      background: darkBackgroundColor,
      error: errorColor,
      surface: const Color(0xFF2C3440),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textLightColor,
      onSurface: textLightColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2C3440),
      foregroundColor: textLightColor,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF2C3440),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: const Color(0xFF2C3440),
    ),
    textTheme: GoogleFonts.latoTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: textLightColor),
        displayMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textLightColor),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textLightColor),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textLightColor),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textLightColor),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textLightColor),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textLightColor),
        bodyLarge: TextStyle(fontSize: 16, color: textLightColor),
        bodyMedium: TextStyle(fontSize: 14, color: textLightColor),
        bodySmall: TextStyle(fontSize: 12, color: textLightColor),
      ),
    ).apply(
      displayColor: textLightColor,
      bodyColor: textLightColor,
    ),
  );
}
