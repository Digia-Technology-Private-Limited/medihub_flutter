import 'package:flutter/material.dart';
import '../models/product.dart';
import '../core/services/api_service.dart';
import '../core/utils/toast_utils.dart';

// Collection model
class Collection {
  final String id;
  final String handle;
  final String title;
  final String? imageUrl;

  Collection({
    required this.id,
    required this.handle,
    required this.title,
    this.imageUrl,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['image']?['url'] as String?,
    );
  }
}

class ProductsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _allProducts = [];
  List<Product> _searchResults = [];
  List<Collection> _collections = [];
  bool _isLoading = false;
  bool _isLoadingCollections = false;
  String _lastSearchQuery = '';

  List<Product> get allProducts => _allProducts;
  List<Product> get searchResults => _searchResults;
  List<Collection> get collections => _collections;
  bool get isLoading => _isLoading;
  bool get isLoadingCollections => _isLoadingCollections;
  String get lastSearchQuery => _lastSearchQuery;

  // Fetch all products
  Future<void> fetchAllProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.getAllProducts();
      final productsData = response['data']?['products']?['edges'] as List?;

      if (productsData != null) {
        _allProducts = productsData
            .map((edge) => Product.fromJson(
                (edge as Map<String, dynamic>)['node'] as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      ToastUtils.showError('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search products by title
  void searchProducts(String query) {
    _lastSearchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    _searchResults = _allProducts.where((product) {
      return product.title.toLowerCase().contains(lowercaseQuery);
    }).toList();

    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _lastSearchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  // Get product by handle (from cache first, then API)
  Future<Product?> getProductByHandle(String handle) async {
    final cached = _allProducts.cast<Product?>().firstWhere(
          (p) => p!.handle == handle,
          orElse: () => null,
        );
    if (cached != null) return cached;

    try {
      final response = await _apiService.getProductByHandle(handle);
      final productData = response['data']?['productByHandle'];
      if (productData != null) {
        return Product.fromJson(productData as Map<String, dynamic>);
      }
    } catch (e) {
      ToastUtils.showError('Error loading product: $e');
    }

    return null;
  }

  // Fetch collections (categories)
  Future<void> fetchCollections() async {
    try {
      _isLoadingCollections = true;
      notifyListeners();

      final response = await _apiService.getCollections(first: 20);
      final collectionsData =
          response['data']?['collections']?['edges'] as List?;

      if (collectionsData != null) {
        _collections = collectionsData
            .map((edge) => Collection.fromJson(
                (edge as Map<String, dynamic>)['node'] as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      ToastUtils.showError('Error loading collections: $e');
    } finally {
      _isLoadingCollections = false;
      notifyListeners();
    }
  }

  // Get products by collection handle
  Future<List<Product>> getProductsByCollectionHandle(String handle) async {
    try {
      final response = await _apiService.getCollectionByHandle(handle);
      final collectionData = response['data']?['collectionByHandle'];

      if (collectionData != null) {
        final productsData = collectionData['products']?['edges'] as List?;
        if (productsData != null) {
          return productsData
              .map((edge) => Product.fromJson((edge
                  as Map<String, dynamic>)['node'] as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      ToastUtils.showError('Error loading collection products: $e');
    }
    return [];
  }

  // Get collection title and products by handle (for product listing page)
  Future<({String title, List<Product> products})> getCollectionWithProducts(
      String handle) async {
    try {
      final response = await _apiService.getCollectionByHandle(handle);
      final collectionData = response['data']?['collectionByHandle'];

      if (collectionData != null) {
        final title = collectionData['title'] as String? ?? '';
        final productsData = collectionData['products']?['edges'] as List?;
        final products = productsData != null
            ? productsData
                .map((edge) => Product.fromJson((edge
                    as Map<String, dynamic>)['node'] as Map<String, dynamic>))
                .toList()
            : <Product>[];
        return (title: title, products: products);
      }
    } catch (e) {
      ToastUtils.showError('Error loading collection: $e');
    }
    return (title: '', products: <Product>[]);
  }
}
