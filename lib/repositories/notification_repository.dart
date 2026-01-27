import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

/// Repository for loading and updating notifications from Firestore.
///
/// For now this assumes a flat `notifications` collection filtered by `deliveryBoyId`.
class NotificationRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Query<Map<String, dynamic>> _baseQueryForDeliveryBoy(String deliveryBoyId) {
    // Simple query without orderBy to avoid requiring a composite index.
    // We sort results by createdAt on the client side instead.
    return _firestoreService.instance
        .collection(AppConstants.notificationsCollection)
        .where('deliveryBoyId', isEqualTo: deliveryBoyId);
  }

  /// Stream notifications for a delivery boy.
  Stream<List<AppNotification>> streamNotificationsForDeliveryBoy(
      String deliveryBoyId) {
    return _baseQueryForDeliveryBoy(deliveryBoyId).snapshots().map(
      (snapshot) {
        final list = snapshot.docs
            .map(
              (doc) => AppNotification.fromFirestore(
                doc.data(),
                doc.id,
              ),
            )
            .toList();
        // Sort by createdAt descending on the client.
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      },
    );
  }

  /// Mark all notifications for a delivery boy as read.
  Future<void> markAllAsRead(String deliveryBoyId) async {
    final querySnapshot = await _baseQueryForDeliveryBoy(deliveryBoyId).get();
    final batch = _firestoreService.instance.batch();

    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    final docRef = _firestoreService.instance
        .collection(AppConstants.notificationsCollection)
        .doc(notificationId);
    await docRef.update({'isRead': true});
  }

  /// Create a notification for a delivery boy (in-app feed).
  Future<void> createDeliveryBoyNotification({
    required String deliveryBoyId,
    required String title,
    required String message,
    String type = 'order',
    String? orderId,
  }) async {
    final docRef = _firestoreService.instance
        .collection(AppConstants.notificationsCollection)
        .doc();
    final notification = AppNotification(
      id: docRef.id,
      title: title,
      message: message,
      type: type,
      orderId: orderId,
      isRead: false,
      createdAt: DateTime.now(),
    );
    await docRef.set({
      ...notification.toFirestore(),
      'deliveryBoyId': deliveryBoyId,
    });
  }
}


