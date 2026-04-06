import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

void main() {
  group('ProductEntity', () {
    const product = ProductEntity(
      id: '1',
      name: 'Organic Tomato',
      description: 'Fresh organic tomatoes',
      price: 4.99,
      unit: 'kg',
      categoryId: 'cat-1',
      imageUrl: 'https://example.com/tomato.jpg',
      farmName: 'Green Valley Farm',
      isFeatured: true,
      isOrganic: true,
      stock: 10,
    );

    test('inStock returns true when stock > 0', () {
      expect(product.inStock, isTrue);
    });

    test('inStock returns false when stock is 0', () {
      const outOfStock = ProductEntity(
        id: '2',
        name: 'Sold Out Item',
        description: 'No stock',
        price: 1,
        unit: 'kg',
        categoryId: 'cat-1',
        imageUrl: '',
        farmName: 'Farm',
      );
      expect(outOfStock.inStock, isFalse);
    });

    test('supports value equality', () {
      const sameProduct = ProductEntity(
        id: '1',
        name: 'Organic Tomato',
        description: 'Fresh organic tomatoes',
        price: 4.99,
        unit: 'kg',
        categoryId: 'cat-1',
        imageUrl: 'https://example.com/tomato.jpg',
        farmName: 'Green Valley Farm',
        isFeatured: true,
        isOrganic: true,
        stock: 10,
      );
      expect(product, equals(sameProduct));
    });

    test('different id produces different entity', () {
      const differentProduct = ProductEntity(
        id: '999',
        name: 'Organic Tomato',
        description: 'Fresh organic tomatoes',
        price: 4.99,
        unit: 'kg',
        categoryId: 'cat-1',
        imageUrl: 'https://example.com/tomato.jpg',
        farmName: 'Green Valley Farm',
        isFeatured: true,
        isOrganic: true,
        stock: 10,
      );
      expect(product, isNot(equals(differentProduct)));
    });

    test('defaults isFeatured and isOrganic to false', () {
      const defaults = ProductEntity(
        id: '3',
        name: 'Basic',
        description: '',
        price: 1,
        unit: 'kg',
        categoryId: 'cat-1',
        imageUrl: '',
        farmName: 'Farm',
      );
      expect(defaults.isFeatured, isFalse);
      expect(defaults.isOrganic, isFalse);
      expect(defaults.stock, 0);
      expect(defaults.nutritionFacts, isNull);
    });
  });

  group('NutritionFacts', () {
    test('supports value equality', () {
      const a = NutritionFacts(calories: '100', protein: '5g');
      const b = NutritionFacts(calories: '100', protein: '5g');
      expect(a, equals(b));
    });

    test('allows all null fields', () {
      const empty = NutritionFacts();
      expect(empty.calories, isNull);
      expect(empty.protein, isNull);
      expect(empty.fiber, isNull);
      expect(empty.vitamins, isNull);
    });
  });
}
