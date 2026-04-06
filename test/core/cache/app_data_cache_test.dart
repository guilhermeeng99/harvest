import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/core/cache/app_data_cache.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

void main() {
  late AppDataCache cache;

  const tCategories = [
    CategoryEntity(id: '1', name: 'Fruits', imageUrl: 'f.jpg'),
  ];
  const tProducts = [
    ProductEntity(
      id: '1',
      name: 'Apple',
      description: '',
      price: 1,
      unit: 'kg',
      categoryId: '1',
      imageUrl: '',
      farmName: 'Farm',
    ),
  ];

  setUp(() {
    cache = AppDataCache();
  });

  group('AppDataCache', () {
    test('starts empty with all nullable fields as null', () {
      expect(cache.categories, isNull);
      expect(cache.allProducts, isNull);
      expect(cache.featuredProducts, isNull);
      expect(cache.currentUser, isNull);
      expect(cache.orders, isNull);
    });

    test('hasCategories returns true after setting categories', () {
      expect(cache.hasCategories, isFalse);
      cache.categories = tCategories;
      expect(cache.hasCategories, isTrue);
    });

    test('isFullyLoaded requires all three data sets', () {
      expect(cache.isFullyLoaded, isFalse);

      cache.categories = tCategories;
      expect(cache.isFullyLoaded, isFalse);

      cache.allProducts = tProducts;
      expect(cache.isFullyLoaded, isFalse);

      cache.featuredProducts = tProducts;
      expect(cache.isFullyLoaded, isTrue);
    });

    test('clear resets all cached data', () {
      cache
        ..categories = tCategories
        ..allProducts = tProducts
        ..featuredProducts = tProducts
        ..currentUser = const UserEntity(id: '1', email: 'a@b.com')
        ..orders = []
        ..clear();

      expect(cache.categories, isNull);
      expect(cache.allProducts, isNull);
      expect(cache.featuredProducts, isNull);
      expect(cache.currentUser, isNull);
      expect(cache.orders, isNull);
      expect(cache.isFullyLoaded, isFalse);
    });
  });
}
