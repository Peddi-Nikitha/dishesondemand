import '../models/product_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

/// Repository for product operations
class ProductRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Get all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.productsCollection)
          .where('isAvailable', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching products: $e';
    }
  }

  /// Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.productsCollection)
          .where('category', isEqualTo: category)
          .where('isAvailable', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching products by category: $e';
    }
  }

  /// Get all products by category (including unavailable) - for admin view
  Future<List<ProductModel>> getAllProductsByCategory(String category) async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.productsCollection)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching all products by category: $e';
    }
  }

  /// Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestoreService.getDocument(
          AppConstants.productsCollection, productId);

      if (doc.exists) {
        return ProductModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching product: $e';
    }
  }

  /// Stream products by category (real-time)
  Stream<List<ProductModel>> streamProductsByCategory(String category) {
    return _firestoreService
        .queryCollection(AppConstants.productsCollection)
        .where('category', isEqualTo: category)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  /// Create product
  Future<String> createProduct(ProductModel product) async {
    try {
      final docRef = _firestoreService
          .instance
          .collection(AppConstants.productsCollection)
          .doc();
      final now = DateTime.now();
      final newProduct = ProductModel(
        id: docRef.id,
        name: product.name,
        category: product.category,
        imageUrl: product.imageUrl,
        quantity: product.quantity,
        currentPrice: product.currentPrice,
        originalPrice: product.originalPrice,
        rating: product.rating,
        description: product.description,
        isVeg: product.isVeg,
        isNonVeg: product.isNonVeg,
        isAvailable: product.isAvailable,
        createdAt: now,
        updatedAt: now,
      );
      await docRef.set(newProduct.toFirestore());
      return docRef.id;
    } catch (e) {
      throw 'Error creating product: $e';
    }
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) async {
    try {
      final updatedProduct = ProductModel(
        id: product.id,
        name: product.name,
        category: product.category,
        imageUrl: product.imageUrl,
        quantity: product.quantity,
        currentPrice: product.currentPrice,
        originalPrice: product.originalPrice,
        rating: product.rating,
        description: product.description,
        isVeg: product.isVeg,
        isNonVeg: product.isNonVeg,
        isAvailable: product.isAvailable,
        createdAt: product.createdAt,
        updatedAt: DateTime.now(),
      );
      await _firestoreService.updateDocument(
        AppConstants.productsCollection,
        product.id,
        updatedProduct.toFirestore(),
      );
    } catch (e) {
      throw 'Error updating product: $e';
    }
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestoreService.deleteDocument(
          AppConstants.productsCollection, productId);
    } catch (e) {
      throw 'Error deleting product: $e';
    }
  }

}

