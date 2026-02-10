import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/products_provider.dart';
import '../../providers/address_provider.dart';
import '../../models/product.dart';
import '../../widgets/home_header.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/image_carousel.dart';
import '../../widgets/section_header.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/address_bottom_sheet.dart';
import '../product_listing/product_listing_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    await productsProvider.fetchCollections();
  }

  void _showAddressBottomSheet() {
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
                    return const Center(child: CircularProgressIndicator());
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
                        const SizedBox(height: 24),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
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
                  style: TextStyle(
                    color: colors.contentPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.contentPrimary,
            ),
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
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No products available'),
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
