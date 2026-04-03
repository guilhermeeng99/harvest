import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:harvest/features/auth/data/models/user_model.dart';
import 'package:harvest/features/home/data/models/category_model.dart';
import 'package:harvest/features/home/data/models/product_model.dart';

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

  Future<String> uploadImage(Uint8List bytes, String fileName);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  AdminRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firestore = firestore,
       _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  // ── Products ──────────────────────────────────────────────

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

  // ── Categories ────────────────────────────────────────────

  @override
  Future<List<CategoryModel>> getCategories() async {
    final snap = await _firestore
        .collection('categories')
        .orderBy('sortOrder')
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

  // ── Users ─────────────────────────────────────────────────

  @override
  Future<List<UserModel>> getUsers() async {
    final snap = await _firestore.collection('users').get();
    return snap.docs.map(UserModel.fromFirestore).toList();
  }

  @override
  Future<void> deleteUser(String id) async {
    await _firestore.collection('users').doc(id).delete();
  }

  // ── Image Upload ──────────────────────────────────────────

  @override
  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    final ref = _storage.ref('images/$fileName');
    await ref.putData(bytes);
    return ref.getDownloadURL();
  }
}
