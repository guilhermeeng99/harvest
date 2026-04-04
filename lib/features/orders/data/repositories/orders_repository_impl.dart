import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:harvest/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this._dataSource);

  final OrdersRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final orders = await _dataSource.getOrders();
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
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}
