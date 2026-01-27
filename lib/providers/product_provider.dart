import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

/// Product provider for managing products state
class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  String _selectedCategory = 'Starters';
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _filteredProducts;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load products by category (only available products)
  Future<void> loadProductsByCategory(String category) async {
    try {
      _isLoading = true;
      _error = null;
      _selectedCategory = category;
      notifyListeners();

      _products = await _productRepository.getProductsByCategory(category);
      _filteredProducts = _products;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all products by category (including unavailable) - for admin view
  Future<void> loadAllProductsByCategory(String category) async {
    try {
      _isLoading = true;
      _error = null;
      _selectedCategory = category;
      notifyListeners();

      _products = await _productRepository.getAllProductsByCategory(category);
      _filteredProducts = _products;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all products
  Future<void> loadAllProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _productRepository.getAllProducts();
      _filteredProducts = _products;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create product
  Future<bool> createProduct(ProductModel product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _productRepository.createProduct(product);
      await loadAllProductsByCategory(_selectedCategory);

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

  /// Update product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _productRepository.updateProduct(product);
      await loadAllProductsByCategory(_selectedCategory);

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

  /// Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _productRepository.deleteProduct(productId);
      await loadAllProductsByCategory(_selectedCategory);

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

  /// Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final product = await _productRepository.getProductById(productId);

      _isLoading = false;
      notifyListeners();
      return product;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Stream products by category (real-time updates)
  Stream<List<ProductModel>> streamProductsByCategory(String category) {
    return _productRepository.streamProductsByCategory(category);
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

