import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:harvest/features/orders/domain/usecases/get_orders_usecase.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
  }) : _getOrdersUseCase = getOrdersUseCase,
       _cancelOrderUseCase = cancelOrderUseCase,
       super(const OrdersState()) {
    on<OrdersLoadRequested>(_onLoadRequested);
    on<OrderCancelRequested>(_onCancelRequested);
  }

  final GetOrdersUseCase _getOrdersUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  Future<void> _onLoadRequested(
    OrdersLoadRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));

    final result = await _getOrdersUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrdersStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (orders) =>
          emit(state.copyWith(status: OrdersStatus.loaded, orders: orders)),
    );
  }

  Future<void> _onCancelRequested(
    OrderCancelRequested event,
    Emitter<OrdersState> emit,
  ) async {
    final result = await _cancelOrderUseCase(event.orderId);

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.message),
      ),
      (_) {
        final updatedOrders = state.orders.map((order) {
          if (order.id == event.orderId) {
            return OrderEntity(
              id: order.id,
              userId: order.userId,
              items: order.items,
              totalAmount: order.totalAmount,
              status: OrderStatus.cancelled,
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
