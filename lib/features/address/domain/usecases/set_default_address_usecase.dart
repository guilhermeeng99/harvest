import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/address/domain/repositories/address_repository.dart';

class SetDefaultAddressUseCase {
  const SetDefaultAddressUseCase(this._repository);

  final AddressRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.setDefaultAddress(id);
}
