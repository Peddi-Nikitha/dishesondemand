import 'package:flutter/foundation.dart';
import '../models/restaurant_settings_model.dart';
import '../repositories/settings_repository.dart';

/// Settings provider for managing restaurant settings state
class SettingsProvider with ChangeNotifier {
  final SettingsRepository _settingsRepository = SettingsRepository();

  RestaurantSettingsModel? _settings;
  bool _isLoading = false;
  String? _error;

  RestaurantSettingsModel? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load settings
  Future<void> loadSettings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _settings = await _settingsRepository.getSettings();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update settings
  Future<bool> updateSettings(RestaurantSettingsModel settings) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _settingsRepository.updateSettings(settings);
      _settings = settings;

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

