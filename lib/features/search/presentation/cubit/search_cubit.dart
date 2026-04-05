import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:harvest/features/search/domain/usecases/search_products_usecase.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchProductsUseCase searchProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  }) : _searchProductsUseCase = searchProductsUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       super(const SearchState()) {
    if (state.categories.isEmpty) {
      unawaited(_loadCategories());
    }
  }

  final SearchProductsUseCase _searchProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _loadCategories() async {
    final result = await _getCategoriesUseCase();
    result.fold(
      (_) {},
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchState(categories: state.categories));
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

  Future<void> browseCategory(String categoryId) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        selectedCategoryId: categoryId,
        query: '',
      ),
    );

    final result = await _searchProductsUseCase(
      query: '',
      categoryId: categoryId,
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

  void clearCategory() {
    emit(SearchState(categories: state.categories));
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
    } else if (state.selectedCategoryId != null) {
      unawaited(_searchWithCurrentFilters());
    }
  }

  Future<void> _searchWithCurrentFilters() async {
    emit(state.copyWith(status: SearchStatus.loading));

    final result = await _searchProductsUseCase(
      query: state.query,
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
      (products) => emit(
        state.copyWith(status: SearchStatus.loaded, results: products),
      ),
    );
  }

  void clearFilters() {
    emit(SearchState(query: state.query, categories: state.categories));
    if (state.query.isNotEmpty) {
      unawaited(search(state.query));
    }
  }
}
