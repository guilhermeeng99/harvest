import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts({
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  );

  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    bool forceRefresh = false,
  });

  Future<Either<Failure, ProductEntity>> getProductById(String id);
}
