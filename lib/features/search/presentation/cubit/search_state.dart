part of 'search_cubit.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.selectedCategoryId,
    this.organicOnly = false,
    this.minPrice,
    this.maxPrice,
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final List<ProductEntity> results;
  final String? selectedCategoryId;
  final bool organicOnly;
  final double? minPrice;
  final double? maxPrice;
  final String? errorMessage;

  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      organicOnly ||
      minPrice != null ||
      maxPrice != null;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<ProductEntity>? results,
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
    selectedCategoryId,
    organicOnly,
    minPrice,
    maxPrice,
    errorMessage,
  ];
}
