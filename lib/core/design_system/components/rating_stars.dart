import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Centralized rating stars component.
///
/// Displays a rating value with stars visualization using SVG icons.
///
/// Usage:
/// ```dart
/// RatingStars(
///   rating: 4.0,
///   maxRating: 5,
/// )
/// ```
class RatingStars extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final bool showRatingValue;
  final String? reviewCount;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 10,
    this.showRatingValue = true,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final filledStars = rating.floor();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showRatingValue) ...[
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.roboto10SemiBold(
              color: colors.contentPrimary,
            ),
          ),
          const SizedBox(width: 4),
        ],
        ...List.generate(maxRating, (index) {
          return Container(
            margin: const EdgeInsets.only(left: 4),
            width: size,
            height: size,
            child: SvgPicture.network(
              'https://res.cloudinary.com/digia/image/upload/v1756150141/Vector_1_yjtbdb.svg',
              colorFilter: ColorFilter.mode(
                index < filledStars ? AppColors.tokenStarYellow : colors.border,
                BlendMode.srcIn,
              ),
              fit: BoxFit.scaleDown,
            ),
          );
        }),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: AppTextStyles.roboto10SemiBold(
              color: colors.contentSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact rating stars for product cards
class CompactRatingStars extends StatelessWidget {
  final double rating;
  final String? reviewCount;

  const CompactRatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return RatingStars(
      rating: rating,
      size: 10,
      showRatingValue: true,
      reviewCount: reviewCount,
    );
  }
}

/// Large rating stars for detail pages
class LargeRatingStars extends StatelessWidget {
  final double rating;
  final String? reviewCount;

  const LargeRatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return RatingStars(
      rating: rating,
      size: 16,
      showRatingValue: true,
      reviewCount: reviewCount,
    );
  }
}
