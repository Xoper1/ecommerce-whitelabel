import 'package:flutter_ecommerce/core/network/api_client.dart';
import 'package:flutter_ecommerce/data/providers/product_provider.dart';
import 'package:flutter_ecommerce/data/repositories/product_repository.dart';
import 'package:flutter_ecommerce/domain/usecases/product_usecases.dart';
import 'package:flutter_ecommerce/presentation/products/blocs/product_bloc.dart';

/// Classe para centralizar a injeção de dependências
///
/// Uso:
/// ```dart
/// final productBloc = getProductBloc();
/// ```
class ServiceLocator {
  static final _apiClient = ApiClient();
  static final _productProvider = ProductProvider(apiClient: _apiClient);
  static final _productRepository = ProductRepository(
    productProvider: _productProvider,
  );

  // UseCases
  static final _getProductsUseCase = GetProductsUseCase(
    repository: _productRepository,
  );
  static final _getProductByIdUseCase = GetProductByIdUseCase(
    repository: _productRepository,
  );
  static final _getCategoriesUseCase = GetCategoriesUseCase(
    repository: _productRepository,
  );

  // BLoCs
  static ProductBloc getProductBloc() {
    return ProductBloc(
      getProductsUseCase: _getProductsUseCase,
      getCategoriesUseCase: _getCategoriesUseCase,
    );
  }
}
