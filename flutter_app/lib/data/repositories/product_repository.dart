import 'package:flutter_ecommerce/data/models/product_model.dart';
import 'package:flutter_ecommerce/data/providers/product_provider.dart';
import 'package:flutter_ecommerce/domain/entities/product_entity.dart';

abstract class IProductRepository {
  Future<List<ProductEntity>> getProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  });

  Future<ProductEntity> getProductById(String id);

  Future<List<String>> getCategories();
}

class ProductRepository implements IProductRepository {
  final ProductProvider productProvider;

  ProductRepository({required this.productProvider});

  @override
  Future<List<ProductEntity>> getProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final models = await productProvider.getProducts(
        search: search,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

      return _modelsToEntities(models);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      final model = await productProvider.getProductById(id);
      return _modelToEntity(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await productProvider.getCategories();
    } catch (e) {
      rethrow;
    }
  }

  /// Converte lista de models para entities
  List<ProductEntity> _modelsToEntities(List<ProductModel> models) {
    return models.map((model) => _modelToEntity(model)).toList();
  }

  /// Converte um model para entity
  ProductEntity _modelToEntity(ProductModel model) {
    return ProductEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      price: model.price,
      category: model.category,
      images: model.images,
      material: model.material,
      hasDiscount: model.hasDiscount,
      discountValue: model.discountValue,
      provider: model.provider,
    );
  }
}
