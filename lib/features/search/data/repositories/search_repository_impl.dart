import 'package:dartz/dartz.dart';
import 'package:harvest/core/cache/app_data_cache.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/search/data/datasources/search_remote_datasource.dart';
import 'package:harvest/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._dataSource, this._cache);

  final SearchRemoteDataSource _dataSource;
  final AppDataCache _cache;

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    String? categoryId,
    bool? organicOnly,
    double? minPrice,
    double? maxPrice,
  }) async {
    if (_cache.hasAllProducts) {
      var products = _cache.allProducts!;
      if (query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        products = products.where((p) {
          return p.name.toLowerCase().contains(lowerQuery) ||
              p.description.toLowerCase().contains(lowerQuery) ||
              p.farmName.toLowerCase().contains(lowerQuery);
        }).toList();
      }
      if (categoryId != null) {
        products = products.where((p) => p.categoryId == categoryId).toList();
      }
      if (organicOnly == true) {
        products = products.where((p) => p.isOrganic).toList();
      }
      if (minPrice != null) {
        products = products.where((p) => p.price >= minPrice).toList();
      }
      if (maxPrice != null) {
        products = products.where((p) => p.price <= maxPrice).toList();
      }
      return Right(products);
    }
    try {
      final products = await _dataSource.searchProducts(
        query: query,
        categoryId: categoryId,
        organicOnly: organicOnly,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
