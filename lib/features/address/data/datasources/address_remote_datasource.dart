import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/features/address/data/models/address_model.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<void> addAddress(AddressEntity address);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  const AddressRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _addressesRef {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) throw const AuthException('User not authenticated');
    return _firestore.collection('users').doc(uid).collection('addresses');
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final snapshot = await _addressesRef.get();
      return snapshot.docs.map(AddressModel.fromFirestore).toList();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addAddress(AddressEntity address) async {
    try {
      final model = AddressModel.fromEntity(address);
      if (model.isDefault) {
        await _clearDefaultAddresses();
      }
      await _addressesRef.add(model.toFirestore());
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    try {
      await _addressesRef.doc(id).delete();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    try {
      await _clearDefaultAddresses();
      await _addressesRef.doc(id).update({'isDefault': true});
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  Future<void> _clearDefaultAddresses() async {
    final defaults = await _addressesRef
        .where('isDefault', isEqualTo: true)
        .get();
    for (final doc in defaults.docs) {
      await doc.reference.update({'isDefault': false});
    }
  }
}
