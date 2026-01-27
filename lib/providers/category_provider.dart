import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../repositories/category_repository.dart';

/// Category provider for managing categories state
class CategoryProvider with ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all categories
  Future<void> loadCategories() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _categories = await _categoryRepository.getAllCategories();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all categories (including inactive) - for admin view
  Future<void> loadAllCategories() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _categories = await _categoryRepository.getAllCategoriesAdmin();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create category
  Future<bool> createCategory(CategoryModel category) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _categoryRepository.createCategory(category);
      await loadAllCategories();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update category
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _categoryRepository.updateCategory(category);
      await loadAllCategories();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _categoryRepository.deleteCategory(categoryId);
      await loadAllCategories();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

