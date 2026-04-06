import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/core/cache/app_data_cache.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/data/datasources/home_remote_datasource.dart';
import 'package:harvest/features/home/data/models/category_model.dart';
import 'package:harvest/features/home/data/models/product_model.dart';
import 'package:harvest/features/home/data/repositories/home_repository_impl.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late HomeRepositoryImpl repository;
  late MockHomeRemoteDataSource mockDataSource;
  late AppDataCache cache;

  final tCategories = [
    const CategoryModel(id: '1', name: 'Fruits', imageUrl: 'fruits.jpg'),
    const CategoryModel(id: '2', name: 'Vegetables', imageUrl: 'veg.jpg'),
  ];

  final tProducts = [
    const ProductModel(
      id: '1',
      name: 'Apple',
      description: 'Fresh apple',
      price: 2.99,
      unit: 'kg',
      categoryId: '1',
      imageUrl: 'apple.jpg',
      farmName: 'Farm A',
      isFeatured: true,
      stock: 10,
    ),
    const ProductModel(
      id: '2',
      name: 'Carrot',
      description: 'Organic carrot',
      price: 1.50,
      unit: 'kg',
      categoryId: '2',
      imageUrl: 'carrot.jpg',
      farmName: 'Farm B',
      stock: 5,
    ),
  ];

  setUp(() {
    mockDataSource = MockHomeRemoteDataSource();
    cache = AppDataCache();
    repository = HomeRepositoryImpl(mockDataSource, cache);
  });

  group('getCategories', () {
    test('returns categories from data source on first call', () async {
      when(
        () => mockDataSource.getCategories(),
      ).thenAnswer((_) async => tCategories);

      final result = await repository.getCategories();

      expect(result, equals(Right<Failure, List<CategoryModel>>(tCategories)));
      verify(() => mockDataSource.getCategories()).called(1);
    });

    test('returns cached categories on subsequent call', () async {
      when(
        () => mockDataSource.getCategories(),
      ).thenAnswer((_) async => tCategories);

      await repository.getCategories(); // populates cache
      final result = await repository.getCategories(); // from cache

      expect(result, equals(Right<Failure, List<CategoryModel>>(tCategories)));
      verify(() => mockDataSource.getCategories()).called(1); // only once
    });

    test('bypasses cache when forceRefresh is true', () async {
      when(
        () => mockDataSource.getCategories(),
      ).thenAnswer((_) async => tCategories);

      await repository.getCategories(); // populates cache
      await repository.getCategories(forceRefresh: true);

      verify(() => mockDataSource.getCategories()).called(2);
    });

    test('returns ServerFailure on ServerException', () async {
      when(
        () => mockDataSource.getCategories(),
      ).thenThrow(const ServerException('network error'));

      final result = await repository.getCategories();

      expect(
        result,
        equals(
          const Left<Failure, List<CategoryEntity>>(
            ServerFailure('network error'),
          ),
        ),
      );
    });
  });

  group('getAllProducts', () {
    test('returns products from data source', () async {
      when(
        () => mockDataSource.getAllProducts(),
      ).thenAnswer((_) async => tProducts);

      final result = await repository.getAllProducts();

      expect(result, equals(Right<Failure, List<ProductModel>>(tProducts)));
    });

    test('caches products after fetching', () async {
      when(
        () => mockDataSource.getAllProducts(),
      ).thenAnswer((_) async => tProducts);

      await repository.getAllProducts();

      expect(cache.allProducts, tProducts);
      expect(cache.hasAllProducts, isTrue);
    });

    test('returns ServerFailure on exception', () async {
      when(
        () => mockDataSource.getAllProducts(),
      ).thenThrow(const ServerException('fail'));

      final result = await repository.getAllProducts();

      expect(result.isLeft(), isTrue);
    });
  });

  group('getProductsByCategory', () {
    test('filters from cache when available', () async {
      // Pre-populate cache
      when(
        () => mockDataSource.getAllProducts(),
      ).thenAnswer((_) async => tProducts);
      await repository.getAllProducts();

      final result = await repository.getProductsByCategory('1');

      result.fold(
        (_) => fail('Should be Right'),
        (products) {
          expect(products.length, 1);
          expect(products.first.name, 'Apple');
        },
      );
      // Should NOT call getProductsByCategory on dataSource
      verifyNever(() => mockDataSource.getProductsByCategory(any()));
    });

    test('fetches from data source when cache is empty', () async {
      when(
        () => mockDataSource.getProductsByCategory('1'),
      ).thenAnswer((_) async => [tProducts.first]);

      final result = await repository.getProductsByCategory('1');

      result.fold(
        (_) => fail('Should be Right'),
        (products) => expect(products.length, 1),
      );
      verify(() => mockDataSource.getProductsByCategory('1')).called(1);
    });
  });

  group('getProductById', () {
    test('returns product from cache if available', () async {
      when(
        () => mockDataSource.getAllProducts(),
      ).thenAnswer((_) async => tProducts);
      await repository.getAllProducts();

      final result = await repository.getProductById('1');

      result.fold(
        (_) => fail('Should be Right'),
        (product) => expect(product.name, 'Apple'),
      );
      verifyNever(() => mockDataSource.getProductById(any()));
    });

    test('fetches from data source when not in cache', () async {
      when(
        () => mockDataSource.getProductById('1'),
      ).thenAnswer((_) async => tProducts.first);

      final result = await repository.getProductById('1');

      result.fold(
        (_) => fail('Should be Right'),
        (product) => expect(product.name, 'Apple'),
      );
    });
  });
}
