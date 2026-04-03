import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<Failure, List<CategoryEntity>>> call() =>
      _repository.getCategories();
}
