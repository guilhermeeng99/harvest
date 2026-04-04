import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.isAdmin = false,
  });

  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final bool isAdmin;

  @override
  List<Object?> get props => [id, email, name, photoUrl, isAdmin];
}
