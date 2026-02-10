import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App text styles matching Digia theme spec
/// Uses Inter for display/heading, Roboto for body/custom tokens
class AppTextStyles {
  // === Display Styles (Inter, semiBold) ===
  static TextStyle displayLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w600, // semiBold
        color: color,
        height: 1.15,
      );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.15,
      );

  static TextStyle displaySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.15,
      );

  // === Heading Styles (Inter, medium) ===
  static TextStyle headingLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w500, // medium
        color: color,
        height: 1.25,
      );

  static TextStyle headingMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.25,
      );

  static TextStyle headingSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.25,
      );

  // === Body Styles (Inter, regular) ===
  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: fontWeight ?? FontWeight.w400, // regular
        color: color,
        height: 1.25,
      );

  static TextStyle bodyDefault({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
        height: 1.25,
      );

  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
        height: 1.25,
      );

  static TextStyle bodyXSmall({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
        height: 1.25,
      );

  // === Custom Font Tokens (Roboto) ===

  /// u7LB2y - Roboto 14 regular
  static TextStyle roboto14Regular({Color? color}) => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  /// BOJ5kl - Roboto 12 medium
  static TextStyle roboto12Medium({Color? color}) => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.5,
      );

  /// CZN4E2 - Roboto 12 semi-bold (for category chips)
  static TextStyle roboto12SemiBold({Color? color}) => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.5,
      );

  /// LCxiwq, 3F3dgk, LmKuew - Roboto 16 bold
  static TextStyle roboto16Bold({Color? color}) => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.5,
      );

  /// OZARCe, gkBpKZ, erWuqp, UGxXUS - Roboto 14 semi-bold (for price)
  static TextStyle roboto14SemiBold({Color? color}) => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.5,
      );

  /// 3UarWu - Roboto 12 regular (for product title)
  static TextStyle roboto12Regular({Color? color}) => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  /// AxEBEW, L0HF4d - Roboto 12 medium (for compare price)
  static TextStyle comparePrice({Color? color}) => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.5,
      );

  /// h6n17L - Roboto 8 semi-bold (save amount)
  static TextStyle roboto8SemiBold({Color? color}) => GoogleFonts.roboto(
        fontSize: 8,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.5,
      );

  /// hE7wbS - Roboto 10 semi-bold (rating)
  static TextStyle roboto10SemiBold({Color? color}) => GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.5,
      );

  /// xeM1Ww - Roboto 12 semi-bold
  static TextStyle label({Color? color}) => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.5,
      );

  /// TmGRif - Roboto 8 regular
  static TextStyle roboto8Regular({Color? color}) => GoogleFonts.roboto(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  /// 3r1u8W - Roboto 10 regular (subtitle)
  static TextStyle roboto10Regular({Color? color}) => GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  /// SXoKyp - Roboto 10 medium
  static TextStyle roboto10Medium({Color? color}) => GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.5,
      );

  /// SqpfgK - Roboto 14 medium
  static TextStyle roboto14Medium({Color? color}) => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.5,
      );

  /// 9MaNkD - Roboto 14 regular
  static TextStyle caption({Color? color}) => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  // === Legacy aliases for backward compatibility ===
  static TextStyle display1({Color? color}) => displayLarge(color: color);
  static TextStyle display2({Color? color}) => displayMedium(color: color);
  static TextStyle display3({Color? color}) => displaySmall(color: color);
  static TextStyle heading1({Color? color}) => headingLarge(color: color);
  static TextStyle heading2({Color? color}) => headingMedium(color: color);
  static TextStyle heading3({Color? color}) => headingSmall(color: color);

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) =>
      bodyDefault(color: color, fontWeight: fontWeight);

  static TextStyle button({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.2,
        letterSpacing: 0.5,
      );

  static TextStyle priceMain({Color? color}) => roboto14SemiBold(color: color);

  static TextStyle priceStrikethrough({Color? color}) => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? const Color(0xFF949699),
        decoration: TextDecoration.lineThrough,
        height: 1.5,
      );

  static TextStyle priceDiscount({Color? color}) =>
      roboto8SemiBold(color: color ?? const Color(0xFFFF6F5C));
}
