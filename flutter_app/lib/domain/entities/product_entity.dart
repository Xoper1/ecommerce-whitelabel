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

  /// Retorna o preço com desconto aplicado
  double get finalPrice {
    if (hasDiscount && discountValue > 0) {
      return price - discountValue;
    }
    return price;
  }

  /// Retorna percentual de desconto
  double get discountPercentage {
    if (hasDiscount && discountValue > 0 && price > 0) {
      return (discountValue / price) * 100;
    }
    return 0;
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
