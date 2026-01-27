/// App constants
class AppConstants {
  AppConstants._();

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String deliveryBoysCollection = 'deliveryBoys';
  static const String adminsCollection = 'admins';
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String ordersCollection = 'orders';
  static const String restaurantCollection = 'restaurant';
  static const String settingsDocument = 'settings';
  static const String notificationsCollection = 'notifications';

  // User Roles
  static const String roleUser = 'user';
  static const String roleDeliveryBoy = 'delivery_boy';
  static const String roleAdmin = 'admin';

  // Order Status
  static const String orderStatusPending = 'pending';
  static const String orderStatusConfirmed = 'confirmed';
  static const String orderStatusPreparing = 'preparing';
  static const String orderStatusReady = 'ready';
  static const String orderStatusAssigned = 'assigned';
  static const String orderStatusPickedUp = 'picked_up';
  static const String orderStatusInTransit = 'in_transit';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';

  // Delivery Boy Status
  static const String deliveryBoyStatusActive = 'active';
  static const String deliveryBoyStatusInactive = 'inactive';
  static const String deliveryBoyStatusPending = 'pending';
}

