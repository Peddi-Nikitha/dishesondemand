import '../models/product_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

/// Repository for category operations
class CategoryRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      // First try with the composite query (isActive + displayOrder)
      try {
        final snapshot = await _firestoreService
            .queryCollection(AppConstants.categoriesCollection)
            .where('isActive', isEqualTo: true)
            .orderBy('displayOrder')
            .get();

        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();
        }
      } catch (e) {
        // If composite query fails (likely missing index), try simpler query
        if (e.toString().contains('index') || e.toString().contains('requires an index')) {
          print('⚠️ Composite index missing, falling back to simpler query');
          // Fallback: Get all active categories without ordering
          final snapshot = await _firestoreService
              .queryCollection(AppConstants.categoriesCollection)
              .where('isActive', isEqualTo: true)
              .get();

          final categories = snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          
          // Sort manually
          categories.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
          return categories;
        }
        rethrow;
      }

      // If no results, return empty list (collection might be empty)
      return [];
    } catch (e) {
      // More descriptive error message
      if (e.toString().contains('PERMISSION_DENIED')) {
        throw 'Permission denied: Check Firestore security rules';
      } else if (e.toString().contains('index')) {
        throw 'Firestore index required. Please create a composite index for categories collection with fields: isActive (Ascending) and displayOrder (Ascending)';
      } else if (e.toString().contains('UNAVAILABLE') || e.toString().contains('network')) {
        throw 'Network error: Check your internet connection';
      }
      throw 'Error fetching categories: $e';
    }
  }

  /// Get all categories (including inactive) - for admin view
  Future<List<CategoryModel>> getAllCategoriesAdmin() async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.categoriesCollection)
          .orderBy('displayOrder')
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching categories: $e';
    }
  }

  /// Get category by ID
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final doc = await _firestoreService.getDocument(
          AppConstants.categoriesCollection, categoryId);

      if (doc.exists) {
        return CategoryModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching category: $e';
    }
  }

  /// Create category
  Future<String> createCategory(CategoryModel category) async {
    try {
      final docRef = _firestoreService
          .instance
          .collection(AppConstants.categoriesCollection)
          .doc();
      final newCategory = CategoryModel(
        id: docRef.id,
        name: category.name,
        imageUrl: category.imageUrl,
        displayOrder: category.displayOrder,
        isActive: category.isActive,
      );
      await docRef.set(newCategory.toFirestore());
      return docRef.id;
    } catch (e) {
      throw 'Error creating category: $e';
    }
  }

  /// Update category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _firestoreService.setDocument(
        AppConstants.categoriesCollection,
        category.id,
        category.toFirestore(),
      );
    } catch (e) {
      throw 'Error updating category: $e';
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestoreService.deleteDocument(
          AppConstants.categoriesCollection, categoryId);
    } catch (e) {
      throw 'Error deleting category: $e';
    }
  }

  /// Stream categories (real-time)
  Stream<List<CategoryModel>> streamCategories() {
    return _firestoreService
        .queryCollection(AppConstants.categoriesCollection)
        .orderBy('displayOrder')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}

