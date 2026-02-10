import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiService {
  // Get all products
  Future<Map<String, dynamic>> getAllProducts() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'query': ApiConstants.getAllProductsQuery,
          'variables': null,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Get collections
  Future<Map<String, dynamic>> getCollections({int first = 10}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'query': ApiConstants.getCollectionsQuery,
          'variables': {'first': first},
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load collections: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching collections: $e');
    }
  }

  // Get collection by handle
  Future<Map<String, dynamic>> getCollectionByHandle(String handle) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'query': ApiConstants.getCollectionByHandleQuery,
          'variables': {'handle': handle},
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load collection: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching collection: $e');
    }
  }

  // Get product by handle
  Future<Map<String, dynamic>> getProductByHandle(String handle) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'query': ApiConstants.getProductByHandleQuery,
          'variables': {'handle': handle},
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // Create cart
  Future<Map<String, dynamic>> createCart({
    required String variantId,
    int quantity = 1,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'query': ApiConstants.createCartMutation,
          'variables': {
            'variantId': variantId,
            'quantity': quantity,
          },
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating cart: $e');
    }
  }

  // Get cart
  Future<Map<String, dynamic>> getCart(String cartId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'query': ApiConstants.getCartQuery,
          'variables': {'cartId': cartId},
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  // Add to cart
  Future<Map<String, dynamic>> addToCart({
    required String cartId,
    required String variantId,
    int quantity = 1,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'query': ApiConstants.addToCartMutation,
          'variables': {
            'cartId': cartId,
            'variantId': variantId,
            'quantity': quantity,
          },
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding to cart: $e');
    }
  }

  // Update cart items (also handles removal when quantity = 0)
  Future<Map<String, dynamic>> updateCartItems({
    required String cartId,
    required String lineItemId,
    required int quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'query': ApiConstants.updateCartItemsMutation,
          'variables': {
            'cartId': cartId,
            'lines': [
              {
                'id': lineItemId,
                'quantity': quantity,
              }
            ],
          },
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating cart: $e');
    }
  }
}
