import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/price_utils.dart';

/// Centralized price display component.
///
/// Displays price with optional discount price and percentage badge.
/// Handles all price formatting and styling consistently.
///
/// Usage:
/// ```dart
/// PriceDisplay(
///   price: product.price,
///   compareAtPrice: product.compareAtPrice,
/// )
/// ```
class PriceDisplay extends StatelessWidget {
  final String price;
  final String? compareAtPrice;
  final TextStyle? priceStyle;
  final TextStyle? compareAtPriceStyle;
  final TextStyle? discountStyle;
  final MainAxisSize mainAxisSize;

  const PriceDisplay({
    super.key,
    required this.price,
    this.compareAtPrice,
    this.priceStyle,
    this.compareAtPriceStyle,
    this.discountStyle,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final discountPercent = compareAtPrice != null
        ? PriceUtils.calculateDiscountPercent(compareAtPrice!, price)
        : 0;

    return Row(
      mainAxisSize: mainAxisSize,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            PriceUtils.formatPrice(price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: priceStyle ??
                AppTextStyles.roboto14SemiBold(
                  color: colors.contentPrimary,
                ),
          ),
        ),
        if (compareAtPrice != null && discountPercent > 0) ...[
          const SizedBox(width: 4),
          Flexible(
            flex: 2,
            child: Text(
              PriceUtils.formatPrice(compareAtPrice!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: compareAtPriceStyle ??
                  AppTextStyles.priceStrikethrough(
                    color: colors.contentSecondary,
                  ),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            flex: 2,
            child: Text(
              '$discountPercent% off',
              maxLines: 1,
              style: discountStyle ??
                  AppTextStyles.roboto8SemiBold(
                    color: AppColors.tokenOrange,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact price display for cards
class CompactPriceDisplay extends StatelessWidget {
  final String price;
  final String? compareAtPrice;

  const CompactPriceDisplay({
    super.key,
    required this.price,
    this.compareAtPrice,
  });

  @override
  Widget build(BuildContext context) {
    return PriceDisplay(
      price: price,
      compareAtPrice: compareAtPrice,
      mainAxisSize: MainAxisSize.min,
    );
  }
}

/// Large price display for detail pages
class LargePriceDisplay extends StatelessWidget {
  final String price;
  final String? compareAtPrice;

  const LargePriceDisplay({
    super.key,
    required this.price,
    this.compareAtPrice,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return PriceDisplay(
      price: price,
      compareAtPrice: compareAtPrice,
      priceStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colors.contentPrimary,
      ),
      compareAtPriceStyle: TextStyle(
        fontSize: 18,
        decoration: TextDecoration.lineThrough,
        color: colors.contentSecondary,
      ),
      discountStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.tokenOrange,
      ),
    );
  }
}
