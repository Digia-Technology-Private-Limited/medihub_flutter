import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/design_system.dart';
import '../../providers/products_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/analytics_service.dart';
import '../../models/product.dart';

class ProductListingScreen extends StatefulWidget {
  final String? collectionHandle;
  final List<Product>? products;
  final String? title;

  const ProductListingScreen({
    super.key,
    this.collectionHandle,
    this.products,
    this.title,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final AnalyticsService _analytics = AnalyticsService();
  String _title = '';
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.products != null) {
      _products = widget.products!;
      _title = widget.title ?? '';
      _isLoading = false;
    } else {
      _loadProducts();
    }
  }

  Future<void> _loadProducts() async {
    if (widget.collectionHandle == null) {
      setState(() {
        _error = 'No collection specified';
        _isLoading = false;
      });
      return;
    }

    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    try {
      final result = await productsProvider
          .getCollectionWithProducts(widget.collectionHandle!);

      if (mounted) {
        setState(() {
          _title = result.title;
          _products = result.products;
          _isLoading = false;
        });
        _analytics.trackCategoryViewed(
          categoryName: result.title,
          categoryHandle: widget.collectionHandle!,
          productCount: result.products.length,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading products';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).backgroundSecondary,
      appBar: AppBarWidget(
        title:
            _isLoading ? 'Loading...' : '$_title (${_products.length} Items)',
        showBackButton: true,
        showSearch: true,
        showCart: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return AppLoading.page();
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: AppTextStyles.bodyLarge(
            color: AppColors.of(context).contentSecondary,
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Text(
          'No products found',
          style: AppTextStyles.bodyLarge(
            color: AppColors.of(context).contentSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ProductCardHorizontal(product: _products[index]),
        );
      },
    );
  }
}
