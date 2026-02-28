import 'package:flutter/material.dart';
import 'package:medihub/core/design_system/widgets/app_bar_widget.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/digia_screen_ids.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/analytics_service.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../core/design_system/widgets/brand_card.dart';
import '../product_listing/product_listing_screen.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = AnalyticsService();
    final brands = AppConstants.topBrands;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      appBar: const AppBarWidget(
        title: 'All Brands',
        showSearch: true,
        showCart: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return BrandCard(
            title: brand['title']!,
            imageUrl: brand['imageUrl']!,
            onTap: () async {
              final brandTitle = brand['title']!;
              final brandHandle = brand['handle']!;

              final productsProvider =
                  Provider.of<ProductsProvider>(context, listen: false);

              // Filter products by title containing brand name (matching JS logic)
              final filteredProducts = productsProvider.allProducts
                  .where((product) => product.title
                      .toLowerCase()
                      .contains(brandTitle.toLowerCase()))
                  .toList();

              if (!context.mounted) return;

              analytics.trackBrandClicked(
                brandName: brandTitle,
                brandHandle: brandHandle,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(
                    name: DigiaScreenIds.productListing,
                  ),
                  builder: (_) => ProductListingScreen(
                    products: filteredProducts,
                    title: brandTitle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
