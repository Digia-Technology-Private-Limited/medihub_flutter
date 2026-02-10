import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/product.dart';
import '../core/utils/price_utils.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../views/product_detail/pdp_screen.dart';

class ProductCardHorizontal extends StatefulWidget {
  final Product product;

  const ProductCardHorizontal({super.key, required this.product});

  @override
  State<ProductCardHorizontal> createState() => _ProductCardHorizontalState();
}

class _ProductCardHorizontalState extends State<ProductCardHorizontal> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final product = widget.product;
    final minPrice = product.priceRange.minVariantPrice.amount;
    final maxPrice = product.compareAtPriceRange?.maxVariantPrice.amount;
    final discountPercent = maxPrice != null
        ? PriceUtils.calculateDiscountPercent(maxPrice, minPrice)
        : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PDPScreen(productHandle: product.handle),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: colors.border,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: product.featuredImageUrl ?? '',
                width: 92,
                height: 92,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 92,
                  height: 92,
                  color: colors.backgroundSecondary,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 92,
                  height: 92,
                  color: colors.backgroundSecondary,
                  child: const Icon(Icons.image_not_supported, size: 24),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.roboto12Regular(
                        color: colors.contentPrimary,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Text(
                        product.vendor ?? 'MediHub Trusted',
                        style: AppTextStyles.roboto10Regular(
                          color: colors.contentPrimary,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 2),
                      child: Row(
                        children: [
                          Text(
                            PriceUtils.formatPrice(minPrice),
                            style: AppTextStyles.roboto14SemiBold(
                              color: colors.contentPrimary,
                            ),
                          ),
                          if (maxPrice != null && discountPercent > 0)
                            Container(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                PriceUtils.formatPrice(maxPrice),
                                style: AppTextStyles.priceStrikethrough(
                                  color: colors.contentSecondary,
                                ),
                              ),
                            ),
                          const Spacer(),
                          if (discountPercent > 0)
                            Text(
                              'Save $discountPercent%',
                              style: AppTextStyles.roboto8SemiBold(
                                color: AppColors.tokenOrange,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: Text(
                            '4.0',
                            style: AppTextStyles.roboto10SemiBold(
                              color: colors.contentPrimary,
                            ),
                          ),
                        ),
                        ...List.generate(5, (index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 2),
                            width: 10,
                            height: 10,
                            child: SvgPicture.network(
                              'https://res.cloudinary.com/digia/image/upload/v1756150141/Vector_1_yjtbdb.svg',
                              colorFilter: ColorFilter.mode(
                                index <= 3
                                    ? AppColors.tokenStarYellow
                                    : colors.border,
                                BlendMode.srcIn,
                              ),
                              fit: BoxFit.contain,
                            ),
                          );
                        }),
                        Text(
                          '(2)',
                          style: AppTextStyles.roboto8Regular(
                            color: colors.contentPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
              child: SizedBox(
                width: 16,
                height: 16,
                child: _isLiked
                    ? SvgPicture.network(
                        'https://res.cloudinary.com/digia/image/upload/v1756715904/heart-like-svgrepo-com_1_tb519g.svg',
                        colorFilter: ColorFilter.mode(
                          AppColors.tokenOrange,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.contain,
                      )
                    : SvgPicture.network(
                        'https://res.cloudinary.com/digia/image/upload/v1756715904/heart-like-svgrepo-com_gulaxk.svg',
                        colorFilter: ColorFilter.mode(
                          colors.contentSecondary,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
