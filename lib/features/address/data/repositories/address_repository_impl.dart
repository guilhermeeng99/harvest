import 'package:dartz/dartz.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/core/errors/failures.dart';
import 'package:harvest/features/address/data/datasources/address_remote_datasource.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';
import 'package:harvest/features/address/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl(this._dataSource);

  final AddressRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    try {
      final addresses = await _dataSource.getAddresses();
      return Right(addresses);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addAddress(AddressEntity address) async {
    try {
      await _dataSource.addAddress(address);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) async {
    try {
      await _dataSource.deleteAddress(id);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String id) async {
    try {
      await _dataSource.setDefaultAddress(id);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
