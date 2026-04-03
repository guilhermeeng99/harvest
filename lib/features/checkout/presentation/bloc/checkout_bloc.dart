import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/checkout/domain/usecases/place_order_usecase.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({required PlaceOrderUseCase placeOrderUseCase})
    : _placeOrderUseCase = placeOrderUseCase,
      super(const CheckoutState()) {
    on<CheckoutSubmitted>(_onSubmitted);
    on<CheckoutAddressUpdated>(_onAddressUpdated);
    on<CheckoutPaymentMethodUpdated>(_onPaymentMethodUpdated);
  }

  final PlaceOrderUseCase _placeOrderUseCase;

  void _onAddressUpdated(
    CheckoutAddressUpdated event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(deliveryAddress: event.address));
  }

  void _onPaymentMethodUpdated(
    CheckoutPaymentMethodUpdated event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state.deliveryAddress == null) return;

    emit(state.copyWith(status: CheckoutStatus.loading));

    final result = await _placeOrderUseCase(
      items: event.items,
      deliveryAddress: state.deliveryAddress!,
      paymentMethod: state.paymentMethod,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CheckoutStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (order) =>
          emit(state.copyWith(status: CheckoutStatus.success, order: order)),
    );
  }
}
