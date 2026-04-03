import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  harvesting,
  delivering,
  delivered;
}

class OrderItemEntity extends Equatable {
  const OrderItemEntity({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.unit,
  });

  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String unit;

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [productId, name, quantity, price, unit];
}

class OrderEntity extends Equatable {
  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final OrderStatus status;
  final DeliveryAddress deliveryAddress;
  final DateTime createdAt;

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        totalAmount,
        status,
        deliveryAddress,
        createdAt,
      ];
}

class DeliveryAddress extends Equatable {
  const DeliveryAddress({
    required this.street,
    required this.city,
    required this.zipCode,
  });

  final String street;
  final String city;
  final String zipCode;

  @override
  List<Object?> get props => [street, city, zipCode];
}
