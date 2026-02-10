import 'package:flutter/material.dart';
import 'package:medihub/core/theme/app_colors.dart';
import 'package:medihub/core/theme/app_text_styles.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isOutlined;

  const BottomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? colors.contentPrimary;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: isOutlined
            ? colors.backgroundPrimary.withValues(alpha: 0)
            : effectiveBgColor,
        border:
            isOutlined ? Border.all(color: effectiveBgColor, width: 2) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: colors.backgroundPrimary.withValues(alpha: 0),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          splashColor: effectiveTextColor.withValues(alpha: 0.2),
          highlightColor: effectiveTextColor.withValues(alpha: 0.1),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: isOutlined ? effectiveBgColor : effectiveTextColor,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon,
                            color: isOutlined
                                ? effectiveBgColor
                                : effectiveTextColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AppTextStyles.button(
                          color: isOutlined
                              ? effectiveBgColor
                              : effectiveTextColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
