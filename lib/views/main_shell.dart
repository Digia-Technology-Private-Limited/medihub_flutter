import 'package:digia_engage/digia_engage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/digia_screen_ids.dart';
import '../core/design_system/design_system.dart';
import '../core/services/analytics_service.dart';
import '../core/theme/app_colors.dart';
import '../providers/cart_provider.dart';
import 'account/account_screen.dart';
import 'brands/brands_screen.dart';
import 'cart/cart_screen.dart';
import 'digiatest/digia_test_screen.dart';
import 'homepage/homepage_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final AnalyticsService _analytics = AnalyticsService();
  int _currentIndex = 0;

  static const _tabNames = ['Home', 'Brands', 'Account', 'Cart'];
  static const _tabScreenIds = [
    DigiaScreenIds.home,
    DigiaScreenIds.brands,
    DigiaScreenIds.account,
    DigiaScreenIds.cart,
  ];

  final List<Widget> _screens = const [
    HomepageScreen(),
    BrandsScreen(),
    AccountScreen(),
    CartScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Digia.setCurrentScreen(_tabScreenIds[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                _analytics.logDigiaProbe(
                  'Opening DigiaTestScreen from MainShell FAB',
                );
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    settings: const RouteSettings(
                      name: DigiaScreenIds.digiaTest,
                    ),
                    builder: (_) => const DigiaTestScreen(),
                  ),
                );
              },
              child: const Icon(Icons.bug_report),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: colors.contentPrimary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _analytics.trackBottomNavTapped(
              tabName: _tabNames[index],
              tabIndex: index,
            );
            if (index == 3) {
              final cartProvider = Provider.of<CartProvider>(
                context,
                listen: false,
              );
              _analytics.trackCartViewed(
                itemCount: cartProvider.cartCount,
                totalValue:
                    cartProvider.cart?.cost?.totalAmount?.amountAsDouble ?? 0.0,
              );
            }
            if (index == 2) {
              _analytics.trackAccountViewed();
            }

            Digia.setCurrentScreen(_tabScreenIds[index]);
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Brands',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: CartIconBadge(
                icon: Icons.shopping_cart_outlined,
                color: colors.contentSecondary,
              ),
              activeIcon: CartIconBadge(
                icon: Icons.shopping_cart,
                color: colors.brandPrimary,
              ),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }
}
