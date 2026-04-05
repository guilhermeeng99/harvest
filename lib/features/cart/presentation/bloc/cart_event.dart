part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartLoadRequested extends CartEvent {
  const CartLoadRequested();
}

class CartItemAdded extends CartEvent {
  const CartItemAdded(this.product);

  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
}

class CartItemQuantityUpdated extends CartEvent {
  const CartItemQuantityUpdated({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

class CartCleared extends CartEvent {
  const CartCleared();
}
