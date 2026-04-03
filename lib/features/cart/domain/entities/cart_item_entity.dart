import 'package:equatable/equatable.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.product,
    required this.quantity,
  });

  final ProductEntity product;
  final int quantity;

  double get totalPrice => product.price * quantity;

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
