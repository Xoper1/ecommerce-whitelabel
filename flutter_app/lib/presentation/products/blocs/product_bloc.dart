import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/domain/entities/product_entity.dart';
import 'package:flutter_ecommerce/domain/usecases/product_usecases.dart';

/// Estados do BLoC de Produtos
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductEvent {
  final String? search;
  final String? category;
  final double? minPrice;
  final double? maxPrice;

  const FetchProductsEvent({
    this.search,
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [search, category, minPrice, maxPrice];
}

class FetchCategoriesEvent extends ProductEvent {
  const FetchCategoriesEvent();
}

/// Estados
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final List<String> categories;

  const ProductLoaded({
    required this.products,
    required this.categories,
  });

  @override
  List<Object?> get props => [products, categories];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// BLoC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  List<ProductEntity> _allProducts = [];
  List<String> _categories = [];

  ProductBloc({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(const ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FetchCategoriesEvent>(_onFetchCategories);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final products = await getProductsUseCase(
        search: event.search,
        category: event.category,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      );

      _allProducts = products;

      emit(ProductLoaded(
        products: products,
        categories: _categories,
      ));
    } catch (e) {
      emit(ProductError(message: 'Erro ao buscar produtos: $e'));
    }
  }

  Future<void> _onFetchCategories(
    FetchCategoriesEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      _categories = await getCategoriesUseCase();

      emit(ProductLoaded(
        products: _allProducts,
        categories: _categories,
      ));
    } catch (e) {
      emit(ProductError(message: 'Erro ao buscar categorias: $e'));
    }
  }
}
