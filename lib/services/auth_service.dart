import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/delivery_boy_model.dart';
import '../models/admin_model.dart';

/// Authentication service for Firebase Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Create account with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String role, // 'user', 'delivery_boy', 'admin'
    String? name,
    String? phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Create user document in Firestore based on role
      if (credential.user != null) {
        await _createUserDocument(
          uid: credential.user!.uid,
          email: email.trim(),
          role: role,
          name: name,
          phone: phone,
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument({
    required String uid,
    required String email,
    required String role,
    String? name,
    String? phone,
  }) async {
    final now = DateTime.now();

    if (role == 'user') {
      final userModel = UserModel(
        uid: uid,
        email: email,
        name: name,
        phone: phone,
        role: role,
        createdAt: now,
        updatedAt: now,
      );
      await _firestore.collection('users').doc(uid).set(userModel.toFirestore());
    } else if (role == 'delivery_boy') {
      final deliveryBoyModel = DeliveryBoyModel(
        uid: uid,
        email: email,
        name: name,
        phone: phone,
        role: role,
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );
      await _firestore
          .collection('deliveryBoys')
          .doc(uid)
          .set(deliveryBoyModel.toFirestore());
    } else if (role == 'admin') {
      final adminModel = AdminModel(
        uid: uid,
        email: email,
        name: name,
        role: role,
        createdAt: now,
      );
      await _firestore.collection('admins').doc(uid).set(adminModel.toFirestore());
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get user role from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      // Check in users collection
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data()?['role'] ?? 'user';
      }

      // Check in deliveryBoys collection
      final deliveryBoyDoc =
          await _firestore.collection('deliveryBoys').doc(uid).get();
      if (deliveryBoyDoc.exists) {
        return deliveryBoyDoc.data()?['role'] ?? 'delivery_boy';
      }

      // Check in admins collection
      final adminDoc = await _firestore.collection('admins').doc(uid).get();
      if (adminDoc.exists) {
        return adminDoc.data()?['role'] ?? 'admin';
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
}

