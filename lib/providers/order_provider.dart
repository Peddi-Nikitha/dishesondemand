import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import '../repositories/delivery_boy_repository.dart';
import '../utils/constants.dart';

/// Order provider for managing orders state
class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  final DeliveryBoyRepository _deliveryBoyRepository = DeliveryBoyRepository();

  List<OrderModel> _orders = [];
  List<OrderModel> _deliveryBoyOrders = [];
  List<OrderModel> _filteredOrders = [];
  String _selectedTab = 'Order History'; // 'Order History', 'Order On Hold', 'Offline Order'
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<OrderModel> get orders => _filteredOrders;
  List<OrderModel> get deliveryBoyOrders => _deliveryBoyOrders;
  String get selectedTab => _selectedTab;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  /// Load all orders
  Future<void> loadAllOrders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orders = await _orderRepository.getAllOrders();
      _applyFilters();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream all orders (real-time)
  Stream<List<OrderModel>> streamAllOrders() {
    return _orderRepository.streamAllOrders();
  }

  /// Set selected tab and filter orders
  void setSelectedTab(String tab) {
    _selectedTab = tab;
    _applyFilters();
    notifyListeners();
  }

  /// Apply filters based on selected tab and search query
  void _applyFilters() {
    List<OrderModel> filtered = List.from(_orders);

    // Filter by tab
    if (_selectedTab == 'Order On Hold') {
      filtered = filtered.where((order) => 
        order.status == AppConstants.orderStatusPending ||
        order.status == AppConstants.orderStatusConfirmed ||
        order.status == AppConstants.orderStatusPreparing
      ).toList();
    } else if (_selectedTab == 'Offline Order') {
      // Offline orders - you can define this based on your business logic
      // For now, we'll treat it as orders without delivery assignment
      filtered = filtered.where((order) => 
        order.deliveryBoyId == null
      ).toList();
    }
    // 'Order History' shows all orders

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      filtered = filtered.where((order) {
        return order.orderNumber.toLowerCase().contains(lowerQuery) ||
            order.id.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    _filteredOrders = filtered;
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Assign delivery boy to order
  Future<bool> assignDeliveryBoy(String orderId, String deliveryBoyId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _orderRepository.assignDeliveryBoy(orderId, deliveryBoyId);
      await loadAllOrders();

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

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Find order in local cache first; if not present (e.g. on delivery app),
      // fetch it directly from Firestore.
      OrderModel? order;
      try {
        order = _orders.firstWhere((o) => o.id == orderId);
      } catch (_) {
        order = await _orderRepository.getOrderById(orderId);
      }

      if (order == null) {
        throw 'Order not found';
      }

      // If transitioning to delivered, update driver's earnings
      if (status == AppConstants.orderStatusDelivered &&
          order.deliveryBoyId != null &&
          order.status != AppConstants.orderStatusDelivered) {
        await _deliveryBoyRepository.addDeliveryEarning(
          order.deliveryBoyId!,
          order.total,
        );
      }

      final updatedOrder = order.copyWith(status: status);
      await _orderRepository.updateOrder(updatedOrder);
      await loadAllOrders();

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

  /// Create order
  Future<String> createOrder(OrderModel order) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final orderId = await _orderRepository.createOrder(order);
      
      // Reload orders to include the new one
      await loadAllOrders();

      _isLoading = false;
      notifyListeners();
      return orderId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Load user orders
  Future<void> loadUserOrders(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orders = await _orderRepository.getOrdersByUserId(userId);
      _applyFilters();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load orders assigned to a specific delivery boy
  Future<void> loadDeliveryBoyOrders(String deliveryBoyId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _deliveryBoyOrders =
          await _orderRepository.getOrdersByDeliveryBoyId(deliveryBoyId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream user orders (real-time)
  Stream<List<OrderModel>> streamUserOrders(String userId) {
    return _orderRepository.streamOrdersByUserId(userId);
  }

  /// Stream user orders with fallback (for when index is missing)
  Stream<List<OrderModel>> streamUserOrdersFallback(String userId) {
    return _orderRepository.streamOrdersByUserIdFallback(userId);
  }

  /// Stream delivery boy orders (real-time)
  Stream<List<OrderModel>> streamDeliveryBoyOrders(String deliveryBoyId) {
    return _orderRepository.streamOrdersByDeliveryBoyId(deliveryBoyId);
  }


  /// Cancel order
  Future<bool> cancelOrder(String orderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final order = _orders.firstWhere((o) => o.id == orderId);
      final updatedOrder = order.copyWith(status: AppConstants.orderStatusCancelled);
      await _orderRepository.updateOrder(updatedOrder);
      
      // Reload orders
      if (_orders.isNotEmpty) {
        final userId = _orders.first.userId;
        await loadUserOrders(userId);
      }

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

