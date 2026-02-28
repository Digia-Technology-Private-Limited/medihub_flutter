import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../../providers/products_provider.dart';
import '../../providers/cart_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_utils.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/digia_screen_ids.dart';
import '../../core/services/analytics_service.dart';
import '../../core/design_system/design_system.dart';
import '../search/search_screen.dart';
import '../cart/cart_screen.dart';
import 'package:digia_ui/digia_ui.dart';

class PDPScreen extends StatefulWidget {
  final String productHandle;

  const PDPScreen({super.key, required this.productHandle});

  @override
  State<PDPScreen> createState() => _PDPScreenState();
}

class _PDPScreenState extends State<PDPScreen> {
  final AnalyticsService _analytics = AnalyticsService();
  Product? _product;
  Variant? _selectedVariant;
  bool _isLoading = true;
  bool _isWishlisted = false;
  int _selectedImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadProduct() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final product =
        await productsProvider.getProductByHandle(widget.productHandle);

    if (product != null) {
      setState(() {
        _product = product;
        _selectedVariant =
            product.variants.isNotEmpty ? product.variants.first : null;
        _isLoading = false;
      });
      _analytics.trackProductViewed(
        productId: product.id,
        productTitle: product.title,
        handle: product.handle,
        price: product.priceRange.minVariantPrice.amountAsDouble,
      );
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _showVariantSelector() async {
    final selected = await VariantSelectorDialog.show(
      context: context,
      variants: _product!.variants,
      selectedVariant: _selectedVariant,
    );

    if (selected != null) {
      setState(() => _selectedVariant = selected);
      _analytics.trackProductVariantSelected(
        productId: _product!.id,
        variantId: selected.id,
        variantTitle: selected.title,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: AppLoading.page(),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Center(
          child: Text(
            'Product not found',
            style: AppTextStyles.bodyLarge(
              color: AppColors.of(context).contentPrimary,
            ),
          ),
        ),
      );
    }

    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeliveryBanner(),
                  _buildImageGallery(),
                  _buildProductInfo(),
                  const SizedBox(height: 16),
                  const DigiaSlot(AppConstants.digiaPdpSlotKey),
                  const SizedBox(height: 16),
                  _buildVariantSelector(),
                  const SizedBox(height: 16),
                  _buildDeliveryServices(),
                  const SizedBox(height: 20),
                  _buildOffersSection(),
                  const SizedBox(height: 20),
                  _buildDetailsSection(),
                  const SizedBox(height: 20),
                  _buildCustomerReviews(),
                  const SizedBox(height: 20),
                  _buildSellerInfo(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final colors = AppColors.of(context);

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colors.contentPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Product Details',
        style: AppTextStyles.bodyLarge(
          color: colors.contentPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: colors.contentPrimary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: DigiaScreenIds.search),
                builder: (_) => const SearchScreen(),
              ),
            );
          },
        ),
        Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined,
                      color: colors.contentPrimary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings:
                            const RouteSettings(name: DigiaScreenIds.cart),
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  },
                ),
                if (cartProvider.cartCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colors.contentPrimary,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartProvider.cartCount}',
                        style: AppTextStyles.roboto10SemiBold(
                          color: colors.backgroundPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDeliveryBanner() {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: colors.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 20, color: colors.contentSecondary),
          const SizedBox(width: 8),
          Text(
            'Delivery By ${AppConstants.expectedDeliveryDate}',
            style: AppTextStyles.bodySmall(
              color: colors.contentPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = _product!.images.isNotEmpty
        ? _product!.images.map((img) => img.url).toList()
        : [_product!.featuredImageUrl ?? ''];

    final colors = AppColors.of(context);

    return Container(
      color: colors.cardBackground,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() => _selectedImageIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const LoadingShimmer(
                            width: double.infinity, height: 280),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image_not_supported, size: 80),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Column(
                  children: [
                    _buildActionButton(
                      icon: _isWishlisted
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isWishlisted ? Colors.red : colors.iconSecondary,
                      onTap: () {
                        setState(() => _isWishlisted = !_isWishlisted);
                        _analytics.trackProductWishlisted(
                          productId: _product!.id,
                          productTitle: _product!.title,
                          isWishlisted: _isWishlisted,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      icon: Icons.compare_arrows,
                      color: colors.iconSecondary,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (images.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedImageIndex == index
                          ? AppColors.headerBlue
                          : colors.border,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colors.contentPrimary.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }

  Widget _buildProductInfo() {
    final price = _selectedVariant?.price.amount ??
        _product!.priceRange.minVariantPrice.amount;
    final compareAtPrice = _selectedVariant?.compareAtPrice?.amount ??
        _product!.compareAtPriceRange?.minVariantPrice.amount;
    final discountPercent = compareAtPrice != null
        ? PriceUtils.calculateDiscountPercent(compareAtPrice, price)
        : 0;

    final colors = AppColors.of(context);

    return Container(
      color: colors.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _product!.title,
            style: AppTextStyles.bodyLarge(
              color: colors.contentPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                PriceUtils.formatPrice(price),
                style: AppTextStyles.headingMedium(
                  color: colors.contentPrimary,
                ).copyWith(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (compareAtPrice != null && discountPercent > 0) ...[
                const SizedBox(width: 10),
                Text(
                  PriceUtils.formatPrice(compareAtPrice),
                  style: AppTextStyles.priceStrikethrough(
                    color: colors.strikethroughGrey,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '($discountPercent% off)',
                  style: AppTextStyles.bodySmall(
                    color: colors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Inclusive of All Taxes',
            style:
                AppTextStyles.roboto12Regular(color: colors.contentSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (_product!.rating != null) ...[
                Text(
                  _product!.rating!.toStringAsFixed(1),
                  style: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (_product!.rating ?? 0).floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: colors.ratingStar,
                      size: 16,
                    );
                  }),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${_product!.reviewCount ?? 0} rating)',
                  style: AppTextStyles.roboto12Regular(
                      color: colors.contentSecondary),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                'Earn ${AppConstants.hkCashReward}',
                style: AppTextStyles.bodySmall(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: colors.ratingStar,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: 12,
                  color: colors.cardBackground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSelector() {
    if (_product!.variants.isEmpty) return const SizedBox.shrink();
    final colors = AppColors.of(context);

    return Container(
      color: colors.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Variant',
            style: AppTextStyles.bodyDefault(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showVariantSelector,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity : ${_selectedVariant?.title ?? 'Select'}',
                    style: AppTextStyles.bodyDefault(
                      color: colors.contentPrimary,
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
        ],
      ),
    );
  }

  Widget _buildDeliveryServices() {
    final colors = AppColors.of(context);

    return Container(
      color: colors.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery & Services',
            style: AppTextStyles.bodyDefault(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '110078',
              style: AppTextStyles.bodySmall(color: colors.contentSecondary),
            ),
          ),
          const SizedBox(height: 16),
          _buildServiceRow(
            icon: Icons.local_shipping_outlined,
            boldText: 'Delivery By',
            normalText: ' fri, 24 feb, free shipping',
          ),
          const SizedBox(height: 12),
          _buildServiceRow(
            icon: Icons.account_balance_wallet_outlined,
            boldText: '',
            normalText: 'Cash On Delivery available',
          ),
          const SizedBox(height: 12),
          _buildServiceRow(
            icon: Icons.replay_outlined,
            boldText: '',
            normalText: 'This product is non-returnable.',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow({
    required IconData icon,
    required String boldText,
    required String normalText,
  }) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: colors.iconSecondary),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            style: AppTextStyles.roboto12Medium(color: colors.contentSecondary),
            children: [
              if (boldText.isNotEmpty)
                TextSpan(
                  text: boldText,
                  style: AppTextStyles.roboto12SemiBold()
                      .copyWith(color: colors.contentSecondary),
                ),
              TextSpan(text: normalText),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOffersSection() {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Offers',
                style: AppTextStyles.bodyDefault(fontWeight: FontWeight.bold),
              ),
              Text(
                '+4 Offers',
                style: AppTextStyles.roboto12Medium(
                    color: colors.contentSecondary),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios,
                  size: 12, color: colors.iconSecondary),
            ],
          ),
          const SizedBox(height: 12),
          const OfferCard(title: 'Healthkart Ashwaganda 60 Cap @299'),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Details',
            style: AppTextStyles.bodyDefault(
              fontWeight: FontWeight.w600,
              color: colors.contentSecondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ExpandableSection(
          title: 'Information',
          content: Text(
            'This is a dietary supplement, not a substitute for a varied diet. Consult your doctor before use if you are pregnant, nursing, or under medication. Keep out of reach of children.',
            style: AppTextStyles.roboto12Medium(
              color: colors.contentSecondary,
            ).copyWith(fontSize: 13, height: 1.5),
          ),
        ),
        ExpandableSection(
          title: 'Supplements',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '• Vitamin C (Ascorbic Acid): 60 mg',
              '• Vitamin D3: 800 IU',
              '• Vitamin B12: 12 mcg',
              '• Zinc: 11 mg',
              '• Magnesium: 50 mg',
              '• Iron: 9 mg',
              '• Omega-3 (Fish Oil Extract): 250 mg',
            ]
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        item,
                        style: AppTextStyles.roboto12Regular(
                          color: AppColors.of(context).contentSecondary,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        ExpandableSection(
          title: 'About the product',
          content: Text(
            _product!.description ?? 'No description available.',
            style: AppTextStyles.roboto12Regular(
              color: colors.contentSecondary,
            ).copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerReviews() {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Customer Reviews',
            style: AppTextStyles.bodyDefault(
              fontWeight: FontWeight.w600,
              color: colors.contentPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        RatingBreakdown(
          averageRating: _product!.rating ?? 4.5,
          totalRatings: 1,
          totalReviews: 1,
          ratingCounts: const {
            5: 150,
            4: 100,
            3: 300,
            2: 120,
            1: 100,
          },
        ),
      ],
    );
  }

  Widget _buildSellerInfo() {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seller Information',
            style: AppTextStyles.bodyDefault(
              fontWeight: FontWeight.w600,
              color: colors.contentPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.roboto12Regular(
                        color: colors.contentSecondary),
                    children: [
                      TextSpan(
                        text: 'Sold and Marketed By : ',
                        style: AppTextStyles.roboto12SemiBold(),
                      ),
                      const TextSpan(
                        text: 'bright lifecare pvt ltd fullfilled by hea',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'parasvnath arcdia, mg road, sector-14, gurugram(haryana) - 1',
                  style: AppTextStyles.roboto12Regular(
                    color: colors.contentSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: colors.contentPrimary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                return OutlinedButton(
                  onPressed: cartProvider.isLoading
                      ? null
                      : () async {
                          if (_selectedVariant != null) {
                            _analytics.trackProductAddedToCart(
                              productId: _product!.id,
                              productTitle: _product!.title,
                              variantId: _selectedVariant!.id,
                              variantTitle: _selectedVariant!.title,
                              price: _selectedVariant!.price.amountAsDouble,
                              quantity: 1,
                              source: 'pdp',
                            );
                            await cartProvider.addToCart(
                              variantId: _selectedVariant!.id,
                            );
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.discountOrange,
                    side: BorderSide(color: colors.discountOrange, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: cartProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Add To cart',
                          style: AppTextStyles.button(
                              color: colors.discountOrange),
                        ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                if (_selectedVariant != null) {
                  _analytics.trackBuyNowClicked(
                    productId: _product!.id,
                    productTitle: _product!.title,
                    variantId: _selectedVariant!.id,
                    price: _selectedVariant!.price.amountAsDouble,
                  );
                  _analytics.trackProductAddedToCart(
                    productId: _product!.id,
                    productTitle: _product!.title,
                    variantId: _selectedVariant!.id,
                    variantTitle: _selectedVariant!.title,
                    price: _selectedVariant!.price.amountAsDouble,
                    quantity: 1,
                    source: 'pdp_buy_now',
                  );
                  final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  await cartProvider.addToCart(variantId: _selectedVariant!.id);
                  if (mounted) {
                    _analytics.trackCartViewed(
                      itemCount: cartProvider.cartCount,
                      totalValue: cartProvider
                              .cart?.cost?.totalAmount?.amountAsDouble ??
                          0.0,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings:
                            const RouteSettings(name: DigiaScreenIds.cart),
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.discountOrange,
                foregroundColor: colors.backgroundPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Buy Now',
                style: AppTextStyles.button(color: colors.backgroundPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
