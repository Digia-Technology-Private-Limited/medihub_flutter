import 'package:flutter/material.dart';
import 'package:medihub/core/constants/digia_screen_ids.dart';
import '../../../models/product.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../core/services/analytics_service.dart';
import '../../../views/product_detail/pdp_screen.dart';
import '../design_system.dart';

class ProductCardHorizontal extends StatefulWidget {
  final Product product;

  const ProductCardHorizontal({super.key, required this.product});

  @override
  State<ProductCardHorizontal> createState() => _ProductCardHorizontalState();
}

class _ProductCardHorizontalState extends State<ProductCardHorizontal> {
  final AnalyticsService _analytics = AnalyticsService();
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final product = widget.product;
    final minPrice = product.priceRange.minVariantPrice.amount;
    final maxPrice = product.compareAtPriceRange?.maxVariantPrice.amount;

    return GestureDetector(
      onTap: () {
        _analytics.trackProductClicked(
          productId: product.id,
          productTitle: product.title,
          handle: product.handle,
          price: product.priceRange.minVariantPrice.amountAsDouble,
          source: 'product_card_horizontal',
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: ScreenIds.productDetail),
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
              child: AppProductImage(
                imageUrl: product.featuredImageUrl,
                size: 92,
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
                      child: CompactPriceDisplay(
                        price: minPrice,
                        compareAtPrice: maxPrice,
                      ),
                    ),
                    CompactRatingStars(
                      rating: 4.0,
                      reviewCount: '(2)',
                    ),
                  ],
                ),
              ),
            ),
            StatefulWishlistIcon(
              initialLiked: _isLiked,
              size: 16,
              onChanged: (liked) {
                setState(() {
                  _isLiked = liked;
                });
                _analytics.trackProductWishlisted(
                  productId: product.id,
                  productTitle: product.title,
                  isWishlisted: liked,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
