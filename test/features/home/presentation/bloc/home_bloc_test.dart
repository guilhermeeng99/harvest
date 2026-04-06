import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_featured_products_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_products_by_category_usecase.dart';
import 'package:harvest/features/home/presentation/bloc/home_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllProductsUseCase extends Mock implements GetAllProductsUseCase {}

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

class MockGetFeaturedProductsUseCase extends Mock
    implements GetFeaturedProductsUseCase {}

class MockGetProductsByCategoryUseCase extends Mock
    implements GetProductsByCategoryUseCase {}

void main() {
  late MockGetAllProductsUseCase mockGetAllProducts;
  late MockGetCategoriesUseCase mockGetCategories;
  late MockGetFeaturedProductsUseCase mockGetFeatured;
  late MockGetProductsByCategoryUseCase mockGetByCategory;

  const tCategories = [
    CategoryEntity(id: '1', name: 'Fruits', imageUrl: 'fruits.jpg'),
    CategoryEntity(id: '2', name: 'Vegetables', imageUrl: 'veg.jpg'),
  ];

  const tFeatured = [
    ProductEntity(
      id: '1',
      name: 'Apple',
      description: 'Fresh',
      price: 2.99,
      unit: 'kg',
      categoryId: '1',
      imageUrl: 'apple.jpg',
      farmName: 'Farm A',
      isFeatured: true,
      stock: 10,
    ),
  ];

  const tAllProducts = [
    ProductEntity(
      id: '1',
      name: 'Apple',
      description: 'Fresh',
      price: 2.99,
      unit: 'kg',
      categoryId: '1',
      imageUrl: 'apple.jpg',
      farmName: 'Farm A',
      isFeatured: true,
      stock: 10,
    ),
    ProductEntity(
      id: '2',
      name: 'Carrot',
      description: 'Organic',
      price: 1.50,
      unit: 'kg',
      categoryId: '2',
      imageUrl: 'carrot.jpg',
      farmName: 'Farm B',
      stock: 5,
    ),
  ];

  setUp(() {
    mockGetAllProducts = MockGetAllProductsUseCase();
    mockGetCategories = MockGetCategoriesUseCase();
    mockGetFeatured = MockGetFeaturedProductsUseCase();
    mockGetByCategory = MockGetProductsByCategoryUseCase();
  });

  HomeBloc buildBloc() => HomeBloc(
    getAllProductsUseCase: mockGetAllProducts,
    getCategoriesUseCase: mockGetCategories,
    getFeaturedProductsUseCase: mockGetFeatured,
    getProductsByCategoryUseCase: mockGetByCategory,
  );

  void arrangeSuccessfulLoad() {
    when(
      () => mockGetCategories(forceRefresh: any(named: 'forceRefresh')),
    ).thenAnswer((_) async => const Right(tCategories));
    when(
      () => mockGetFeatured(forceRefresh: any(named: 'forceRefresh')),
    ).thenAnswer((_) async => const Right(tFeatured));
    when(
      () => mockGetAllProducts(forceRefresh: any(named: 'forceRefresh')),
    ).thenAnswer((_) async => const Right(tAllProducts));
  }

  group('HomeBloc', () {
    test('initial state is correct', () {
      arrangeSuccessfulLoad();
      final bloc = buildBloc();
      expect(bloc.state.status, HomeStatus.initial);
      expect(bloc.state.categories, isEmpty);
      expect(bloc.state.featuredProducts, isEmpty);
      expect(bloc.state.allProducts, isEmpty);
    });

    blocTest<HomeBloc, HomeState>(
      'HomeLoadRequested emits loading then loaded on success',
      setUp: arrangeSuccessfulLoad,
      build: buildBloc,
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.loaded,
          categories: tCategories,
          featuredProducts: tFeatured,
          allProducts: tAllProducts,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'HomeLoadRequested does nothing if already loaded',
      setUp: arrangeSuccessfulLoad,
      build: buildBloc,
      seed: () => const HomeState(status: HomeStatus.loaded),
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => <HomeState>[],
    );

    blocTest<HomeBloc, HomeState>(
      'HomeRefreshRequested forces refresh even if loaded',
      setUp: arrangeSuccessfulLoad,
      build: buildBloc,
      seed: () => const HomeState(status: HomeStatus.loaded),
      act: (bloc) => bloc.add(const HomeRefreshRequested()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.loaded,
          categories: tCategories,
          featuredProducts: tFeatured,
          allProducts: tAllProducts,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetCategories(forceRefresh: true),
        ).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits error when both categories and featured fail',
      setUp: () {
        when(
          () => mockGetCategories(forceRefresh: any(named: 'forceRefresh')),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('fail')),
        );
        when(
          () => mockGetFeatured(forceRefresh: any(named: 'forceRefresh')),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('fail')),
        );
        when(
          () => mockGetAllProducts(forceRefresh: any(named: 'forceRefresh')),
        ).thenAnswer((_) async => const Left(ServerFailure('fail')));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.error,
          errorMessage: 'Failed to load home data',
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'HomeCategorySelected loads products for category',
      setUp: () {
        when(
          () => mockGetByCategory('1'),
        ).thenAnswer((_) async => const Right(tFeatured));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const HomeCategorySelected('1')),
      expect: () => [
        const HomeState(
          selectedCategoryId: '1',
          categoryProductsStatus: HomeStatus.loading,
        ),
        const HomeState(
          selectedCategoryId: '1',
          categoryProductsStatus: HomeStatus.loaded,
          categoryProducts: tFeatured,
        ),
      ],
    );
  });
}
