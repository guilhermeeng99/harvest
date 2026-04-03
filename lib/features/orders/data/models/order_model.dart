import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.deliveryAddress,
    required super.createdAt,
  });

  factory OrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] as String,
      items: (data['items'] as List<dynamic>)
          .map(
            (e) => OrderItemEntity(
              productId: (e as Map<String, dynamic>)['productId'] as String,
              name: e['name'] as String,
              quantity: e['quantity'] as int,
              price: (e['price'] as num).toDouble(),
              unit: e['unit'] as String? ?? 'kg',
            ),
          )
          .toList(),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => OrderStatus.pending,
      ),
      deliveryAddress: DeliveryAddress(
        street:
            (data['deliveryAddress'] as Map<String, dynamic>)['street']
                as String,
        city:
            (data['deliveryAddress'] as Map<String, dynamic>)['city'] as String,
        zipCode:
            (data['deliveryAddress'] as Map<String, dynamic>)['zipCode']
                as String,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'items': items
            .map(
              (e) => {
                'productId': e.productId,
                'name': e.name,
                'quantity': e.quantity,
                'price': e.price,
                'unit': e.unit,
              },
            )
            .toList(),
        'totalAmount': totalAmount,
        'status': status.name,
        'deliveryAddress': {
          'street': deliveryAddress.street,
          'city': deliveryAddress.city,
          'zipCode': deliveryAddress.zipCode,
        },
        'createdAt': FieldValue.serverTimestamp(),
      };
}
