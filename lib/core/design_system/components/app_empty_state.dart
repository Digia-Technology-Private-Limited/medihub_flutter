import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Centralized empty state component.
///
/// Displays consistent empty states across the app with icon, title,
/// and optional description and action button.
///
/// Usage:
/// ```dart
/// AppEmptyState(
///   icon: Icons.shopping_bag_outlined,
///   title: 'No products found',
///   description: 'Try adjusting your filters',
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;
  final double iconSize;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
    this.iconSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: colors.contentTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.contentPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.contentSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Preset empty states for common scenarios
class AppEmptyStates {
  /// Empty products list
  static Widget products() {
    return const AppEmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'No products found',
      description: 'Try adjusting your search or filters',
    );
  }

  /// Empty cart
  static Widget cart() {
    return const AppEmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Your cart is empty',
      description: 'Add items to get started',
    );
  }

  /// Empty search results
  static Widget searchResults() {
    return const AppEmptyState(
      icon: Icons.search_off,
      title: 'No results found',
      description: 'Try a different search term',
    );
  }

  /// Empty orders
  static Widget orders() {
    return const AppEmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'No orders yet',
      description: 'Your order history will appear here',
    );
  }

  /// Generic empty state
  static Widget generic({
    required String title,
    String? description,
    Widget? action,
  }) {
    return AppEmptyState(
      icon: Icons.inbox_outlined,
      title: title,
      description: description,
      action: action,
    );
  }
}
