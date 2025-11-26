import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductsEvent {
  final String? search;
  final String? category;
  final double? minPrice;
  final double? maxPrice;

  const LoadProducts({
    this.search,
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [search, category, minPrice, maxPrice];
}

class LoadProductDetails extends ProductsEvent {
  final String productId;

  const LoadProductDetails({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class RefreshProducts extends ProductsEvent {}
