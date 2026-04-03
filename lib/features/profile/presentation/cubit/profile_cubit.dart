import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/features/auth/domain/usecases/get_current_user_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required GetCurrentUserUseCase getCurrentUserUseCase})
    : _getCurrentUserUseCase = getCurrentUserUseCase,
      super(const ProfileState());

  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> loadProfile() async {
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
}
