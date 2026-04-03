import 'package:equatable/equatable.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';

enum AdminUsersStatus { initial, loading, loaded, error }

class AdminUsersState extends Equatable {
  const AdminUsersState({
    this.status = AdminUsersStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  final AdminUsersStatus status;
  final List<UserEntity> users;
  final String? errorMessage;

  AdminUsersState copyWith({
    AdminUsersStatus? status,
    List<UserEntity>? users,
    String? errorMessage,
  }) => AdminUsersState(
    status: status ?? this.status,
    users: users ?? this.users,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, users, errorMessage];
}
