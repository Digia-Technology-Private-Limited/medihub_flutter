import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.lightBrandPrimary,
    scaffoldBackgroundColor: AppColors.lightBackgroundPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightBrandPrimary,
      secondary: AppColors.lightBrandSecondary,
      surface: AppColors.lightBackgroundPrimary,
      error: AppColors.lightError,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackgroundPrimary,
      foregroundColor: AppColors.lightContentPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle:
          AppTextStyles.heading3(color: AppColors.lightContentPrimary),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.lightBackgroundPrimary,
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackgroundPrimary,
      selectedItemColor: AppColors.headerBlue,
      unselectedItemColor: Color(0xFF9E9E9E),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.lightBackgroundPrimary,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightBackgroundPrimary,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightBrandPrimary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.button(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      displayLarge:
          AppTextStyles.display1(color: AppColors.lightContentPrimary),
      displayMedium:
          AppTextStyles.display2(color: AppColors.lightContentPrimary),
      displaySmall:
          AppTextStyles.display3(color: AppColors.lightContentPrimary),
      headlineLarge:
          AppTextStyles.heading1(color: AppColors.lightContentPrimary),
      headlineMedium:
          AppTextStyles.heading2(color: AppColors.lightContentPrimary),
      headlineSmall:
          AppTextStyles.heading3(color: AppColors.lightContentPrimary),
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.lightContentPrimary),
      bodyMedium:
          AppTextStyles.bodyMedium(color: AppColors.lightContentPrimary),
      bodySmall:
          AppTextStyles.bodySmall(color: AppColors.lightContentSecondary),
      labelSmall: AppTextStyles.caption(color: AppColors.lightContentSecondary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBackgroundSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkBrandPrimary,
    scaffoldBackgroundColor: AppColors.darkBackgroundPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkBrandPrimary,
      secondary: AppColors.darkBrandSecondary,
      surface: AppColors.darkBackgroundPrimary,
      error: AppColors.darkError,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackgroundSecondary,
      foregroundColor: AppColors.darkContentPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle:
          AppTextStyles.heading3(color: AppColors.darkContentPrimary),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkBackgroundSecondary,
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackgroundSecondary,
      selectedItemColor: AppColors.headerBlue,
      unselectedItemColor: Color(0xFF757575),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.darkBackgroundSecondary,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkBackgroundSecondary,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3A3A3A),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBrandPrimary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.button(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.display1(color: AppColors.darkContentPrimary),
      displayMedium:
          AppTextStyles.display2(color: AppColors.darkContentPrimary),
      displaySmall: AppTextStyles.display3(color: AppColors.darkContentPrimary),
      headlineLarge:
          AppTextStyles.heading1(color: AppColors.darkContentPrimary),
      headlineMedium:
          AppTextStyles.heading2(color: AppColors.darkContentPrimary),
      headlineSmall:
          AppTextStyles.heading3(color: AppColors.darkContentPrimary),
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.darkContentPrimary),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.darkContentPrimary),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.darkContentSecondary),
      labelSmall: AppTextStyles.caption(color: AppColors.darkContentSecondary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkBackgroundSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
