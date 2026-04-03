import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_products_state.dart';

class AdminProductsCubit extends Cubit<AdminProductsState> {
  AdminProductsCubit(this._repository) : super(const AdminProductsState());

  final AdminRepository _repository;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: AdminProductsStatus.loading));
    final result = await _repository.getProducts();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminProductsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(status: AdminProductsStatus.loaded, products: products),
      ),
    );
  }

  Future<void> deleteProduct(String id) async {
    final result = await _repository.deleteProduct(id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadProducts(),
    );
  }
}
