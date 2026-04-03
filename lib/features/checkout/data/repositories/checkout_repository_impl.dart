import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:harvest/features/orders/data/models/order_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<Either<Failure, OrderEntity>> placeOrder({
    required List<CartItemEntity> items,
    required DeliveryAddress deliveryAddress,
    required String paymentMethod,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw const AuthException('User not authenticated');

      final totalAmount = items.fold<double>(
        0,
        (acc, item) => acc + item.totalPrice,
      );

      final orderModel = OrderModel(
        id: '',
        userId: user.uid,
        items: items
            .map(
              (e) => OrderItemEntity(
                productId: e.product.id,
                name: e.product.name,
                quantity: e.quantity,
                price: e.product.price,
                unit: e.product.unit,
              ),
            )
            .toList(),
        totalAmount: totalAmount,
        status: OrderStatus.pending,
        deliveryAddress: deliveryAddress,
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection('orders')
          .add(orderModel.toFirestore());

      return Right(
        OrderModel(
          id: docRef.id,
          userId: orderModel.userId,
          items: orderModel.items,
          totalAmount: orderModel.totalAmount,
          status: orderModel.status,
          deliveryAddress: orderModel.deliveryAddress,
          createdAt: orderModel.createdAt,
        ),
      );
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
