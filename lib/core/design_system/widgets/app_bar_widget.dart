import 'package:flutter/material.dart';
import 'package:medihub/core/design_system/icons/cart_icon_badge.dart';
import 'package:medihub/providers/theme_provider.dart';
import 'package:medihub/views/cart/cart_screen.dart';
import 'package:medihub/views/search/search_screen.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showSearch;
  final bool showCart;
  final bool showDarkModeToggle;
  final VoidCallback? onBackPressed;

  const AppBarWidget({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showSearch = false,
    this.showCart = false,
    this.showDarkModeToggle = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: title != null ? Text(title!) : null,
      actions: [
        if (showDarkModeToggle)
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        if (showSearch)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        if (showCart)
          IconButton(
            icon: const CartIconBadge(
              icon: Icons.shopping_cart_outlined,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
