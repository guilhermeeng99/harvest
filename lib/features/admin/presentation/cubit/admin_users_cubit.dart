import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_users_state.dart';

class AdminUsersCubit extends Cubit<AdminUsersState> {
  AdminUsersCubit(this._repository) : super(const AdminUsersState());

  final AdminRepository _repository;

  Future<void> loadUsers() async {
    emit(state.copyWith(status: AdminUsersStatus.loading));
    final result = await _repository.getUsers();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminUsersStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (users) =>
          emit(state.copyWith(status: AdminUsersStatus.loaded, users: users)),
    );
  }

  Future<void> deleteUser(String id) async {
    final result = await _repository.deleteUser(id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadUsers(),
    );
  }
}
