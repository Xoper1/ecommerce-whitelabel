import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductsProvider {
  final ApiClient _apiClient;

  ProductsProvider(this._apiClient);

  Future<List<ProductModel>> getProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;
      if (category != null) queryParams['category'] = category;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;

      final response = await _apiClient.dio.get(
        '/products',
        queryParameters: queryParams,
      );

      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load products');
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Product not found');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('/products/categories');
      return (response.data as List).map((e) => e as String).toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to load categories');
    }
  }
}
