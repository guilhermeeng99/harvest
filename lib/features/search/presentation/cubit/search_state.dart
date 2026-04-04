part of 'search_cubit.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.organicOnly = false,
    this.minPrice,
    this.maxPrice,
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final List<ProductEntity> results;
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final bool organicOnly;
  final double? minPrice;
  final double? maxPrice;
  final String? errorMessage;

  String? get selectedCategoryName {
    if (selectedCategoryId == null) return null;
    final matches = categories.where((c) => c.id == selectedCategoryId);
    return matches.isEmpty ? null : matches.first.name;
  }

  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      organicOnly ||
      minPrice != null ||
      maxPrice != null;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<ProductEntity>? results,
    List<CategoryEntity>? categories,
    String? selectedCategoryId,
    bool? organicOnly,
    double? minPrice,
    double? maxPrice,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      organicOnly: organicOnly ?? this.organicOnly,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    results,
    categories,
    selectedCategoryId,
    organicOnly,
    minPrice,
    maxPrice,
    errorMessage,
  ];
}
