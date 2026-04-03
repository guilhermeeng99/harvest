part of 'address_cubit.dart';

enum AddressStatus { initial, loading, loaded, error }

class AddressState extends Equatable {
  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.selectedAddress,
    this.errorMessage,
  });

  final AddressStatus status;
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final String? errorMessage;

  AddressState copyWith({
    AddressStatus? status,
    List<AddressEntity>? addresses,
    AddressEntity? selectedAddress,
    String? errorMessage,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, addresses, selectedAddress, errorMessage];
}
