import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';

/// Repository for persisting cart data per user in Firestore.
///
/// Cart documents are stored under `users/{userId}/cart/{productId}`.
class CartRepository {
  final FirestoreService _firestoreService = FirestoreService();

  CollectionReference<Map<String, dynamic>> _cartCollection(String userId) {
    return _firestoreService.instance
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('cart');
  }

  /// Load cart items for a user from Firestore.
  Future<List<CartItem>> loadCart(String userId) async {
    final snapshot = await _cartCollection(userId).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final productData =
          data['product'] as Map<String, dynamic>? ?? <String, dynamic>{};

      final product = ProductModel(
        id: doc.id,
        name: productData['name'] ?? '',
        category: productData['category'] ?? '',
        imageUrl: productData['imageUrl'] ?? '',
        quantity: productData['quantity']?.toString() ?? '',
        currentPrice:
            (productData['currentPrice'] as num?)?.toDouble() ?? 0.0,
        originalPrice:
            (productData['originalPrice'] as num?)?.toDouble(),
        createdAt: DateTime.tryParse(
                productData['createdAt'] ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(
                productData['updatedAt'] ?? '') ??
            DateTime.now(),
      );

      return CartItem(
        productId: doc.id,
        product: product,
        quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      );
    }).toList();
  }

  /// Save all cart items for a user in a batch.
  Future<void> saveCart(String userId, List<CartItem> items) async {
    final batch = _firestoreService.instance.batch();
    final collection = _cartCollection(userId);

    // Clear existing cart documents
    final existing = await collection.get();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }

    // Add current items
    for (final item in items) {
      final docRef = collection.doc(item.productId);
      batch.set(docRef, {
        'quantity': item.quantity,
        'product': {
          'name': item.product.name,
          'category': item.product.category,
          'imageUrl': item.product.imageUrl,
          'quantity': item.product.quantity,
          'currentPrice': item.product.currentPrice,
          'originalPrice': item.product.originalPrice,
          'createdAt': item.product.createdAt.toIso8601String(),
          'updatedAt': item.product.updatedAt.toIso8601String(),
        },
      });
    }

    await batch.commit();
  }

  /// Clear cart for a user.
  Future<void> clearCart(String userId) async {
    final collection = _cartCollection(userId);
    final snapshot = await collection.get();
    final batch = _firestoreService.instance.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}


