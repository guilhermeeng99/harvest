import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/features/home/data/models/product_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? categoryId,
    bool? organicOnly,
    double? minPrice,
    double? maxPrice,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? categoryId,
    bool? organicOnly,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      // Firestore doesn't support full-text search natively.
      // We fetch all products and filter client-side for the demo.
      var query_ = _firestore.collection('products').limit(100);

      if (categoryId != null && categoryId.isNotEmpty) {
        query_ = query_.where('categoryId', isEqualTo: categoryId);
      }

      final snapshot = await query_.get();
      var products = snapshot.docs.map(ProductModel.fromFirestore).toList();

      if (query.isNotEmpty) {
        final queryLower = query.toLowerCase();
        products = products
            .where(
              (p) =>
                  p.name.toLowerCase().contains(queryLower) ||
                  p.description.toLowerCase().contains(queryLower) ||
                  p.farmName.toLowerCase().contains(queryLower),
            )
            .toList();
      }

      if (organicOnly ?? false) {
        products = products.where((p) => p.isOrganic).toList();
      }

      if (minPrice != null) {
        products = products.where((p) => p.price >= minPrice).toList();
      }

      if (maxPrice != null) {
        products = products.where((p) => p.price <= maxPrice).toList();
      }

      return products;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
