import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

abstract interface class AdminRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, void>> addProduct(ProductEntity product);
  Future<Either<Failure, void>> updateProduct(ProductEntity product);
  Future<Either<Failure, void>> deleteProduct(String id);

  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, void>> addCategory(CategoryEntity category);
  Future<Either<Failure, void>> updateCategory(CategoryEntity category);
  Future<Either<Failure, void>> deleteCategory(String id);

  Future<Either<Failure, List<UserEntity>>> getUsers();
  Future<Either<Failure, void>> deleteUser(String id);

  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  );

  Future<Either<Failure, String>> uploadImage(Uint8List bytes, String fileName);
}
