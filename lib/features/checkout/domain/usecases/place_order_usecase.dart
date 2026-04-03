import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/checkout/domain/repositories/checkout_repository.dart';

class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Either<Failure, OrderEntity>> call({
    required List<CartItemEntity> items,
    required DeliveryAddress deliveryAddress,
    required String paymentMethod,
  }) {
    return _repository.placeOrder(
      items: items,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
    );
  }
}
