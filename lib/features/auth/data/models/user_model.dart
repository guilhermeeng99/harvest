import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.isAdmin,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    bool isAdmin = false,
  }) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      email: data['email'] as String,
      name: data['name'] as String?,
      photoUrl: data['photoUrl'] as String?,
      isAdmin: isAdmin,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'name': name,
    'photoUrl': photoUrl,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
