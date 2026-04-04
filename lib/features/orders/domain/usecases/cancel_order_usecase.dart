import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/orders/domain/repositories/orders_repository.dart';

class CancelOrderUseCase {
  const CancelOrderUseCase(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, void>> call(String orderId) =>
      _repository.cancelOrder(orderId);
}
