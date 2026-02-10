import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../core/services/api_service.dart';
import '../core/services/preferences_service.dart';
import '../core/utils/toast_utils.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesService _prefsService = PreferencesService();

  Cart? _cart;
  bool _isLoading = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  int get cartCount => _cart?.totalQuantity ?? 0;
  String? get cartId => _cart?.id;

  // Initialize cart from preferences
  Future<void> initialize() async {
    final savedCartId = await _prefsService.getCartId();
    if (savedCartId != null && savedCartId != 'null') {
      await loadCart(savedCartId);
    }
  }

  // Load cart from API
  Future<void> loadCart(String cartId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.getCart(cartId);
      final cartData = response['data']?['cart'];

      if (cartData != null) {
        _cart = Cart.fromJson(cartData as Map<String, dynamic>);
        await _prefsService.setCartId(_cart!.id);
        await _prefsService.setCartCount(_cart!.totalQuantity);
      }
    } catch (e) {
      ToastUtils.showError('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create cart with first item
  Future<bool> createCart({
    required String variantId,
    int quantity = 1,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.createCart(
        variantId: variantId,
        quantity: quantity,
      );

      final cartData = response['data']?['cartCreate']?['cart'];
      final errors = response['data']?['cartCreate']?['userErrors'];

      if (errors != null && (errors as List).isNotEmpty) {
        ToastUtils.showError('Error creating cart: ${errors[0]['message']}');
        return false;
      }

      if (cartData != null) {
        _cart = Cart.fromJson(cartData as Map<String, dynamic>);
        await _prefsService.setCartId(_cart!.id);
        await _prefsService.setCartCount(_cart!.totalQuantity);
        ToastUtils.showSuccess('Added to cart');
        return true;
      }

      return false;
    } catch (e) {
      ToastUtils.showError('Error creating cart: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add item to existing cart
  Future<bool> addToCart({
    required String variantId,
    int quantity = 1,
  }) async {
    try {
      // If no cart exists, create one
      if (_cart == null) {
        return await createCart(variantId: variantId, quantity: quantity);
      }

      _isLoading = true;
      notifyListeners();

      final response = await _apiService.addToCart(
        cartId: _cart!.id,
        variantId: variantId,
        quantity: quantity,
      );

      final cartData = response['data']?['cartLinesAdd']?['cart'];
      final errors = response['data']?['cartLinesAdd']?['userErrors'];

      if (errors != null && (errors as List).isNotEmpty) {
        ToastUtils.showError('Error adding to cart: ${errors[0]['message']}');
        return false;
      }

      if (cartData != null) {
        _cart = Cart.fromJson(cartData as Map<String, dynamic>);
        await _prefsService.setCartCount(_cart!.totalQuantity);
        ToastUtils.showSuccess('Added to cart');
        return true;
      }

      return false;
    } catch (e) {
      ToastUtils.showError('Error adding to cart: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update cart item quantity
  Future<bool> updateCartItemQuantity({
    required String lineItemId,
    required int quantity,
  }) async {
    if (_cart == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.updateCartItems(
        cartId: _cart!.id,
        lineItemId: lineItemId,
        quantity: quantity,
      );

      final cartData = response['data']?['cartLinesUpdate']?['cart'];
      final errors = response['data']?['cartLinesUpdate']?['userErrors'];

      if (errors != null && (errors as List).isNotEmpty) {
        ToastUtils.showError('Error updating cart: ${errors[0]['message']}');
        return false;
      }

      if (cartData != null) {
        _cart = Cart.fromJson(cartData as Map<String, dynamic>);
        await _prefsService.setCartCount(_cart!.totalQuantity);

        if (quantity == 0) {
          ToastUtils.showSuccess('Removed from cart');
        }
        return true;
      }

      return false;
    } catch (e) {
      ToastUtils.showError('Error updating cart: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    _cart = null;
    await _prefsService.clearCartData();
    notifyListeners();
  }
}
