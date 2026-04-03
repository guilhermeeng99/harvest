import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.street,
    required super.number,
    required super.neighborhood,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.isDefault,
    super.label,
    super.complement,
  });

  factory AddressModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return AddressModel(
      id: doc.id,
      label: data['label'] as String?,
      street: data['street'] as String,
      number: data['number'] as String,
      neighborhood: data['neighborhood'] as String,
      city: data['city'] as String,
      state: data['state'] as String,
      zipCode: data['zipCode'] as String,
      complement: data['complement'] as String?,
      isDefault: data['isDefault'] as bool? ?? false,
    );
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      label: entity.label,
      street: entity.street,
      number: entity.number,
      neighborhood: entity.neighborhood,
      city: entity.city,
      state: entity.state,
      zipCode: entity.zipCode,
      complement: entity.complement,
      isDefault: entity.isDefault,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'label': label,
    'street': street,
    'number': number,
    'neighborhood': neighborhood,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'complement': complement,
    'isDefault': isDefault,
  };
}
