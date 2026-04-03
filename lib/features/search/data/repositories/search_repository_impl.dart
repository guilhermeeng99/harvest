import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/search/data/datasources/search_remote_datasource.dart';
import 'package:harvest/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._dataSource);

  final SearchRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    String? categoryId,
    bool? organicOnly,
    double? minPrice,
    double? maxPrice,
  }) async {
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
