import 'package:digia_engage/digia_engage.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/digia_screen_ids.dart';
import '../../core/services/analytics_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

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
  void initState() {
    super.initState();
    Digia.setCurrentScreen(DigiaScreenIds.digiaTest);
    _analytics.logDigiaProbe(
      'DigiaTestScreen mounted and set current screen to digia_test',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Digia / CleverTap Test')),
      backgroundColor: colors.backgroundSecondary,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Fire events to test campaigns. In-App should render overlays and inline should render inside slots below.',
            style: AppTextStyles.bodySmall(color: colors.contentSecondary),
          ),
          const SizedBox(height: 16),
          _sectionTitle(context, 'In-App (dialog / bottom sheet)'),
          _eventButton(
            context,
            label: 'cart_viewed',
            onPressed: () {
              Digia.setCurrentScreen(DigiaScreenIds.cart);
              _analytics.trackCartViewed(itemCount: 2, totalValue: 999.0);
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) Digia.setCurrentScreen(DigiaScreenIds.digiaTest);
              });
            },
          ),
          _eventButton(
            context,
            label: 'search_results_viewed',
            onPressed: () {
              Digia.setCurrentScreen(DigiaScreenIds.search);
              _analytics.trackSearchResultsViewed(
                query: 'vitamins',
                resultCount: 12,
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) Digia.setCurrentScreen(DigiaScreenIds.digiaTest);
              });
            },
          ),
          const SizedBox(height: 8),
          _sectionTitle(context, 'Native Display (inline slot)'),
          _eventButton(
            context,
            label: 'app_opened',
            onPressed: () {
              _analytics.trackAppOpened();
              setState(() => _showAppOpenedSlot = true);
            },
          ),
          _slotHint(
            context,
            AppConstants.digiaHomepageSlotKey,
            visible: _showAppOpenedSlot,
          ),
          _eventButton(
            context,
            label: 'product_viewed',
            onPressed: () {
              _analytics.trackProductViewed(
                productId: 'prod_123',
                productTitle: 'Test Product',
                handle: 'test-product',
                price: 299.0,
              );
              setState(() => _showProductViewedSlot = true);
            },
          ),
          _slotHint(
            context,
            AppConstants.digiaPdpSlotKey,
            visible: _showProductViewedSlot,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.roboto14SemiBold(color: colors.contentPrimary),
      ),
    );
  }

  Widget _eventButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, child: Text(label)),
      ),
    );
  }

  Widget _slotHint(
    BuildContext context,
    String placementKey, {
    required bool visible,
  }) {
    final colors = AppColors.of(context);
    if (!visible) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Slot: $placementKey (waiting for campaign content)',
            style: AppTextStyles.bodySmall(color: colors.contentSecondary),
          ),
          const SizedBox(height: 6),
          DigiaSlot(placementKey),
        ],
      ),
    );
  }
}
