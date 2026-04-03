import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/home/domain/repositories/home_repository.dart';

class GetProductByIdUseCase {
  const GetProductByIdUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<Failure, ProductEntity>> call(String id) =>
      _repository.getProductById(id);
}
