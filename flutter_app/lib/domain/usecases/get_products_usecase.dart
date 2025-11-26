import '../../data/repositories/products_repository_impl.dart';
import '../entities/product_entity.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<ProductEntity>> call({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) {
    return _repository.getProducts(
      search: search,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}
