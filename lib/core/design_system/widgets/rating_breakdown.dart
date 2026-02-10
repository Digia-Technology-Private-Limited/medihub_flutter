import 'package:flutter/material.dart';
import 'package:medihub/core/theme/app_colors.dart';
import 'package:medihub/core/theme/app_text_styles.dart';

class RatingBreakdown extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final int totalReviews;
  final Map<int, int> ratingCounts;
  final VoidCallback? onTap;

  const RatingBreakdown({
    super.key,
    required this.averageRating,
    required this.totalRatings,
    required this.totalReviews,
    required this.ratingCounts,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final maxCount = ratingCounts.values.isEmpty
        ? 1
        : ratingCounts.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${averageRating.toStringAsFixed(1)} Out of 5',
                            style: AppTextStyles.bodyLarge(
                              color: colors.contentPrimary,
                              fontWeight: FontWeight.w600,
                            ).copyWith(fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          ...List.generate(5, (index) {
                            return Icon(
                              index < averageRating.floor()
                                  ? Icons.star
                                  : (index < averageRating
                                      ? Icons.star_half
                                      : Icons.star_border),
                              color: colors.ratingStar,
                              size: 18,
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '($totalRatings rating, $totalReviews reviews)',
                        style: AppTextStyles.roboto12Regular(
                          color: colors.contentSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colors.iconSecondary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [5, 4, 3, 2, 1].map((rating) {
              final count = ratingCounts[rating] ?? 0;
              final fraction = maxCount > 0 ? count / maxCount : 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '$rating',
                        style: AppTextStyles.roboto12Medium(
                          color: colors.contentPrimary,
                        ).copyWith(fontSize: 13),
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: colors.ratingStar,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: fraction,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.ratingStar,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '$count',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.roboto12Regular(
                          color: colors.contentSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
