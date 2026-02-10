import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../theme/app_colors.dart';

/// Centralized cart icon with badge showing cart count.
///
/// Displays a shopping cart icon with an optional badge showing the number
/// of items in the cart. Supports both outlined and filled icon variants.
///
/// Usage:
/// ```dart
/// CartIconBadge(
///   icon: Icons.shopping_cart_outlined,
///   color: Colors.white,
/// )
/// ```
class CartIconBadge extends StatelessWidget {
  /// The cart icon to display (e.g., Icons.shopping_cart or Icons.shopping_cart_outlined)
  final IconData icon;

  /// Optional icon color. If null, inherits from theme.
  final Color? color;

  /// Optional icon size. Defaults to 24.
  final double size;

  /// Badge background color. Defaults to error color from theme.
  final Color? badgeColor;

  /// Badge text color. Defaults to white.
  final Color? badgeTextColor;

  const CartIconBadge({
    super.key,
    required this.icon,
    this.color,
    this.size = 24,
    this.badgeColor,
    this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return Stack(
          children: [
            Icon(
              icon,
              color: color,
              size: size,
            ),
            if (cartProvider.cartCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: badgeColor ?? colors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Center(
                    child: Text(
                      '${cartProvider.cartCount > 9 ? '9+' : cartProvider.cartCount}',
                      style: TextStyle(
                        color: badgeTextColor ?? Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
