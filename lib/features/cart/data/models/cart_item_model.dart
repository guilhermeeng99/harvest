import 'dart:convert';

import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

class CartItemModel {
  const CartItemModel({required this.product, required this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: _productFromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      product: entity.product,
      quantity: entity.quantity,
    );
  }

  final ProductEntity product;
  final int quantity;

  CartItemEntity toEntity() => CartItemEntity(
    product: product,
    quantity: quantity,
  );

  Map<String, dynamic> toJson() => {
    'product': _productToJson(product),
    'quantity': quantity,
  };

  static Map<String, dynamic> _productToJson(ProductEntity p) => {
    'id': p.id,
    'name': p.name,
    'description': p.description,
    'price': p.price,
    'unit': p.unit,
    'categoryId': p.categoryId,
    'imageUrl': p.imageUrl,
    'farmName': p.farmName,
    'isFeatured': p.isFeatured,
    'isOrganic': p.isOrganic,
    'stock': p.stock,
  };

  static ProductEntity _productFromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'kg',
      categoryId: json['categoryId'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      farmName: json['farmName'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      isOrganic: json['isOrganic'] as bool? ?? false,
      stock: json['stock'] as int? ?? 0,
    );
  }

  static String encodeList(List<CartItemEntity> items) {
    final models = items.map(CartItemModel.fromEntity).toList();
    return jsonEncode(models.map((m) => m.toJson()).toList());
  }

  static List<CartItemEntity> decodeList(String jsonStr) {
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .map((m) => m.toEntity())
        .toList();
  }
}
