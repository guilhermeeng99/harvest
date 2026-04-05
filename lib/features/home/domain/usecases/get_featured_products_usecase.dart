import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/home/domain/repositories/home_repository.dart';

class GetFeaturedProductsUseCase {
  const GetFeaturedProductsUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<Failure, List<ProductEntity>>> call({
    bool forceRefresh = false,
  }) => _repository.getFeaturedProducts(forceRefresh: forceRefresh);
}
