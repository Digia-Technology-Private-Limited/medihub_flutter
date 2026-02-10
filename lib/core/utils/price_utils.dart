import 'package:intl/intl.dart';

class PriceUtils {
  static final _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 1,
  );

  // Format price from string amount
  static String formatPrice(String amount, {String currencyCode = 'INR'}) {
    try {
      final price = double.parse(amount);
      return _currencyFormat.format(price);
    } catch (e) {
      return '₹0.0';
    }
  }

  // Format price from double
  static String formatPriceFromDouble(double amount) {
    return _currencyFormat.format(amount);
  }

  // Calculate discount percentage
  static int calculateDiscountPercent(String originalPrice, String salePrice) {
    try {
      final original = double.parse(originalPrice);
      final sale = double.parse(salePrice);

      if (original <= 0) return 0;

      final discount = ((original - sale) / original * 100).round();
      return discount > 0 ? discount : 0;
    } catch (e) {
      return 0;
    }
  }

  // Parse price to double
  static double parsePrice(String amount) {
    try {
      return double.parse(amount);
    } catch (e) {
      return 0.0;
    }
  }
}
