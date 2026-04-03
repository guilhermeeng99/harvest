import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, OrderEntity>> placeOrder({
    required List<CartItemEntity> items,
    required DeliveryAddress deliveryAddress,
    required String paymentMethod,
  });
}
