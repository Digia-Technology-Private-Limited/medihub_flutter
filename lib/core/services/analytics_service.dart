import 'package:flutter/foundation.dart';

/// Analytics service — logs events to console on this branch.
/// On the `clevertap` or `moengage` branches this routes through the respective SDK.
/// Uses singleton pattern for app-wide access.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    _log('initialized');
  }

  // ─────────────────────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────────────────────

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[Digia-Medihub] $message');
    }
  }

  void _trackEvent(String eventName, Map<String, dynamic> properties) {
    if (!_isInitialized) {
      _log('Warning: Attempted to track event before initialization');
      return;
    }

    final enrichedProperties = {
      ...properties,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _log('$eventName $enrichedProperties');
  }

  // ─────────────────────────────────────────────────────────────────
  // APP LIFECYCLE EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackAppOpened() {
    _trackEvent('app_opened', {});
  }

  // ─────────────────────────────────────────────────────────────────
  // SCREEN EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackScreenView(String screenName) {
    _trackEvent('screen_viewed', {'screen_name': screenName});
  }

  void trackBottomNavTapped({required String tabName, required int tabIndex}) {
    _trackEvent('bottom_nav_tapped', {
      'tab_name': tabName,
      'tab_index': tabIndex,
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // PRODUCT EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackProductClicked({
    required String productId,
    required String productTitle,
    required String handle,
    required double price,
    required String source,
  }) {
    _trackEvent('product_clicked', {
      'product_id': productId,
      'product_title': productTitle,
      'product_handle': handle,
      'price': price,
      'source': source,
    });
  }

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
    required String source,
  }) {
    _trackEvent('product_added_to_cart', {
      'product_id': productId,
      'product_title': productTitle,
      'variant_id': variantId,
      'variant_title': variantTitle,
      'price': price,
      'quantity': quantity,
      'total_value': price * quantity,
      'source': source,
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

  void trackProductWishlisted({
    required String productId,
    required String productTitle,
    required bool isWishlisted,
  }) {
    _trackEvent('product_wishlisted', {
      'product_id': productId,
      'product_title': productTitle,
      'is_wishlisted': isWishlisted,
    });
  }

  void trackProductShared({
    required String productId,
    required String productTitle,
  }) {
    _trackEvent('product_shared', {
      'product_id': productId,
      'product_title': productTitle,
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // ACCOUNT EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackAccountViewed() {
    _trackEvent('accountPage_opened', {});
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

  void trackCartItemQuantityUpdated({
    required String productId,
    required String productTitle,
    required int oldQuantity,
    required int newQuantity,
  }) {
    _trackEvent('cart_item_quantity_updated', {
      'product_id': productId,
      'product_title': productTitle,
      'old_quantity': oldQuantity,
      'new_quantity': newQuantity,
      'action': newQuantity > oldQuantity ? 'increased' : 'decreased',
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

  void trackBuyNowClicked({
    required String productId,
    required String productTitle,
    required String variantId,
    required double price,
  }) {
    _trackEvent('buy_now_clicked', {
      'product_id': productId,
      'product_title': productTitle,
      'variant_id': variantId,
      'price': price,
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

  void trackContinueShoppingClicked({required String source}) {
    _trackEvent('continue_shopping_clicked', {'source': source});
  }

  // ─────────────────────────────────────────────────────────────────
  // COUPON EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackCouponApplied({
    required String couponCode,
    required double discount,
    required double cartValue,
  }) {
    _trackEvent('coupon_applied', {
      'coupon_code': couponCode,
      'discount': discount,
      'cart_value': cartValue,
    });
  }

  void trackCouponRemoved({required String couponCode}) {
    _trackEvent('coupon_removed', {'coupon_code': couponCode});
  }

  void trackCouponFailed({
    required String couponCode,
    required String reason,
  }) {
    _trackEvent('coupon_failed', {
      'coupon_code': couponCode,
      'reason': reason,
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

  void trackSearchSuggestionClicked({required String suggestion}) {
    _trackEvent('search_suggestion_clicked', {'suggestion': suggestion});
  }

  // ─────────────────────────────────────────────────────────────────
  // CATEGORY / BRAND EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackCategoryClicked({
    required String categoryName,
    required String categoryHandle,
  }) {
    _trackEvent('category_clicked', {
      'category_name': categoryName,
      'category_handle': categoryHandle,
    });
  }

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

  void trackBrandClicked({
    required String brandName,
    required String brandHandle,
  }) {
    _trackEvent('brand_clicked', {
      'brand_name': brandName,
      'brand_handle': brandHandle,
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

  // ─────────────────────────────────────────────────────────────────
  // USER PREFERENCE EVENTS
  // ─────────────────────────────────────────────────────────────────

  void trackDarkModeToggled({required bool isDarkMode}) {
    _trackEvent('dark_mode_toggled', {'is_dark_mode': isDarkMode});
  }

  void trackAddressSheetOpened() {
    _trackEvent('address_sheet_opened', {});
  }
}
