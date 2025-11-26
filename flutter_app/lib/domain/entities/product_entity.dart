import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final String material;
  final bool hasDiscount;
  final double discountValue;
  final String provider;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.material,
    required this.hasDiscount,
    required this.discountValue,
    required this.provider,
  });

  double get finalPrice {
    if (hasDiscount) {
      return price * (1 - discountValue);
    }
    return price;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        category,
        images,
        material,
        hasDiscount,
        discountValue,
        provider,
      ];
}
