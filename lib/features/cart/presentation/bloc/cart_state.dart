part of 'cart_bloc.dart';

class CartState extends Equatable {
  const CartState({this.items = const []});

  final List<CartItemEntity> items;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => subtotal > 50 ? 0 : 4.99;

  double get total => subtotal + deliveryFee;

  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartItemEntity>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
