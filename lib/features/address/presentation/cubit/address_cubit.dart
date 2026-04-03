import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';
import 'package:harvest/features/address/domain/usecases/add_address_usecase.dart';
import 'package:harvest/features/address/domain/usecases/delete_address_usecase.dart';
import 'package:harvest/features/address/domain/usecases/get_addresses_usecase.dart';
import 'package:harvest/features/address/domain/usecases/set_default_address_usecase.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit({
    required GetAddressesUseCase getAddressesUseCase,
    required AddAddressUseCase addAddressUseCase,
    required DeleteAddressUseCase deleteAddressUseCase,
    required SetDefaultAddressUseCase setDefaultAddressUseCase,
  }) : _getAddressesUseCase = getAddressesUseCase,
       _addAddressUseCase = addAddressUseCase,
       _deleteAddressUseCase = deleteAddressUseCase,
       _setDefaultAddressUseCase = setDefaultAddressUseCase,
       super(const AddressState());

  final GetAddressesUseCase _getAddressesUseCase;
  final AddAddressUseCase _addAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  Future<void> loadAddresses() async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await _getAddressesUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (addresses) {
        final selected =
            addresses.where((a) => a.isDefault).firstOrNull ??
            addresses.firstOrNull;
        emit(
          state.copyWith(
            status: AddressStatus.loaded,
            addresses: addresses,
            selectedAddress: selected,
          ),
        );
      },
    );
  }

  Future<void> addAddress(AddressEntity address) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await _addAddressUseCase(address);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => loadAddresses(),
    );
  }

  Future<void> deleteAddress(String id) async {
    final result = await _deleteAddressUseCase(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => loadAddresses(),
    );
  }

  Future<void> setDefault(String id) async {
    final result = await _setDefaultAddressUseCase(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => loadAddresses(),
    );
  }
}
