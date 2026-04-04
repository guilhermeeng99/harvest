part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class OrdersLoadRequested extends OrdersEvent {
  const OrdersLoadRequested();
}

class OrderCancelRequested extends OrdersEvent {
  const OrderCancelRequested({required this.orderId});

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}
