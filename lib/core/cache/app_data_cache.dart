import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

class AppDataCache {
  List<CategoryEntity>? categories;
  List<ProductEntity>? allProducts;
  List<ProductEntity>? featuredProducts;
  UserEntity? currentUser;
  List<OrderEntity>? orders;

  bool get hasCategories => categories != null;
  bool get hasAllProducts => allProducts != null;
  bool get hasFeaturedProducts => featuredProducts != null;
  bool get hasUser => currentUser != null;
  bool get hasOrders => orders != null;

  bool get isFullyLoaded =>
      hasCategories && hasAllProducts && hasFeaturedProducts;

  void clear() {
    categories = null;
    allProducts = null;
    featuredProducts = null;
    currentUser = null;
    orders = null;
  }
}
