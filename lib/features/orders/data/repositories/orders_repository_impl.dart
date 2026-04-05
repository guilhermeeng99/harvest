import 'package:dartz/dartz.dart';
import 'package:harvest/core/cache/app_data_cache.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:harvest/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this._dataSource, this._cache);

  final OrdersRemoteDataSource _dataSource;
  final AppDataCache _cache;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.hasOrders) {
      return Right(_cache.orders!);
    }
    try {
      final orders = await _dataSource.getOrders();
      _cache.orders = orders;
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      await _dataSource.cancelOrder(orderId);
      _cache.orders = null;
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}
