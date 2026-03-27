import 'package:digia_engage/digia_engage.dart';
import 'package:flutter/material.dart';

import '../../core/services/analytics_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// Digia Engage + CleverTap integration test screen.
/// Use this to fire test events and verify campaign delivery.
class DigiaTestScreen extends StatefulWidget {
  const DigiaTestScreen({super.key});

  @override
  State<DigiaTestScreen> createState() => _DigiaTestScreenState();
}

class _DigiaTestScreenState extends State<DigiaTestScreen> {
  final AnalyticsService _analytics = AnalyticsService();
  bool _showAppOpenedSlot = false;
  bool _showProductViewedSlot = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Digia / CleverTap Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Fire events to test campaigns. In App = dialogs/bottom sheets. Native Display = inline slots.',
              style: AppTextStyles.bodySmall(color: colors.contentSecondary),
            ),
            const SizedBox(height: 16),
            _SectionTitle('In App (dialogs / bottom sheets)'),
            _EventButton('cart_viewed', () {
              _analytics.trackCartViewed(itemCount: 2, totalValue: 999.0);
            }),
            _EventButton('search_results_viewed', () {
              _analytics.trackSearchResultsViewed(query: 'vitamins', resultCount: 12);
            }),
            _EventButton('product_added_to_cart', () {
              _analytics.trackProductAddedToCart(
                productId: 'prod_123',
                productTitle: 'Test Product',
                variantId: 'var_456',
                variantTitle: 'Default',
                price: 299.0,
                quantity: 1,
                source: 'digia_test',
              );
            }),
            const SizedBox(height: 16),
            _SectionTitle('Native Display (inline slots)'),
            _EventButton('app_opened', () {
              _analytics.trackAppOpened();
              setState(() => _showAppOpenedSlot = true);
            }),
            if (_showAppOpenedSlot) ...[
              const SizedBox(height: 8),
              DigiaSlot(AppConstants.digiaHomepageSlotKey),
            ],
            _EventButton('product_viewed', () {
              _analytics.trackProductViewed(
                productId: 'prod_123',
                productTitle: 'Test Product',
                handle: 'test-product',
                price: 299.0,
              );
              setState(() => _showProductViewedSlot = true);
            }),
            if (_showProductViewedSlot) ...[
              const SizedBox(height: 8),
              DigiaSlot(AppConstants.digiaPdpSlotKey),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: AppTextStyles.roboto14SemiBold(color: colors.contentSecondary)),
    );
  }
}

class _EventButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _EventButton(this.label, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
