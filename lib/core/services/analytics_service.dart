import 'package:flutter/foundation.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';

/// Analytics service for tracking user events via CleverTap.
/// Uses singleton pattern for app-wide access.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  bool _isInitialized = false;

  /// Initialize CleverTap SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    // CleverTap is auto-initialized from native config
    // Enable debug mode in development
    if (kDebugMode) {
      CleverTapPlugin.setDebugLevel(3);
    }

    _isInitialized = true;
    _log('CleverTap initialized');
  }

  // ─────────────────────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────────────────────

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[Analytics] $message');
    }
  }

  void _trackEvent(String eventName, Map<String, dynamic> properties) {
    if (!_isInitialized) {
      _log('Warning: Attempted to track event before initialization');
      return;
    }

    // Add common properties
    final enrichedProperties = {
      ...properties,
      'timestamp': DateTime.now().toIso8601String(),
    };

    CleverTapPlugin.recordEvent(eventName, enrichedProperties);
    _log('Event: $eventName');
  }

  // ─────────────────────────────────────────────────────────────────
  // SCREEN EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackScreenView(String screenName) {
    _trackEvent('screen_viewed', {'screen_name': screenName});
  }

  // ─────────────────────────────────────────────────────────────────
  // PRODUCT EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackProductViewed({
    required String productId,
    required String productTitle,
    required String handle,
    required double price,
  }) {
    _trackEvent('product_viewed', {
      'product_id': productId,
      'product_title': productTitle,
      'product_handle': handle,
      'price': price,
    });
  }

  void trackProductAddedToCart({
    required String productId,
    required String productTitle,
    required String variantId,
    required String variantTitle,
    required double price,
    required int quantity,
  }) {
    _trackEvent('product_added_to_cart', {
      'product_id': productId,
      'product_title': productTitle,
      'variant_id': variantId,
      'variant_title': variantTitle,
      'price': price,
      'quantity': quantity,
      'total_value': price * quantity,
    });
  }

  void trackProductRemovedFromCart({
    required String productId,
    required String productTitle,
    required int quantity,
  }) {
    _trackEvent('product_removed_from_cart', {
      'product_id': productId,
      'product_title': productTitle,
      'quantity': quantity,
    });
  }

  void trackProductVariantSelected({
    required String productId,
    required String variantId,
    required String variantTitle,
  }) {
    _trackEvent('product_variant_selected', {
      'product_id': productId,
      'variant_id': variantId,
      'variant_title': variantTitle,
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // CART EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackCartViewed({
    required int itemCount,
    required double totalValue,
  }) {
    _trackEvent('cart_viewed', {
      'item_count': itemCount,
      'total_value': totalValue,
    });
  }

  void trackCheckoutInitiated({
    required int itemCount,
    required double totalValue,
    required double discount,
  }) {
    _trackEvent('checkout_initiated', {
      'item_count': itemCount,
      'total_value': totalValue,
      'discount': discount,
    });
  }

  void trackOrderPlaced({
    required int itemCount,
    required double totalValue,
  }) {
    _trackEvent('order_placed', {
      'item_count': itemCount,
      'total_value': totalValue,
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // SEARCH EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackSearchInitiated(String query) {
    _trackEvent('search_initiated', {'search_query': query});
  }

  void trackSearchResultsViewed({
    required String query,
    required int resultCount,
  }) {
    _trackEvent('search_results_viewed', {
      'search_query': query,
      'result_count': resultCount,
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // CATEGORY/BRAND EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackCategoryViewed({
    required String categoryName,
    required String categoryHandle,
    required int productCount,
  }) {
    _trackEvent('category_viewed', {
      'category_name': categoryName,
      'category_handle': categoryHandle,
      'product_count': productCount,
    });
  }

  void trackBrandViewed({
    required String brandName,
    required String brandHandle,
  }) {
    _trackEvent('brand_viewed', {
      'brand_name': brandName,
      'brand_handle': brandHandle,
    });
  }
}
