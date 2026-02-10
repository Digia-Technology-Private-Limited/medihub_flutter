import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/app_bar_widget.dart';
import '../product_listing/product_listing_screen.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListingScreen(
                    collectionHandle: brand['handle'],
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
