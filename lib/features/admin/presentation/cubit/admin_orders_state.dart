import 'package:equatable/equatable.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';

enum AdminOrdersStatus { initial, loading, loaded, error }

class AdminOrdersState extends Equatable {
  const AdminOrdersState({
    this.status = AdminOrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  final AdminOrdersStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;

  AdminOrdersState copyWith({
    AdminOrdersStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
  }) {
    return AdminOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage];
}
