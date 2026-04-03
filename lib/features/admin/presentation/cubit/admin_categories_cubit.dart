import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_categories_state.dart';

class AdminCategoriesCubit extends Cubit<AdminCategoriesState> {
  AdminCategoriesCubit(this._repository) : super(const AdminCategoriesState());

  final AdminRepository _repository;

  Future<void> loadCategories() async {
    emit(state.copyWith(status: AdminCategoriesStatus.loading));
    final result = await _repository.getCategories();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminCategoriesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          status: AdminCategoriesStatus.loaded,
          categories: categories,
        ),
      ),
    );
  }

  Future<void> deleteCategory(String id) async {
    final result = await _repository.deleteCategory(id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadCategories(),
    );
  }
}
