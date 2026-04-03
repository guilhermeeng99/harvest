part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutSubmitted extends CheckoutEvent {
  const CheckoutSubmitted(this.items);

  final List<CartItemEntity> items;

  @override
  List<Object?> get props => [items];
}

class CheckoutAddressUpdated extends CheckoutEvent {
  const CheckoutAddressUpdated(this.address);

  final DeliveryAddress address;

  @override
  List<Object?> get props => [address];
}

class CheckoutPaymentMethodUpdated extends CheckoutEvent {
  const CheckoutPaymentMethodUpdated(this.method);

  final String method;

  @override
  List<Object?> get props => [method];
}
