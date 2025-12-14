import 'package:flutter/material.dart';

// Color Palette
const Color primaryCyan = Color(0xFF00D9FF);
const Color secondaryPurple = Color(0xFF7C4DFF);
const Color backgroundDark = Color(0xFF121212);
const Color surfaceDark = Color(0xFF1E1E1E);
const Color cardDark = Color(0xFF2D2D2D);
const Color textPrimary = Color(0xFFFFFFFF);
const Color textSecondary = Color(0xFFB3B3B3);

// Gradient
const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryCyan, secondaryPurple],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: primaryCyan,
  scaffoldBackgroundColor: backgroundDark,
  colorScheme: const ColorScheme.dark(
    primary: primaryCyan,
    secondary: secondaryPurple,
    surface: surfaceDark,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: textPrimary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundDark,
    foregroundColor: textPrimary,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardThemeData(
    color: cardDark,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryCyan,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryCyan,
      side: const BorderSide(color: primaryCyan),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: primaryCyan),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: cardDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryCyan, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(color: textSecondary),
    labelStyle: const TextStyle(color: textSecondary),
  ),
  iconTheme: const IconThemeData(color: primaryCyan),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: surfaceDark,
    selectedItemColor: primaryCyan,
    unselectedItemColor: textSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: primaryCyan,
    inactiveTrackColor: cardDark,
    thumbColor: primaryCyan,
    overlayColor: primaryCyan.withOpacity(0.2),
    trackHeight: 4,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryCyan),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: cardDark,
    contentTextStyle: const TextStyle(color: textPrimary),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    behavior: SnackBarBehavior.floating,
  ),
  dividerTheme: const DividerThemeData(color: cardDark, thickness: 1),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    iconColor: primaryCyan,
    textColor: textPrimary,
  ),
);

// Text Styles
class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
}
