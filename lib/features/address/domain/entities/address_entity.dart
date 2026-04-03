import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  const AddressEntity({
    required this.id,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.isDefault,
    this.label,
    this.complement,
  });

  final String id;
  final String? label;
  final String street;
  final String number;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final String? complement;
  final bool isDefault;

  String get shortAddress => '$street, $number - $neighborhood';

  @override
  List<Object?> get props => [
    id,
    label,
    street,
    number,
    neighborhood,
    city,
    state,
    zipCode,
    complement,
    isDefault,
  ];
}
