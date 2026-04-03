import 'package:equatable/equatable.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

enum AdminProductsStatus { initial, loading, loaded, error }

class AdminProductsState extends Equatable {
  const AdminProductsState({
    this.status = AdminProductsStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  final AdminProductsStatus status;
  final List<ProductEntity> products;
  final String? errorMessage;

  AdminProductsState copyWith({
    AdminProductsStatus? status,
    List<ProductEntity>? products,
    String? errorMessage,
  }) {
    return AdminProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
