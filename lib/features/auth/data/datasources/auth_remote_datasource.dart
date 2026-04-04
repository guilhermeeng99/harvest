import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harvest/core/errors/exceptions.dart';
import 'package:harvest/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException('User not found');

      final doc = await _firestore.collection('users').doc(user.uid).get();
      final adminDoc = await _firestore
          .collection('admins')
          .doc(user.uid)
          .get();
      final isAdmin = adminDoc.exists;

      if (doc.exists) return UserModel.fromFirestore(doc, isAdmin: isAdmin);

      return UserModel(
        id: user.uid,
        email: user.email ?? email,
        name: user.displayName,
        photoUrl: user.photoURL,
        isAdmin: isAdmin,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException('Failed to create user');

      await user.updateDisplayName(name);

      final userModel = UserModel(
        id: user.uid,
        email: email,
        name: name,
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toFirestore());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign out failed');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final adminDoc = await _firestore.collection('admins').doc(user.uid).get();
    final isAdmin = adminDoc.exists;

    if (doc.exists) return UserModel.fromFirestore(doc, isAdmin: isAdmin);

    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
      isAdmin: isAdmin,
    );
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final adminDoc = await _firestore
          .collection('admins')
          .doc(user.uid)
          .get();
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        photoUrl: user.photoURL,
        isAdmin: adminDoc.exists,
      );
    });
  }
}
