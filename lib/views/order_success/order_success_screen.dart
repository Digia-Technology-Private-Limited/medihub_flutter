import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../core/services/analytics_service.dart';
import '../../core/constants/digia_screen_ids.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../main_shell.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  final AnalyticsService _analytics = AnalyticsService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    _analytics.trackOrderPlaced(
      itemCount: cartProvider.cartCount,
      totalValue: cartProvider.cart?.cost?.totalAmount?.amountAsDouble ?? 0.0,
    );

    cartProvider.clearCart();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Icon with Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: colors.success,
                    size: 80,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Order Placed Successfully!',
                style: AppTextStyles.headingMedium(
                  color: colors.contentPrimary,
                ).copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'Thank you for your order.\nWe\'ll send you a confirmation email shortly.',
                style: AppTextStyles.bodyLarge(
                  color: colors.contentSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Order Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.receipt_long_outlined,
                      label: 'Order ID',
                      value:
                          '#${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.local_shipping_outlined,
                      label: 'Estimated Delivery',
                      value: '3-5 business days',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.card_giftcard_outlined,
                      label: 'HK Cash Earned',
                      value: '₹50',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _analytics.trackContinueShoppingClicked(
                        source: 'order_success');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        settings:
                            const RouteSettings(name: ScreenIds.home),
                        builder: (_) => const MainShell(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Continue Shopping'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    // For Phase 1, just show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order tracking coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Track Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Icon(icon, size: 24, color: colors.iconSecondary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.roboto12Regular(
                  color: colors.contentSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyLarge(
                  fontWeight: FontWeight.w600,
                  color: colors.contentPrimary,
                ).copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
