import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _cartIdKey = 'cartId';
  static const String _cartCountKey = 'cartCounter';

  // Get cart ID
  Future<String?> getCartId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cartIdKey);
  }

  // Set cart ID
  Future<bool> setCartId(String cartId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_cartIdKey, cartId);
  }

  // Get cart count
  Future<int> getCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cartCountKey) ?? 0;
  }

  // Set cart count
  Future<bool> setCartCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_cartCountKey, count);
  }

  // Clear all cart data
  Future<bool> clearCartData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartIdKey);
    await prefs.remove(_cartCountKey);
    return true;
  }
}
