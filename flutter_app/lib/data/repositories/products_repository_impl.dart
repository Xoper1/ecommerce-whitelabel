import '../../domain/entities/product_entity.dart';
import '../providers/products_provider.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  });
  Future<ProductEntity> getProductById(String id);
  Future<List<String>> getCategories();
}

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsProvider _provider;

  ProductsRepositoryImpl(this._provider);

  @override
  Future<List<ProductEntity>> getProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    return await _provider.getProducts(
      search: search,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    return await _provider.getProductById(id);
  }

  @override
  Future<List<String>> getCategories() async {
    return await _provider.getCategories();
  }
}
