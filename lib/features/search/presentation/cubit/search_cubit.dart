import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/search/domain/usecases/search_products_usecase.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required SearchProductsUseCase searchProductsUseCase})
    : _searchProductsUseCase = searchProductsUseCase,
      super(const SearchState());

  final SearchProductsUseCase _searchProductsUseCase;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading, query: query));

    final result = await _searchProductsUseCase(
      query: query,
      categoryId: state.selectedCategoryId,
      organicOnly: state.organicOnly,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (products) =>
          emit(state.copyWith(status: SearchStatus.loaded, results: products)),
    );
  }

  void updateFilters({
    String? categoryId,
    bool? organicOnly,
    double? minPrice,
    double? maxPrice,
  }) {
    emit(
      state.copyWith(
        selectedCategoryId: categoryId,
        organicOnly: organicOnly,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ),
    );

    if (state.query.isNotEmpty) {
      unawaited(search(state.query));
    }
  }

  void clearFilters() {
    emit(SearchState(query: state.query));
    if (state.query.isNotEmpty) {
      unawaited(search(state.query));
    }
  }
}
