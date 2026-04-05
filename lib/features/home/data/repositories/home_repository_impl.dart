import 'package:dartz/dartz.dart';
import 'package:harvest/core/cache/app_data_cache.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/data/datasources/home_remote_datasource.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource, this._cache);

  final HomeRemoteDataSource _dataSource;
  final AppDataCache _cache;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.hasCategories) {
      return Right(_cache.categories!);
    }
    try {
      final categories = await _dataSource.getCategories();
      _cache.categories = categories;
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.hasFeaturedProducts) {
      return Right(_cache.featuredProducts!);
    }
    try {
      final products = await _dataSource.getFeaturedProducts();
      _cache.featuredProducts = products;
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  ) async {
    if (_cache.hasAllProducts) {
      final filtered = _cache.allProducts!
          .where((p) => p.categoryId == categoryId)
          .toList();
      return Right(filtered);
    }
    try {
      final products = await _dataSource.getProductsByCategory(categoryId);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.hasAllProducts) {
      return Right(_cache.allProducts!);
    }
    try {
      final products = await _dataSource.getAllProducts();
      _cache.allProducts = products;
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    if (_cache.hasAllProducts) {
      final matches = _cache.allProducts!.where((p) => p.id == id);
      if (matches.isNotEmpty) return Right(matches.first);
    }
    try {
      final product = await _dataSource.getProductById(id);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
