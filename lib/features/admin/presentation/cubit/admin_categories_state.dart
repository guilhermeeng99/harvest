import 'package:equatable/equatable.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';

enum AdminCategoriesStatus { initial, loading, loaded, error }

class AdminCategoriesState extends Equatable {
  const AdminCategoriesState({
    this.status = AdminCategoriesStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  final AdminCategoriesStatus status;
  final List<CategoryEntity> categories;
  final String? errorMessage;

  AdminCategoriesState copyWith({
    AdminCategoriesStatus? status,
    List<CategoryEntity>? categories,
    String? errorMessage,
  }) => AdminCategoriesState(
    status: status ?? this.status,
    categories: categories ?? this.categories,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, categories, errorMessage];
}
