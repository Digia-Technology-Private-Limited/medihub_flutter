import 'package:flutter/material.dart';

/// Centralized loading indicator components.
///
/// Provides consistent loading UI across the app with different sizes
/// and configurations.
class AppLoading {
  /// Standard centered loading indicator for full screens
  static Widget page({Color? color}) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }

  /// Small loading indicator for buttons and compact spaces
  static Widget small({Color? color, double size = 20}) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }

  /// Inline loading indicator with optional text
  static Widget inline({
    Color? color,
    String? text,
    TextStyle? textStyle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        ),
        if (text != null) ...[
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      ],
    );
  }

  /// Loading overlay for entire screen
  static Widget overlay({Color? backgroundColor}) {
    return Container(
      color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Adaptive loading based on size constraint
  static Widget adaptive({
    Color? color,
    double? width,
    double? height,
  }) {
    final size = (width != null && height != null)
        ? (width < height ? width : height) * 0.3
        : 24.0;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: size < 30 ? 2 : 3,
          color: color,
        ),
      ),
    );
  }
}
