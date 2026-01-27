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
    return _firestoreService.instance
        .collection(AppConstants.notificationsCollection)
        .where('deliveryBoyId', isEqualTo: deliveryBoyId)
        .orderBy('createdAt', descending: true);
  }

  /// Stream notifications for a delivery boy.
  Stream<List<AppNotification>> streamNotificationsForDeliveryBoy(
      String deliveryBoyId) {
    return _baseQueryForDeliveryBoy(deliveryBoyId).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => AppNotification.fromFirestore(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
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
}


