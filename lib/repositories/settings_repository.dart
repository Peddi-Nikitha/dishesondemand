import '../models/restaurant_settings_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

/// Repository for restaurant settings operations
class SettingsRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Get restaurant settings
  Future<RestaurantSettingsModel?> getSettings() async {
    try {
      final doc = await _firestoreService.getDocument(
          AppConstants.restaurantCollection, AppConstants.settingsDocument);

      if (doc.exists && doc.data() != null) {
        return RestaurantSettingsModel.fromFirestore(
            doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Error fetching settings: $e';
    }
  }

  /// Update restaurant settings
  Future<void> updateSettings(RestaurantSettingsModel settings) async {
    try {
      await _firestoreService.setDocument(
        AppConstants.restaurantCollection,
        AppConstants.settingsDocument,
        settings.toFirestore(),
      );
    } catch (e) {
      throw 'Error updating settings: $e';
    }
  }

  /// Stream settings (real-time)
  Stream<RestaurantSettingsModel?> streamSettings() {
    return _firestoreService
        .streamDocument(
            AppConstants.restaurantCollection, AppConstants.settingsDocument)
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return RestaurantSettingsModel.fromFirestore(
            doc.data()! as Map<String, dynamic>);
      }
      return null;
    });
  }
}
