import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.category,
    required super.images,
    required super.material,
    required super.hasDiscount,
    required super.discountValue,
    required super.provider,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      material: json['material'] as String? ?? '',
      hasDiscount: json['hasDiscount'] as bool? ?? false,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      provider: json['provider'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'material': material,
      'hasDiscount': hasDiscount,
      'discountValue': discountValue,
      'provider': provider,
    };
  }
}
