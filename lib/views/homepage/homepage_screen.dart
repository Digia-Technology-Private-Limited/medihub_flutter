import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/digia_screen_ids.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/analytics_service.dart';
import '../../providers/products_provider.dart';
import '../../providers/address_provider.dart';
import '../../models/product.dart';
import '../../core/design_system/design_system.dart';
import '../product_listing/product_listing_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final AnalyticsService _analytics = AnalyticsService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    await Future.wait([
      productsProvider.fetchCollections(),
      productsProvider.fetchAllProducts(),
    ]);
  }

  void _showAddressBottomSheet() {
    _analytics.trackAddressSheetOpened();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddressBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      body: Column(
        children: [
          Consumer<AddressProvider>(
            builder: (context, addressProvider, _) {
              return HomeHeader(
                deliveryAddress: addressProvider.selectedAddress?.shortLabel ??
                    'Default Address',
                onAddressTap: _showAddressBottomSheet,
              );
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: Consumer<ProductsProvider>(
                builder: (context, productsProvider, _) {
                  if (productsProvider.isLoadingCollections) {
                    return AppLoading.page();
                  }

                  final collections = productsProvider.collections;

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageCarousel(
                          imageUrls: AppConstants.carouselImages,
                          height: 200,
                        ),
                        const SizedBox(height: 16),
                        _buildCategoryChips(collections),
                        const SizedBox(height: 16),
                        ...collections.map((collection) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _CollectionProductSection(
                                collection: collection,
                              ),
                            )),
                        _buildTopBrandsSection(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(List<Collection> collections) {
    final colors = AppColors.of(context);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                _analytics.trackCategoryClicked(
                  categoryName: collection.title,
                  categoryHandle: collection.handle,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(
                      name: ScreenIds.productListing,
                    ),
                    builder: (_) => ProductListingScreen(
                      collectionHandle: collection.handle,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  collection.title,
                  style: AppTextStyles.roboto12Medium(
                    color: colors.contentPrimary,
                  ).copyWith(fontSize: 13),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBrandsSection() {
    final brands = AppConstants.topBrands;
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Top Brands',
            style: AppTextStyles.headingMedium(
              color: colors.contentPrimary,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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

                  _analytics.trackBrandClicked(
                    brandName: brandTitle,
                    brandHandle: brandHandle,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(
                        name: ScreenIds.productListing,
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
        ),
      ],
    );
  }
}

class _CollectionProductSection extends StatefulWidget {
  final Collection collection;

  const _CollectionProductSection({required this.collection});

  @override
  State<_CollectionProductSection> createState() =>
      _CollectionProductSectionState();
}

class _CollectionProductSectionState extends State<_CollectionProductSection> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final products = await productsProvider
        .getProductsByCollectionHandle(widget.collection.handle);
    if (mounted) {
      setState(() {
        _products = products;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: widget.collection.title,
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(
                  name: ScreenIds.productListing,
                ),
                builder: (_) => ProductListingScreen(
                  collectionHandle: widget.collection.handle,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: _isLoading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  itemBuilder: (context, index) => const ProductCardShimmer(),
                )
              : _products.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No products available',
                          style: AppTextStyles.bodyDefault(
                            color: AppColors.of(context).contentSecondary,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _products.length > 10 ? 10 : _products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: _products[index]);
                      },
                    ),
        ),
      ],
    );
  }
}
