import 'package:flutter/foundation.dart';
import '../models/delivery_boy_model.dart';
import '../repositories/delivery_boy_repository.dart';

/// Delivery boy provider for managing delivery boys state
class DeliveryBoyProvider with ChangeNotifier {
  final DeliveryBoyRepository _deliveryBoyRepository = DeliveryBoyRepository();

  List<DeliveryBoyModel> _deliveryBoys = [];
  bool _isLoading = false;
  String? _error;

  List<DeliveryBoyModel> get deliveryBoys => _deliveryBoys;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all delivery boys
  Future<void> loadDeliveryBoys() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _deliveryBoys = await _deliveryBoyRepository.getAllDeliveryBoys();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load delivery boys by status
  Future<void> loadDeliveryBoysByStatus(String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _deliveryBoys =
          await _deliveryBoyRepository.getDeliveryBoysByStatus(status);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create delivery boy
  Future<bool> createDeliveryBoy(DeliveryBoyModel deliveryBoy) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deliveryBoyRepository.createDeliveryBoy(deliveryBoy);
      await loadDeliveryBoys();

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

  /// Update delivery boy
  Future<bool> updateDeliveryBoy(DeliveryBoyModel deliveryBoy) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deliveryBoyRepository.updateDeliveryBoy(deliveryBoy);
      await loadDeliveryBoys();

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

  /// Update delivery boy status
  Future<bool> updateDeliveryBoyStatus(
      String deliveryBoyId, String status, bool isAvailable) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deliveryBoyRepository.updateDeliveryBoyStatus(
          deliveryBoyId, status, isAvailable);
      await loadDeliveryBoys();

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

  /// Delete delivery boy
  Future<bool> deleteDeliveryBoy(String deliveryBoyId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deliveryBoyRepository.deleteDeliveryBoy(deliveryBoyId);
      await loadDeliveryBoys();

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

