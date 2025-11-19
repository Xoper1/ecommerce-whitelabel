import 'package:flutter_ecommerce/data/repositories/product_repository.dart';
import 'package:flutter_ecommerce/domain/entities/product_entity.dart';

class GetProductsUseCase {
  final IProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<List<ProductEntity>> call({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    return await repository.getProducts(
      search: search,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}

class GetProductByIdUseCase {
  final IProductRepository repository;

  GetProductByIdUseCase({required this.repository});

  Future<ProductEntity> call(String id) async {
    return await repository.getProductById(id);
  }
}

class GetCategoriesUseCase {
  final IProductRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<List<String>> call() async {
    return await repository.getCategories();
  }
}
