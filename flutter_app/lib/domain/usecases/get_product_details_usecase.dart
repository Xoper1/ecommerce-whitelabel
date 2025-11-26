import '../../data/repositories/products_repository_impl.dart';
import '../entities/product_entity.dart';

class GetProductDetailsUseCase {
  final ProductsRepository _repository;

  GetProductDetailsUseCase(this._repository);

  Future<ProductEntity> call(String id) {
    return _repository.getProductById(id);
  }
}
