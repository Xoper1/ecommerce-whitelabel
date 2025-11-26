import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/get_product_details_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductsBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetProductDetailsUseCase getProductDetailsUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getProductDetailsUseCase = getProductDetailsUseCase,
        super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetails>(_onLoadProductDetails);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    try {
      final products = await _getProductsUseCase(
        search: event.search,
        category: event.category,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      );
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    try {
      final product = await _getProductDetailsUseCase(event.productId);
      emit(ProductDetailsLoaded(product: product));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final products = await _getProductsUseCase();
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }
}
