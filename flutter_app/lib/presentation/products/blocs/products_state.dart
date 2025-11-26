import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductDetailsLoaded extends ProductsState {
  final ProductEntity product;

  const ProductDetailsLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
