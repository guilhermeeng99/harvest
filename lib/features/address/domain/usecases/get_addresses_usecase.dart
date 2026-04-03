import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';
import 'package:harvest/features/address/domain/repositories/address_repository.dart';

class GetAddressesUseCase {
  const GetAddressesUseCase(this._repository);

  final AddressRepository _repository;

  Future<Either<Failure, List<AddressEntity>>> call() =>
      _repository.getAddresses();
}
