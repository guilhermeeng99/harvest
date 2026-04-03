part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.categories = const [],
    this.featuredProducts = const [],
    this.categoryProducts = const [],
    this.selectedCategoryId,
    this.categoryProductsStatus = HomeStatus.initial,
    this.errorMessage,
  });

  final HomeStatus status;
  final List<CategoryEntity> categories;
  final List<ProductEntity> featuredProducts;
  final List<ProductEntity> categoryProducts;
  final String? selectedCategoryId;
  final HomeStatus categoryProductsStatus;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<CategoryEntity>? categories,
    List<ProductEntity>? featuredProducts,
    List<ProductEntity>? categoryProducts,
    String? selectedCategoryId,
    HomeStatus? categoryProductsStatus,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      categoryProducts: categoryProducts ?? this.categoryProducts,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      categoryProductsStatus:
          categoryProductsStatus ?? this.categoryProductsStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    featuredProducts,
    categoryProducts,
    selectedCategoryId,
    categoryProductsStatus,
    errorMessage,
  ];
}
