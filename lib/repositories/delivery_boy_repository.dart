import '../models/delivery_boy_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

/// Repository for delivery boy operations
class DeliveryBoyRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Get all delivery boys
  Future<List<DeliveryBoyModel>> getAllDeliveryBoys() async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.deliveryBoysCollection)
          .get();

      return snapshot.docs
          .map((doc) => DeliveryBoyModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching delivery boys: $e';
    }
  }

  /// Get delivery boys by status
  Future<List<DeliveryBoyModel>> getDeliveryBoysByStatus(String status) async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.deliveryBoysCollection)
          .where('status', isEqualTo: status)
          .get();

      return snapshot.docs
          .map((doc) => DeliveryBoyModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching delivery boys by status: $e';
    }
  }

  /// Get delivery boy by ID
  Future<DeliveryBoyModel?> getDeliveryBoyById(String deliveryBoyId) async {
    try {
      final doc = await _firestoreService.getDocument(
          AppConstants.deliveryBoysCollection, deliveryBoyId);

      if (doc.exists) {
        return DeliveryBoyModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching delivery boy: $e';
    }
  }

  /// Create delivery boy
  Future<void> createDeliveryBoy(DeliveryBoyModel deliveryBoy) async {
    try {
      await _firestoreService.setDocument(
        AppConstants.deliveryBoysCollection,
        deliveryBoy.uid,
        deliveryBoy.toFirestore(),
      );
    } catch (e) {
      throw 'Error creating delivery boy: $e';
    }
  }

  /// Update delivery boy
  Future<void> updateDeliveryBoy(DeliveryBoyModel deliveryBoy) async {
    try {
      await _firestoreService.setDocument(
        AppConstants.deliveryBoysCollection,
        deliveryBoy.uid,
        deliveryBoy.toFirestore(),
      );
    } catch (e) {
      throw 'Error updating delivery boy: $e';
    }
  }

  /// Update delivery boy status
  Future<void> updateDeliveryBoyStatus(
      String deliveryBoyId, String status, bool isAvailable) async {
    try {
      final deliveryBoy = await getDeliveryBoyById(deliveryBoyId);
      if (deliveryBoy != null) {
        final updated = deliveryBoy.copyWith(
          status: status,
          isAvailable: isAvailable,
        );
        await updateDeliveryBoy(updated);
      }
    } catch (e) {
      throw 'Error updating delivery boy status: $e';
    }
  }

  /// Update delivery boy current location (lat, lng)
  Future<void> updateDeliveryBoyLocation(
      String deliveryBoyId, double lat, double lng) async {
    try {
      final deliveryBoy = await getDeliveryBoyById(deliveryBoyId);
      if (deliveryBoy != null) {
        final updated = deliveryBoy.copyWith(
          currentLocation: {'lat': lat, 'lng': lng},
        );
        await updateDeliveryBoy(updated);
      }
    } catch (e) {
      throw 'Error updating delivery boy location: $e';
    }
  }

  /// Delete delivery boy
  Future<void> deleteDeliveryBoy(String deliveryBoyId) async {
    try {
      await _firestoreService.deleteDocument(
          AppConstants.deliveryBoysCollection, deliveryBoyId);
    } catch (e) {
      throw 'Error deleting delivery boy: $e';
    }
  }

  /// Stream delivery boys (real-time)
  Stream<List<DeliveryBoyModel>> streamDeliveryBoys() {
    return _firestoreService
        .queryCollection(AppConstants.deliveryBoysCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DeliveryBoyModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}

