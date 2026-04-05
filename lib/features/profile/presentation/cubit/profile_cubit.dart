import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/update_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       super(const ProfileState());

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  Future<void> loadProfile() async {
    if (state.status == ProfileStatus.loaded) return;
    await _fetchProfile();
  }

  Future<void> refreshProfile() async {
    await _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(state.copyWith(status: ProfileStatus.loaded, user: user)),
    );
  }

  Future<bool> updateProfile({
    required String name,
  }) async {
    final result = await _updateProfileUseCase(name: name);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (user) {
        emit(state.copyWith(status: ProfileStatus.loaded, user: user));
        return true;
      },
    );
  }
}
