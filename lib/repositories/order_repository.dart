import '../models/order_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import 'notification_repository.dart';

/// Repository for order operations
class OrderRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  /// Create order
  Future<String> createOrder(OrderModel order) async {
    try {
      final docRef = _firestoreService
          .instance
          .collection(AppConstants.ordersCollection)
          .doc();
      final now = DateTime.now();
      final newOrder = OrderModel(
        id: docRef.id,
        userId: order.userId,
        orderNumber: order.orderNumber,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        discount: order.discount,
        total: order.total,
        status: order.status,
        deliveryAddress: order.deliveryAddress,
        paymentMethod: order.paymentMethod,
        createdAt: now,
        updatedAt: now,
      );
      await docRef.set(newOrder.toFirestore());
      return docRef.id;
    } catch (e) {
      throw 'Error creating order: $e';
    }
  }

  /// Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _firestoreService.getDocument(
          AppConstants.ordersCollection, orderId);

      if (doc.exists) {
        return OrderModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching order: $e';
    }
  }

  /// Get orders by user ID
  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      // First try with the composite query (userId + createdAt)
      try {
        final snapshot = await _firestoreService
            .queryCollection(AppConstants.ordersCollection)
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();

        return snapshot.docs
            .map((doc) => OrderModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      } catch (e) {
        // If composite query fails (likely missing index), try simpler query
        if (e.toString().contains('index') || e.toString().contains('requires an index')) {
          print('⚠️ Composite index missing, falling back to simpler query');
          // Fallback: Get all user orders without ordering
          final snapshot = await _firestoreService
              .queryCollection(AppConstants.ordersCollection)
              .where('userId', isEqualTo: userId)
              .get();

          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          
          // Sort manually by createdAt descending
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        }
        rethrow;
      }
    } catch (e) {
      // More descriptive error message
      if (e.toString().contains('PERMISSION_DENIED')) {
        throw 'Permission denied: Check Firestore security rules';
      } else if (e.toString().contains('index')) {
        throw 'Firestore index required. Please create a composite index for orders collection with fields: userId (Ascending) and createdAt (Descending). The error message includes a link to create it.';
      } else if (e.toString().contains('UNAVAILABLE') || e.toString().contains('network')) {
        throw 'Network error: Check your internet connection';
      }
      throw 'Error fetching user orders: $e';
    }
  }

  /// Get orders assigned to a specific delivery boy
  Future<List<OrderModel>> getOrdersByDeliveryBoyId(String deliveryBoyId) async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.ordersCollection)
          .where('deliveryBoyId', isEqualTo: deliveryBoyId)
          .get();

      final orders = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Sort by createdAt descending (most recent first)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } catch (e) {
      throw 'Error fetching delivery boy orders: $e';
    }
  }

  /// Stream orders assigned to a specific delivery boy (real-time)
  Stream<List<OrderModel>> streamOrdersByDeliveryBoyId(String deliveryBoyId) {
    return _firestoreService
        .queryCollection(AppConstants.ordersCollection)
        .where('deliveryBoyId', isEqualTo: deliveryBoyId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          // Sort by createdAt descending
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  /// Stream orders by user ID (real-time)
  Stream<List<OrderModel>> streamOrdersByUserId(String userId) {
    // Try with composite query first
    return _firestoreService
        .queryCollection(AppConstants.ordersCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          // Ensure sorted
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  /// Stream orders by user ID with fallback (for use when index is missing)
  Stream<List<OrderModel>> streamOrdersByUserIdFallback(String userId) {
    return _firestoreService
        .queryCollection(AppConstants.ordersCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          // Sort manually
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  /// Get all orders (for admin)
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.ordersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching orders: $e';
    }
  }

  /// Stream all orders (for admin - real-time)
  Stream<List<OrderModel>> streamAllOrders() {
    return _firestoreService
        .queryCollection(AppConstants.ordersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  /// Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.ordersCollection)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching orders by status: $e';
    }
  }

  /// Update order
  Future<void> updateOrder(OrderModel order) async {
    try {
      await _firestoreService.updateDocument(
        AppConstants.ordersCollection,
        order.id,
        order.copyWith().toFirestore(),
      );
    } catch (e) {
      throw 'Error updating order: $e';
    }
  }

  /// Update delivery boy location on all active orders for a driver.
  Future<void> updateDeliveryLocationForDeliveryBoy(
      String deliveryBoyId, double lat, double lng) async {
    try {
      final orders = await getOrdersByDeliveryBoyId(deliveryBoyId);
      for (final order in orders) {
        if (order.status == AppConstants.orderStatusDelivered ||
            order.status == AppConstants.orderStatusCancelled) {
          continue;
        }
        final updated = order.copyWith(
          deliveryBoyLocation: {'lat': lat, 'lng': lng},
        );
        await updateOrder(updated);
      }
    } catch (e) {
      throw 'Error updating delivery location on orders: $e';
    }
  }

  /// Assign delivery boy to order
  Future<void> assignDeliveryBoy(String orderId, String deliveryBoyId) async {
    try {
      await _firestoreService.updateDocument(
        AppConstants.ordersCollection,
        orderId,
        {
          'deliveryBoyId': deliveryBoyId,
          'status': AppConstants.orderStatusAssigned,
          'assignedAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      // Create in-app notification for the assigned delivery boy
      await _notificationRepository.createDeliveryBoyNotification(
        deliveryBoyId: deliveryBoyId,
        title: 'New order assigned',
        message: 'You have been assigned a new delivery order.',
        type: 'order_assigned',
        orderId: orderId,
      );
    } catch (e) {
      throw 'Error assigning delivery boy: $e';
    }
  }
}

