class ProductModel {
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

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? json['nome'] as String? ?? '',
      description:
          json['description'] as String? ?? json['descricao'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ??
          (json['preco'] as num?)?.toDouble() ??
          0.0,
      category:
          json['category'] as String? ?? json['categoria'] as String? ?? '',
      images: _parseImages(json),
      material: json['material'] as String? ?? '',
      hasDiscount: json['hasDiscount'] as bool? ??
          json['has_discount'] as bool? ??
          false,
      discountValue: (json['discountValue'] as num?)?.toDouble() ??
          (json['discount_value'] as num?)?.toDouble() ??
          0.0,
      provider: json['provider'] as String? ?? 'unknown',
    );
  }

  static List<String> _parseImages(Map<String, dynamic> json) {
    final images = json['images'];
    final gallery = json['gallery'];
    final image = json['image'];
    final imagem = json['imagem'];

    if (images is List) {
      return images.map((e) => e.toString()).toList();
    }
    if (gallery is List) {
      return gallery.map((e) => e.toString()).toList();
    }
    if (image is String && image.isNotEmpty) {
      return [image];
    }
    if (imagem is String && imagem.isNotEmpty) {
      return [imagem];
    }
    return [];
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

  @override
  String toString() => 'ProductModel(id: $id, name: $name, price: $price)';
}
