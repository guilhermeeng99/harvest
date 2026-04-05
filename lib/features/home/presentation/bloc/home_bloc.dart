import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_featured_products_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_products_by_category_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetAllProductsUseCase getAllProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetFeaturedProductsUseCase getFeaturedProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  }) : _getAllProductsUseCase = getAllProductsUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _getFeaturedProductsUseCase = getFeaturedProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       super(const HomeState()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeCategorySelected>(_onCategorySelected);
  }

  final GetAllProductsUseCase _getAllProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetFeaturedProductsUseCase _getFeaturedProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.status == HomeStatus.loaded) return;
    await _fetchHomeData(emit: emit);
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    await _fetchHomeData(emit: emit, forceRefresh: true);
  }

  Future<void> _fetchHomeData({
    required Emitter<HomeState> emit,
    bool forceRefresh = false,
  }) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final categoriesResult = await _getCategoriesUseCase(
      forceRefresh: forceRefresh,
    );
    final featuredResult = await _getFeaturedProductsUseCase(
      forceRefresh: forceRefresh,
    );
    final allProductsResult = await _getAllProductsUseCase(
      forceRefresh: forceRefresh,
    );

    final categories = categoriesResult.getOrElse(() => []);
    final featured = featuredResult.getOrElse(() => []);
    final allProducts = allProductsResult.getOrElse(() => []);

    final hasError = categoriesResult.isLeft() && featuredResult.isLeft();

    if (hasError) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Failed to load home data',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          categories: categories,
          featuredProducts: featured,
          allProducts: allProducts,
        ),
      );
    }
  }

  Future<void> _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedCategoryId: event.categoryId,
        categoryProductsStatus: HomeStatus.loading,
      ),
    );

    final result = await _getProductsByCategoryUseCase(event.categoryId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          categoryProductsStatus: HomeStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          categoryProductsStatus: HomeStatus.loaded,
          categoryProducts: products,
        ),
      ),
    );
  }
}
