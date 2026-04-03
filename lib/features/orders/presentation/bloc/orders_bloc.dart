import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/domain/usecases/get_orders_usecase.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({required GetOrdersUseCase getOrdersUseCase})
    : _getOrdersUseCase = getOrdersUseCase,
      super(const OrdersState()) {
    on<OrdersLoadRequested>(_onLoadRequested);
  }

  final GetOrdersUseCase _getOrdersUseCase;

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
}
