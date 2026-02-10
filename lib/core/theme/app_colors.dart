import 'package:flutter/material.dart';

/// App colors matching Digia theme spec
/// Includes semantic colors and custom token colors
class AppColors {
  // === LIGHT MODE - Semantic Colors ===
  static const Color lightBrandPrimary = Color(0xFF4945FF);
  static const Color lightBrandSecondary = Color(0xFFFF751F);
  static const Color lightContentPrimary = Color(0xFF000000);
  static const Color lightContentSecondary = Color(0xFF5F5F5F);
  static const Color lightContentTertiary = Color(0xFFE8E8E8);
  static const Color lightBackgroundPrimary = Color(0xFFFFFFFF);
  static const Color lightBackgroundSecondary = Color(0xFFF5F5F5);
  static const Color lightBackgroundTertiary = Color(0xFFE8E8E8);
  static const Color lightAccent1 = Color(0xFF2B71FF);
  static const Color lightAccent2 = Color(0xFFFF22B5);
  static const Color lightSuccess = Color(0xFF25A511);
  static const Color lightError = Color(0xFFF01331);
  static const Color lightWarning = Color(0xFFEEB600);
  static const Color lightInfo = Color(0xFF2B71FF);

  // === LIGHT MODE - Custom Token Colors (from appConfig) ===
  /// h80m2SOtsV - Blue accent
  static const Color tokenBlueAccent = Color(0xFF1252F2);

  /// B2fcpUt1tb - White background
  static const Color tokenWhite = Color(0xFFFFFFFF);

  /// MgUNoEAOis, 0OEZG0LkRI - Grey/Secondary
  static const Color tokenGrey = Color(0xFF949699);

  /// Qn8g7ib27v, gMPdG2xJ96 - Dark text
  static const Color tokenDarkText = Color(0xFF292D32);

  /// tEBnnfDhwJ - Light grey background (chips, borders)
  static const Color tokenLightGrey = Color(0xFFECF0F0);

  /// 6ThEvbjH5p - Strikethrough grey
  static const Color tokenStrikethroughGrey = Color(0xFF949699);

  /// d4yR83IOCN - Orange/CTA color
  static const Color tokenOrange = Color(0xFFFF6F5C);

  /// 636wmvS0Uy - Star/Rating yellow
  static const Color tokenStarYellow = Color(0xFFF6BF4A);

  /// h80m2SOtsV - Primary Blue / Link
  static const Color tokenPrimaryBlue = Color(0xFF2563EB);

  // Legacy aliases for backward compatibility
  static const Color headerBlue = Color(0xFF2563EB);
  static const Color ctaOrange = tokenOrange;

  // === DARK MODE - Semantic Colors ===
  static const Color darkBrandPrimary = Color(0xFF7D7AFF);
  static const Color darkBrandSecondary = Color(0xFFFF8B3D);
  static const Color darkContentPrimary = Color(0xFFFFFFFF);
  static const Color darkContentSecondary = Color(0xFFAFAFAF);
  static const Color darkContentTertiary = Color(0xFF3A3A3A);
  static const Color darkBackgroundPrimary = Color(0xFF000000);
  static const Color darkBackgroundSecondary = Color(0xFF1A1A1A);
  static const Color darkBackgroundTertiary = Color(0xFF2A2A2A);
  static const Color darkAccent1 = Color(0xFF539DFF);
  static const Color darkAccent2 = Color(0xFFFF4DC1);
  static const Color darkSuccess = Color(0xFF48D950);
  static const Color darkError = Color(0xFFFF4D4D);
  static const Color darkWarning = Color(0xFFFFCC00);
  static const Color darkInfo = Color(0xFF539DFF);

  // === DARK MODE - Custom Token Colors (same as light for now) ===
  static const Color darkTokenBlueAccent = Color(0xFF1252F2);
  static const Color darkTokenWhite = Color(0xFFFFFFFF);
  static const Color darkTokenGrey = Color(0xFF949699);
  static const Color darkTokenDarkText = Color(0xFF292D32);
  static const Color darkTokenLightGrey = Color(0xFFECF0F0);
  static const Color darkTokenOrange = Color(0xFFFF6F5C);
  static const Color darkTokenStarYellow = Color(0xFFF6BF4A);

  /// Returns an [AppColorScheme] resolved for the current brightness.
  static AppColorScheme of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? _dark : _light;
  }

  static const _light = AppColorScheme(
    backgroundPrimary: lightBackgroundPrimary,
    backgroundSecondary: lightBackgroundSecondary,
    backgroundTertiary: lightBackgroundTertiary,
    contentPrimary: lightContentPrimary,
    contentSecondary: lightContentSecondary,
    contentTertiary: lightContentTertiary,
    brandPrimary: lightBrandPrimary,
    brandSecondary: lightBrandSecondary,
    error: lightError,
    success: lightSuccess,
    warning: lightWarning,
    info: lightInfo,
    cardBackground: lightBackgroundPrimary,
    divider: Color(0xFFE0E0E0),
    border: Color(0xFFE0E0E0),
    iconSecondary: Color(0xFF757575),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    strikethroughGrey: tokenStrikethroughGrey,
    discountOrange: tokenOrange,
    ratingStar: tokenStarYellow,
  );

  static const _dark = AppColorScheme(
    backgroundPrimary: darkBackgroundPrimary,
    backgroundSecondary: darkBackgroundSecondary,
    backgroundTertiary: darkBackgroundTertiary,
    contentPrimary: darkContentPrimary,
    contentSecondary: darkContentSecondary,
    contentTertiary: darkContentTertiary,
    brandPrimary: darkBrandPrimary,
    brandSecondary: darkBrandSecondary,
    error: darkError,
    success: darkSuccess,
    warning: darkWarning,
    info: darkInfo,
    cardBackground: darkBackgroundSecondary,
    divider: Color(0xFF3A3A3A),
    border: Color(0xFF3A3A3A),
    iconSecondary: Color(0xFF9E9E9E),
    shimmerBase: Color(0xFF424242),
    shimmerHighlight: Color(0xFF616161),
    strikethroughGrey: darkTokenGrey,
    discountOrange: darkTokenOrange,
    ratingStar: darkTokenStarYellow,
  );
}

/// Theme-resolved color set, use via [AppColors.of(context)]
class AppColorScheme {
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundTertiary;
  final Color contentPrimary;
  final Color contentSecondary;
  final Color contentTertiary;
  final Color brandPrimary;
  final Color brandSecondary;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;
  final Color cardBackground;
  final Color divider;
  final Color border;
  final Color iconSecondary;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color strikethroughGrey;
  final Color discountOrange;
  final Color ratingStar;

  const AppColorScheme({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.contentPrimary,
    required this.contentSecondary,
    required this.contentTertiary,
    required this.brandPrimary,
    required this.brandSecondary,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.cardBackground,
    required this.divider,
    required this.border,
    required this.iconSecondary,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.strikethroughGrey,
    required this.discountOrange,
    required this.ratingStar,
  });
}
