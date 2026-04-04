import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_orders_state.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  AdminOrdersCubit(this._repository) : super(const AdminOrdersState());

  final AdminRepository _repository;

  Future<void> loadOrders() async {
    emit(state.copyWith(status: AdminOrdersStatus.loading));
    final result = await _repository.getAllOrders();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminOrdersStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (orders) => emit(
        state.copyWith(status: AdminOrdersStatus.loaded, orders: orders),
      ),
    );
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final result = await _repository.updateOrderStatus(orderId, status);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedOrders = state.orders.map((order) {
          if (order.id == orderId) {
            return OrderEntity(
              id: order.id,
              userId: order.userId,
              items: order.items,
              totalAmount: order.totalAmount,
              status: status,
              deliveryAddress: order.deliveryAddress,
              createdAt: order.createdAt,
            );
          }
          return order;
        }).toList();
        emit(state.copyWith(orders: updatedOrders));
      },
    );
  }
}
