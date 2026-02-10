import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/cart.dart';
import '../../providers/cart_provider.dart';
import '../../core/services/analytics_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_utils.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/toast_utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final AnalyticsService _analytics = AnalyticsService();
  String? _appliedCoupon;
  double _couponDiscount = 0;

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('cart');

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (cartProvider.cart != null) {
      _analytics.trackCartViewed(
        itemCount: cartProvider.cartCount,
        totalValue: cartProvider.cart!.cost?.totalAmount?.amountAsDouble ?? 0.0,
      );
    }
  }

  void _showApplyCouponDialog() {
    final controller = TextEditingController();
    final colors = AppColors.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apply Coupon',
                style: AppTextStyles.roboto16Bold(
                  color: colors.contentPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        hintStyle: AppTextStyles.roboto14Regular(
                          color: colors.contentSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.ctaOrange,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final code = controller.text.trim();
                      if (code.isEmpty) return;
                      Navigator.pop(context, code);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ctaOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Available Coupons',
                style: AppTextStyles.roboto14SemiBold(
                  color: colors.contentPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildCouponOption(
                context,
                code: 'SAVE10',
                description: 'Get 10% off on orders above ₹999',
              ),
              _buildCouponOption(
                context,
                code: 'FLAT200',
                description: 'Flat ₹200 off on orders above ₹1499',
              ),
              _buildCouponOption(
                context,
                code: 'FIRST50',
                description: '50% off up to ₹500 on first order',
              ),
            ],
          ),
        );
      },
    ).then((code) {
      if (code != null) _applyCoupon(code);
    });
  }

  Widget _buildCouponOption(
    BuildContext context, {
    required String code,
    required String description,
  }) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: () => Navigator.pop(context, code),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.ctaOrange),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                code,
                style: AppTextStyles.roboto12SemiBold(
                  color: AppColors.ctaOrange,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: AppTextStyles.roboto12Regular(
                color: colors.contentSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyCoupon(String code) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final subtotal =
        cartProvider.cart?.cost?.subtotalAmount?.amountAsDouble ?? 0;

    double discount = 0;
    switch (code.toUpperCase()) {
      case 'SAVE10':
        if (subtotal >= 999) discount = subtotal * 0.10;
      case 'FLAT200':
        if (subtotal >= 1499) discount = 200;
      case 'FIRST50':
        discount = (subtotal * 0.50).clamp(0, 500);
      default:
        ToastUtils.showError('Invalid coupon code');
        return;
    }

    if (discount == 0) {
      ToastUtils.showError('Coupon not applicable on this order');
      return;
    }

    setState(() {
      _appliedCoupon = code.toUpperCase();
      _couponDiscount = discount;
    });
    ToastUtils.showSuccess(
      'Coupon $code applied! You save ${PriceUtils.formatPriceFromDouble(discount)}',
    );
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _couponDiscount = 0;
    });
    ToastUtils.showInfo('Coupon removed');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return Column(
              children: [
                _buildAppBar(cartProvider),
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }

          if (cartProvider.cart == null || cartProvider.cart!.lines.isEmpty) {
            return Column(
              children: [
                _buildAppBar(cartProvider),
                Expanded(child: _buildEmptyCart()),
              ],
            );
          }

          return Column(
            children: [
              _buildAppBar(cartProvider),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDeliveryBanner(),
                      const SizedBox(height: 8),
                      ...cartProvider.cart!.lines.map(
                        (line) => _buildCartItem(line, cartProvider),
                      ),
                      _buildSavingsBanner(cartProvider),
                      const SizedBox(height: 8),
                      _buildApplyCoupons(),
                      const SizedBox(height: 8),
                      _buildOrderSummary(cartProvider),
                      const SizedBox(height: 8),
                      _buildHkCashRow(cartProvider),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              _buildContinueButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(CartProvider cartProvider) {
    final colors = AppColors.of(context);
    final itemCount = cartProvider.cartCount;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          border: Border(
            bottom: BorderSide(color: colors.divider, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            if (Navigator.canPop(context))
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new,
                    size: 20, color: colors.contentPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            Text(
              'Cart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.contentPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '($itemCount Items)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: colors.contentSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryBanner() {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: colors.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 20, color: colors.contentSecondary),
          const SizedBox(width: 8),
          Text(
            'Delivery By ${AppConstants.expectedDeliveryDate}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.contentPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    final colors = AppColors.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: colors.contentSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: AppTextStyles.headingSmall(color: colors.contentSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to get started',
            style: AppTextStyles.bodySmall(color: colors.contentSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tokenOrange,
              foregroundColor: AppColors.tokenWhite,
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartLine line, CartProvider cartProvider) {
    final merchandise = line.merchandise;
    final imageUrl = merchandise.imageUrl ?? '';
    final colors = AppColors.of(context);

    final currentPrice = line.cost.amountPerQuantity.amountAsDouble;
    final comparePrice =
        line.cost.compareAtAmountPerQuantity?.amountAsDouble ?? 0.0;
    final savings = comparePrice > currentPrice
        ? (comparePrice - currentPrice) * line.quantity
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 80,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 90,
                      color: colors.backgroundTertiary,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 90,
                      color: colors.backgroundTertiary,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.productTitle,
                        style: AppTextStyles.roboto12Regular(
                          color: colors.contentPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (merchandise.title != 'Default Title') ...[
                        const SizedBox(height: 2),
                        Text(
                          merchandise.title,
                          style: AppTextStyles.roboto10Regular(
                            color: colors.contentSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            PriceUtils.formatPrice(
                                line.cost.amountPerQuantity.amount),
                            style: AppTextStyles.roboto14SemiBold(
                              color: colors.contentPrimary,
                            ),
                          ),
                          if (line.cost.compareAtAmountPerQuantity != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              PriceUtils.formatPrice(
                                line.cost.compareAtAmountPerQuantity!.amount,
                              ),
                              style: AppTextStyles.priceStrikethrough(
                                color: colors.contentSecondary,
                              ),
                            ),
                          ],
                          if (savings > 0) ...[
                            const Spacer(),
                            Text(
                              'Save ${PriceUtils.formatPriceFromDouble(savings)}',
                              style: AppTextStyles.roboto10SemiBold(
                                color: AppColors.ctaOrange,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (line.quantity > 1) {
                      await cartProvider.updateCartItemQuantity(
                        lineItemId: line.id,
                        quantity: line.quantity - 1,
                      );
                    } else {
                      await cartProvider.updateCartItemQuantity(
                        lineItemId: line.id,
                        quantity: 0,
                      );
                      _analytics.trackProductRemovedFromCart(
                        productId: merchandise.id,
                        productTitle: line.productTitle,
                        quantity: 1,
                      );
                    }
                  },
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 28,
                    color: colors.contentPrimary,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.backgroundTertiary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${line.quantity}',
                    style: AppTextStyles.roboto12SemiBold(
                      color: colors.contentPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await cartProvider.updateCartItemQuantity(
                      lineItemId: line.id,
                      quantity: line.quantity + 1,
                    );
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 28,
                    color: colors.contentPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsBanner(CartProvider cartProvider) {
    final colors = AppColors.of(context);
    final totalSavings = cartProvider.cart!.totalSavings;
    if (totalSavings <= 0) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.success,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'You are saving ${PriceUtils.formatPriceFromDouble(totalSavings)} on this purchase',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildApplyCoupons() {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: _appliedCoupon != null ? null : _showApplyCouponDialog,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 22,
              color: AppColors.ctaOrange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _appliedCoupon != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coupon Applied: $_appliedCoupon',
                          style: AppTextStyles.roboto14SemiBold(
                            color: AppColors.lightSuccess,
                          ),
                        ),
                        Text(
                          'You save ${PriceUtils.formatPriceFromDouble(_couponDiscount)}',
                          style: AppTextStyles.roboto12Regular(
                            color: colors.contentSecondary,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Apply Coupons',
                      style: AppTextStyles.roboto14SemiBold(
                        color: colors.contentPrimary,
                      ),
                    ),
            ),
            if (_appliedCoupon != null)
              GestureDetector(
                onTap: _removeCoupon,
                child: Icon(Icons.close, size: 20, color: colors.error),
              )
            else
              Icon(
                Icons.chevron_right,
                size: 22,
                color: colors.contentSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    final colors = AppColors.of(context);
    final cart = cartProvider.cart!;
    final itemCount = cartProvider.cartCount;

    final totalMrp = _calculateTotalMrp(cart);
    final subtotal = cart.cost?.subtotalAmount?.amountAsDouble ?? 0.0;
    final totalDiscount = totalMrp - subtotal + _couponDiscount;
    final shipping = AppConstants.shippingCharge;
    final payable = subtotal + shipping - _couponDiscount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary ($itemCount items)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.contentPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
              'Total MRP', PriceUtils.formatPriceFromDouble(totalMrp)),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Shipping Charges',
            shipping == 0 ? 'FREE' : PriceUtils.formatPriceFromDouble(shipping),
          ),
          const SizedBox(height: 10),
          if (totalDiscount > 0) ...[
            _buildSummaryRow(
              'Total Discount',
              '- ${PriceUtils.formatPriceFromDouble(totalDiscount)}',
              valueColor: AppColors.lightSuccess,
            ),
            const SizedBox(height: 10),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payable Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.contentPrimary,
                ),
              ),
              Text(
                PriceUtils.formatPriceFromDouble(payable > 0 ? payable : 0),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.contentPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTotalMrp(Cart cart) {
    double totalMrp = 0;
    for (var line in cart.lines) {
      final compare = line.cost.compareAtAmountPerQuantity?.amountAsDouble;
      final price = line.cost.amountPerQuantity.amountAsDouble;
      totalMrp += (compare ?? price) * line.quantity;
    }
    return totalMrp;
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.roboto14Regular(color: colors.contentSecondary),
        ),
        Text(
          value,
          style: AppTextStyles.roboto14Regular(
            color: valueColor ?? colors.contentPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildHkCashRow(CartProvider cartProvider) {
    final colors = AppColors.of(context);
    final subtotal =
        cartProvider.cart!.cost?.subtotalAmount?.amountAsDouble ?? 0;
    final hkCash =
        (subtotal * AppConstants.hkCashRewardMultiplier / 100).round();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Text(
            'You Earn',
            style: AppTextStyles.roboto14Regular(
              color: colors.contentPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.tokenStarYellow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$hkCash HK Cash on this Order',
            style: AppTextStyles.roboto14SemiBold(
              color: colors.contentPrimary,
            ),
          ),
          const Spacer(),
          Icon(Icons.info_outline, size: 18, color: colors.contentSecondary),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ctaOrange,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            final cartProvider =
                Provider.of<CartProvider>(context, listen: false);
            _analytics.trackCheckoutInitiated(
              itemCount: cartProvider.cartCount,
              totalValue:
                  cartProvider.cart!.cost?.totalAmount?.amountAsDouble ?? 0.0,
              discount: cartProvider.cart!.totalDiscount + _couponDiscount,
            );
            ToastUtils.showSuccess('Proceeding to checkout...');
          },
          child: Container(
            height: 24,
            alignment: Alignment.center,
            child: const Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
