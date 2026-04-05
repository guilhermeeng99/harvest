import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest/features/address/data/models/address_model.dart';
import 'package:harvest/features/auth/data/models/user_model.dart';
import 'package:harvest/features/home/data/models/category_model.dart';
import 'package:harvest/features/home/data/models/product_model.dart';
import 'package:harvest/features/orders/data/models/order_model.dart';

abstract interface class AdminRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);

  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);

  Future<List<UserModel>> getUsers();
  Future<void> deleteUser(String id);

  Future<List<OrderModel>> getAllOrders();
  Future<void> updateOrderStatus(String orderId, String status);

  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? photoUrl,
  });

  Future<List<AddressModel>> getUserAddresses(String userId);
  Future<List<OrderModel>> getUserOrders(String userId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  AdminRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<ProductModel>> getProducts() async {
    final snap = await _firestore.collection('products').get();
    return snap.docs.map(ProductModel.fromFirestore).toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toFirestore());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toFirestore());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final snap = await _firestore
        .collection('categories')
        .orderBy('name')
        .get();
    return snap.docs.map(CategoryModel.fromFirestore).toList();
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _firestore.collection('categories').add(category.toFirestore());
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _firestore
        .collection('categories')
        .doc(category.id)
        .update(category.toFirestore());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final snap = await _firestore.collection('users').get();
    return snap.docs.map(UserModel.fromFirestore).toList();
  }

  @override
  Future<void> deleteUser(String id) async {
    await _firestore.collection('users').doc(id).delete();
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;
    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update(updates);
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final snap = await _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(OrderModel.fromFirestore).toList();
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  @override
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    final snap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();
    return snap.docs.map(AddressModel.fromFirestore).toList();
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    final snap = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(OrderModel.fromFirestore).toList();
  }
}
