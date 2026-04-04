import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';
import 'package:harvest/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/home/data/models/category_model.dart';
import 'package:harvest/features/home/data/models/product_model.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._dataSource);

  final AdminRemoteDataSource _dataSource;

  // ── Products ──────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await _dataSource.getProducts();
      return Right(products);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductEntity product) async {
    try {
      await _dataSource.addProduct(_toProductModel(product));
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductEntity product) async {
    try {
      await _dataSource.updateProduct(_toProductModel(product));
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _dataSource.deleteProduct(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── Categories ────────────────────────────────────────────

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await _dataSource.getCategories();
      return Right(categories);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(CategoryEntity category) async {
    try {
      await _dataSource.addCategory(_toCategoryModel(category));
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryEntity category) async {
    try {
      await _dataSource.updateCategory(_toCategoryModel(category));
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _dataSource.deleteCategory(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── Users ─────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final users = await _dataSource.getUsers();
      return Right(users);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await _dataSource.deleteUser(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  ProductModel _toProductModel(ProductEntity e) => ProductModel(
    id: e.id,
    name: e.name,
    description: e.description,
    price: e.price,
    unit: e.unit,
    categoryId: e.categoryId,
    imageUrl: e.imageUrl,
    farmName: e.farmName,
    isFeatured: e.isFeatured,
    isOrganic: e.isOrganic,
    stock: e.stock,
    nutritionFacts: e.nutritionFacts,
  );

  CategoryModel _toCategoryModel(CategoryEntity e) => CategoryModel(
    id: e.id,
    name: e.name,
    imageUrl: e.imageUrl,
    sortOrder: e.sortOrder,
  );

  // ── Orders ────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    try {
      final orders = await _dataSource.getAllOrders();
      return Right(orders);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await _dataSource.updateOrderStatus(orderId, status.name);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── User Detail ───────────────────────────────────────────

  @override
  Future<Either<Failure, List<AddressEntity>>> getUserAddresses(
    String userId,
  ) async {
    try {
      final addresses = await _dataSource.getUserAddresses(userId);
      return Right(addresses);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(
    String userId,
  ) async {
    try {
      final orders = await _dataSource.getUserOrders(userId);
      return Right(orders);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
