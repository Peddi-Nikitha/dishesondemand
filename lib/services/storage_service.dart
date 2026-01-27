import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';

/// Firebase Storage service for file uploads
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload file to Firebase Storage
  Future<String> uploadFile({
    required String path,
    required File file,
    required String fileName,
  }) async {
    try {
      final ref = _storage.ref().child(path).child(fileName);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw 'Error uploading file: $e';
    }
  }

  /// Upload product image
  Future<String> uploadProductImage(File imageFile, String productId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    return uploadFile(
      path: 'products/$productId',
      file: imageFile,
      fileName: fileName,
    );
  }

  /// Upload product image from bytes (for web support)
  Future<String> uploadProductImageBytes(Uint8List imageBytes, String productId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('products/$productId').child(fileName);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = ref.putData(imageBytes, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Check if it's a CORS error
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cors') || errorString.contains('xmlhttprequest')) {
        throw 'CORS Error: Please configure CORS in Firebase Console. See FIREBASE_CORS_SETUP.md for instructions.';
      }
      // Check if it's a 403 Forbidden error (permissions issue)
      if (errorString.contains('403') || errorString.contains('forbidden') || errorString.contains('permission')) {
        throw '403 Forbidden: Please update Firebase Storage Security Rules. See FIREBASE_STORAGE_RULES_SETUP.md for instructions. Make sure you are logged in.';
      }
      throw 'Error uploading image: $e';
    }
  }

  /// Upload user profile image
  Future<String> uploadUserProfileImage(File imageFile, String userId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    return uploadFile(
      path: 'users/$userId/profile',
      file: imageFile,
      fileName: fileName,
    );
  }

  /// Upload delivery boy document
  Future<String> uploadDeliveryBoyDocument({
    required File file,
    required String deliveryBoyId,
    required String documentType, // 'license', 'vehicleRegistration', 'insurance', 'governmentId'
  }) async {
    // Determine file extension based on file type
    final extension = file.path.split('.').last.toLowerCase();
    final fileName = '${documentType}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    return uploadFile(
      path: 'deliveryBoys/$deliveryBoyId/documents',
      file: file,
      fileName: fileName,
    );
  }

  /// Upload restaurant logo
  Future<String> uploadRestaurantLogo(File logoFile) async {
    final fileName = 'logo_${DateTime.now().millisecondsSinceEpoch}.png';
    return uploadFile(
      path: 'restaurant/logo',
      file: logoFile,
      fileName: fileName,
    );
  }

  /// Upload restaurant logo from bytes (for web support)
  Future<String> uploadRestaurantLogoBytes(Uint8List logoBytes) async {
    try {
      final fileName = 'logo_${DateTime.now().millisecondsSinceEpoch}.png';
      final ref = _storage.ref().child('restaurant/logo').child(fileName);
      final metadata = SettableMetadata(contentType: 'image/png');
      final uploadTask = ref.putData(logoBytes, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Check if it's a CORS error
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cors') || errorString.contains('xmlhttprequest')) {
        throw 'CORS Error: Please configure CORS in Firebase Console. See FIREBASE_CORS_SETUP.md for instructions.';
      }
      // Check if it's a 403 Forbidden error (permissions issue)
      if (errorString.contains('403') || errorString.contains('forbidden') || errorString.contains('permission')) {
        throw '403 Forbidden: Please update Firebase Storage Security Rules. See FIREBASE_STORAGE_RULES_SETUP.md for instructions. Make sure you are logged in.';
      }
      throw 'Error uploading logo: $e';
    }
  }

  /// Delete file from Firebase Storage
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref(path).delete();
    } catch (e) {
      throw 'Error deleting file: $e';
    }
  }
}

