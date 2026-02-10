import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/price_utils.dart';
import '../providers/cart_provider.dart';
import '../views/product_detail/pdp_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final minPrice = widget.product.priceRange.minVariantPrice.amount;
    final maxPrice = widget.product.compareAtPriceRange?.maxVariantPrice.amount;
    final discountPercent = maxPrice != null
        ? PriceUtils.calculateDiscountPercent(maxPrice, minPrice)
        : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PDPScreen(productHandle: widget.product.handle),
          ),
        );
      },
      child: Container(
        width: 180,
        height: 244,
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
                        child: CachedNetworkImage(
                          imageUrl: widget.product.featuredImageUrl ?? '',
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
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 92,
                            height: 92,
                            color: colors.backgroundSecondary,
                            child:
                                const Icon(Icons.image_not_supported, size: 24),
                          ),
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
                        child: Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                PriceUtils.formatPrice(minPrice),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.roboto14SemiBold(
                                  color: colors.contentPrimary,
                                ),
                              ),
                            ),
                            if (maxPrice != null && discountPercent > 0) ...[
                              Flexible(
                                flex: 2,
                                child: Text(
                                  PriceUtils.formatPrice(maxPrice),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.priceStrikethrough(
                                    color: colors.contentSecondary,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  '$discountPercent% off',
                                  maxLines: 1,
                                  style: AppTextStyles.roboto8SemiBold(
                                    color: AppColors.tokenOrange,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Text(
                              '4.0',
                              style: AppTextStyles.roboto10SemiBold(
                                color: colors.contentPrimary,
                              ),
                            ),
                            ...List.generate(5, (index) {
                              return Container(
                                margin: const EdgeInsets.only(left: 4),
                                width: 10,
                                height: 10,
                                child: SvgPicture.network(
                                  'https://res.cloudinary.com/digia/image/upload/v1756150141/Vector_1_yjtbdb.svg',
                                  colorFilter: ColorFilter.mode(
                                    index < 4
                                        ? AppColors.tokenStarYellow
                                        : colors.border,
                                    BlendMode.srcIn,
                                  ),
                                  fit: BoxFit.scaleDown,
                                ),
                              );
                            }),
                          ],
                        ),
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
                              final variantId =
                                  widget.product.variants.isNotEmpty
                                      ? widget.product.variants.first.id
                                      : '';

                              if (variantId.isNotEmpty) {
                                await cartProvider.addToCart(
                                    variantId: variantId);
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
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: isLiked
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
            ),
          ],
        ),
      ),
    );
  }
}
