import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  Future<Either<Failure, void>> addAddress(AddressEntity address);

  Future<Either<Failure, void>> deleteAddress(String id);

  Future<Either<Failure, void>> setDefaultAddress(String id);
}
