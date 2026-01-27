import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../models/delivery_boy_model.dart';
import '../models/admin_model.dart';
import '../repositories/user_repository.dart';
import '../repositories/delivery_boy_repository.dart';

/// Auth provider for managing authentication state
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();
  final DeliveryBoyRepository _deliveryBoyRepository = DeliveryBoyRepository();

  User? _user;
  String? _userRole;
  UserModel? _userModel;
  DeliveryBoyModel? _deliveryBoyModel;
  AdminModel? _adminModel;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get userRole => _userRole;
  UserModel? get userModel => _userModel;
  DeliveryBoyModel? get deliveryBoyModel => _deliveryBoyModel;
  AdminModel? get adminModel => _adminModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _clearUserData();
      }
      notifyListeners();
    });
  }

  /// Load user data based on role
  Future<void> _loadUserData(String uid) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _userRole = await _authService.getUserRole(uid);

      if (_userRole == 'user') {
        _userModel = await _userRepository.getUserById(uid);
      } else if (_userRole == 'delivery_boy') {
        _deliveryBoyModel = await _deliveryBoyRepository.getDeliveryBoyById(uid);
      } else if (_userRole == 'admin') {
        // Load admin data
        // TODO: Implement AdminRepository
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear user data
  void _clearUserData() {
    _userRole = null;
    _userModel = null;
    _deliveryBoyModel = null;
    _adminModel = null;
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Wait for user data to be loaded via authStateChanges listener
      // The listener triggers _loadUserData which determines the role
      if (_user != null) {
        // Wait for role to be determined (max 3 seconds)
        int retryCount = 0;
        while (_userRole == null && retryCount < 10) {
          await Future.delayed(const Duration(milliseconds: 300));
          retryCount++;
        }
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

  /// Create account
  Future<bool> createAccount({
    required String email,
    required String password,
    required String role,
    String? name,
    String? phone,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        role: role,
        name: name,
        phone: phone,
      );

      // User data will be loaded via authStateChanges listener
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _clearUserData();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get user favorites (product IDs)
  List<String> get favorites => _userModel?.favorites ?? [];

  /// Check if product is favorited
  bool isFavorite(String productId) {
    return _userModel?.favorites.contains(productId) ?? false;
  }

  /// Add product to favorites
  Future<bool> addFavorite(String productId) async {
    if (_user == null || _userModel == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    try {
      if (!_userModel!.favorites.contains(productId)) {
        await _userRepository.addFavorite(_user!.uid, productId);
        // Reload user data to get updated favorites
        await _loadUserData(_user!.uid);
        return true;
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove product from favorites
  Future<bool> removeFavorite(String productId) async {
    if (_user == null || _userModel == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    try {
      await _userRepository.removeFavorite(_user!.uid, productId);
      // Reload user data to get updated favorites
      await _loadUserData(_user!.uid);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String productId) async {
    if (isFavorite(productId)) {
      return await removeFavorite(productId);
    } else {
      return await addFavorite(productId);
    }
  }

  /// Add address to user
  Future<bool> addAddress(AddressModel address) async {
    if (_user == null || _userModel == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    try {
      await _userRepository.addAddress(_user!.uid, address);
      // Reload user data to get updated addresses
      await _loadUserData(_user!.uid);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update address in user
  Future<bool> updateAddress(AddressModel address) async {
    if (_user == null || _userModel == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    try {
      await _userRepository.updateAddress(_user!.uid, address);
      // Reload user data to get updated addresses
      await _loadUserData(_user!.uid);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete address from user
  Future<bool> deleteAddress(String addressId) async {
    if (_user == null || _userModel == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    try {
      await _userRepository.deleteAddress(_user!.uid, addressId);
      // Reload user data to get updated addresses
      await _loadUserData(_user!.uid);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update user profile (name, phone)
  Future<bool> updateProfile({String? name, String? phone}) async {
    if (_user == null || _userModel == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedUser = _userModel!.copyWith(
        name: name,
        phone: phone,
      );
      await _userRepository.updateUser(updatedUser);
      
      // Reload user data to get updated profile
      await _loadUserData(_user!.uid);

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

  /// Update delivery boy profile (name, phone)
  Future<bool> updateDeliveryBoyProfile({String? name, String? phone}) async {
    if (_user == null || _deliveryBoyModel == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updated = _deliveryBoyModel!.copyWith(
        name: name,
        phone: phone,
      );
      await _deliveryBoyRepository.updateDeliveryBoy(updated);

      // Reload user data to get updated profile
      await _loadUserData(_user!.uid);

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

  /// Update delivery boy current location
  Future<bool> updateDeliveryBoyLocation({
    required double latitude,
    required double longitude,
  }) async {
    if (_user == null || _deliveryBoyModel == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    try {
      await _deliveryBoyRepository.updateDeliveryBoyLocation(
        _user!.uid,
        latitude,
        longitude,
      );
      await _loadUserData(_user!.uid);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Reload user data (useful after updates)
  Future<void> reloadUserData() async {
    if (_user != null) {
      await _loadUserData(_user!.uid);
    }
  }

  /// Get user-friendly error message from Firebase Auth exception
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'email-already-in-use':
        return 'An account with this email already exists. Please sign in instead.';
      case 'invalid-email':
        return 'The email address is invalid. Please check and try again.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many requests. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return e.message ?? 'An error occurred: ${e.code}';
    }
  }
}

