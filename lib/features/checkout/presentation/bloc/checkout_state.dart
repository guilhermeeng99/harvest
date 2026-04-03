part of 'checkout_bloc.dart';

enum CheckoutStatus { initial, loading, success, error }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.deliveryAddress,
    this.paymentMethod = 'Credit Card',
    this.order,
    this.errorMessage,
  });

  final CheckoutStatus status;
  final DeliveryAddress? deliveryAddress;
  final String paymentMethod;
  final OrderEntity? order;
  final String? errorMessage;

  CheckoutState copyWith({
    CheckoutStatus? status,
    DeliveryAddress? deliveryAddress,
    String? paymentMethod,
    OrderEntity? order,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      order: order ?? this.order,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    deliveryAddress,
    paymentMethod,
    order,
    errorMessage,
  ];
}
