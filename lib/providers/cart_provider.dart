import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../repositories/cart_repository.dart';

/// Cart item model
class CartItem {
  final String productId;
  final ProductModel product;
  int quantity;

  CartItem({
    required this.productId,
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.currentPrice * quantity;

  CartItem copyWith({
    String? productId,
    ProductModel? product,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Cart provider for managing shopping cart state
class CartProvider with ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();
  String? _userId;

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get shipping => subtotal > 0 ? 10.0 : 0.0; // Fixed shipping cost
  
  double get discount => 0.0; // Can be calculated based on promo codes
  
  double get discountPercentage => subtotal > 0 ? (discount / subtotal * 100) : 0.0;
  
  double get total => subtotal + shipping - discount;

  /// Attach the current authenticated user id for Firestore sync.
  /// Optionally loads the saved cart when the user changes.
  Future<void> setUser(String? userId, {bool loadCartOnChange = true}) async {
    if (_userId == userId) return;

    _userId = userId;

    if (_userId == null) {
      clearCart();
      return;
    }

    if (loadCartOnChange) {
      await loadCartFromFirestore();
    }
  }

  /// Load cart items from Firestore for the current user.
  Future<void> loadCartFromFirestore() async {
    if (_userId == null) return;

    final items = await _cartRepository.loadCart(_userId!);
    _items
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  /// Persist current cart items to Firestore for the current user.
  Future<void> saveCartToFirestore() async {
    if (_userId == null) return;
    await _cartRepository.saveCart(_userId!, _items);
  }

  /// Add product to cart
  Future<void> addItem(ProductModel product) async {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      // Product already in cart, increase quantity
      _items[existingIndex].quantity++;
    } else {
      // New product, add to cart
      _items.add(CartItem(
        productId: product.id,
        product: product,
        quantity: 1,
      ));
    }
    notifyListeners();
    await saveCartToFirestore();
  }

  /// Remove product from cart
  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
    await saveCartToFirestore();
  }

  /// Update quantity of a cart item
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }
    
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
      await saveCartToFirestore();
    }
  }

  /// Increase quantity of a cart item
  Future<void> increaseQuantity(String productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
      await saveCartToFirestore();
    }
  }

  /// Decrease quantity of a cart item
  Future<void> decreaseQuantity(String productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        await removeItem(productId);
      }
      notifyListeners();
      await saveCartToFirestore();
    }
  }

  /// Clear all items from cart
  Future<void> clearCart({bool clearRemote = false}) async {
    _items.clear();
    notifyListeners();

    if (clearRemote && _userId != null) {
      await _cartRepository.clearCart(_userId!);
    } else {
      await saveCartToFirestore();
    }
  }

  /// Check if product is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  /// Get quantity of a product in cart
  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        productId: productId,
        product: ProductModel(
          id: productId,
          name: '',
          category: '',
          imageUrl: '',
          quantity: '',
          currentPrice: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  /// Apply promo code (placeholder for future implementation)
  void applyPromoCode(String code) {
    // TODO: Implement promo code logic
    notifyListeners();
  }

  /// Remove promo code
  void removePromoCode() {
    // TODO: Implement promo code removal
    notifyListeners();
  }
}

