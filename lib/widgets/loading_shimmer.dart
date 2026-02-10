import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Shimmer.fromColors(
      baseColor: colors.shimmerBase,
      highlightColor: colors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingShimmer(
              width: 180,
              height: 200,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          const SizedBox(height: 8),
          const LoadingShimmer(width: 120, height: 16),
          const SizedBox(height: 4),
          const LoadingShimmer(width: 80, height: 20),
          const SizedBox(height: 8),
          const LoadingShimmer(width: 100, height: 36),
        ],
      ),
    );
  }
}

class ProductListShimmer extends StatelessWidget {
  const ProductListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const LoadingShimmer(width: 100, height: 100),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoadingShimmer(width: double.infinity, height: 16),
                    const SizedBox(height: 8),
                    const LoadingShimmer(width: 150, height: 14),
                    const SizedBox(height: 8),
                    const LoadingShimmer(width: 100, height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
