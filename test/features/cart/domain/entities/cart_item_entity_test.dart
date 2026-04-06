import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

void main() {
  const product = ProductEntity(
    id: '1',
    name: 'Organic Apple',
    description: 'Fresh apples',
    price: 3.50,
    unit: 'kg',
    categoryId: 'cat-1',
    imageUrl: '',
    farmName: 'Farm',
    stock: 20,
  );

  group('CartItemEntity', () {
    test('totalPrice is price * quantity', () {
      const item = CartItemEntity(product: product, quantity: 3);
      expect(item.totalPrice, 3.50 * 3);
    });

    test('totalPrice for single item equals product price', () {
      const item = CartItemEntity(product: product, quantity: 1);
      expect(item.totalPrice, 3.50);
    });

    test('copyWith updates quantity', () {
      const item = CartItemEntity(product: product, quantity: 1);
      final updated = item.copyWith(quantity: 5);
      expect(updated.quantity, 5);
      expect(updated.product, product);
    });

    test('copyWith without arguments returns equal entity', () {
      const item = CartItemEntity(product: product, quantity: 2);
      final copy = item.copyWith();
      expect(copy, equals(item));
    });

    test('supports value equality', () {
      const a = CartItemEntity(product: product, quantity: 2);
      const b = CartItemEntity(product: product, quantity: 2);
      expect(a, equals(b));
    });

    test('different quantity produces different entity', () {
      const a = CartItemEntity(product: product, quantity: 1);
      const b = CartItemEntity(product: product, quantity: 2);
      expect(a, isNot(equals(b)));
    });
  });
}
