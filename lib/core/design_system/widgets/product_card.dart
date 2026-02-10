import 'package:flutter/material.dart';
import 'package:medihub/core/design_system/design_system.dart';
import 'package:medihub/core/services/analytics_service.dart';
import 'package:medihub/core/theme/app_colors.dart';
import 'package:medihub/core/theme/app_text_styles.dart';
import 'package:medihub/models/product.dart';
import 'package:medihub/providers/cart_provider.dart';
import 'package:medihub/views/product_detail/pdp_screen.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final AnalyticsService _analytics = AnalyticsService();
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final minPrice = widget.product.priceRange.minVariantPrice.amount;
    final maxPrice = widget.product.compareAtPriceRange?.maxVariantPrice.amount;

    return GestureDetector(
      onTap: () {
        _analytics.trackProductClicked(
          productId: widget.product.id,
          productTitle: widget.product.title,
          handle: widget.product.handle,
          price: widget.product.priceRange.minVariantPrice.amountAsDouble,
          source: 'product_card',
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PDPScreen(productHandle: widget.product.handle),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 300,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: AppProductImage(
                          imageUrl: widget.product.featuredImageUrl,
                          size: 92,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.roboto12Regular(
                              color: colors.contentPrimary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: PriceDisplay(
                          price: minPrice,
                          compareAtPrice: maxPrice,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: CompactRatingStars(rating: 4.0),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.product.availableForSale == false
                          ? null
                          : () async {
                              final cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false);
                              final variant = widget.product.variants.isNotEmpty
                                  ? widget.product.variants.first
                                  : null;

                              if (variant != null) {
                                _analytics.trackProductAddedToCart(
                                  productId: widget.product.id,
                                  productTitle: widget.product.title,
                                  variantId: variant.id,
                                  variantTitle: variant.title,
                                  price: variant.price.amountAsDouble,
                                  quantity: 1,
                                  source: 'product_card',
                                );
                                await cartProvider.addToCart(
                                    variantId: variant.id);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tokenOrange,
                        foregroundColor: AppColors.tokenWhite,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        widget.product.availableForSale == false
                            ? 'Sold out!'
                            : 'Add To cart',
                        style: AppTextStyles.label(
                          color: AppColors.tokenWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: StatefulWishlistIcon(
                initialLiked: isLiked,
                size: 16,
                onChanged: (liked) {
                  setState(() {
                    isLiked = liked;
                  });
                  _analytics.trackProductWishlisted(
                    productId: widget.product.id,
                    productTitle: widget.product.title,
                    isWishlisted: liked,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
