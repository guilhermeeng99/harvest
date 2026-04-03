import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    String? categoryId,
    bool? organicOnly,
    double? minPrice,
    double? maxPrice,
  });
}
