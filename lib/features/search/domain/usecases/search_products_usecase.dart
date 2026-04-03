import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/search/domain/repositories/search_repository.dart';

class SearchProductsUseCase {
  const SearchProductsUseCase(this._repository);

  final SearchRepository _repository;

  Future<Either<Failure, List<ProductEntity>>> call({
    required String query,
    String? categoryId,
    bool? organicOnly,
    double? minPrice,
    double? maxPrice,
  }) {
    return _repository.searchProducts(
      query: query,
      categoryId: categoryId,
      organicOnly: organicOnly,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}
