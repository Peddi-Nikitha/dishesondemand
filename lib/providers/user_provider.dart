import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

/// User provider for managing users (admin view)
class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<UserModel> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  /// Load all users
  Future<void> loadAllUsers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _users = await _userRepository.getAllUsers();
      _applySearchFilter();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream all users (real-time)
  Stream<List<UserModel>> streamAllUsers() {
    return _userRepository.streamAllUsers();
  }

  /// Search users
  Future<void> searchUsers(String query) async {
    try {
      _isLoading = true;
      _error = null;
      _searchQuery = query;
      notifyListeners();

      if (query.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers = await _userRepository.searchUsers(query);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Apply search filter to current users list
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = _users;
    } else {
      final lowerQuery = _searchQuery.toLowerCase();
      _filteredUsers = _users.where((user) {
        return (user.name?.toLowerCase().contains(lowerQuery) ?? false) ||
            user.email.toLowerCase().contains(lowerQuery) ||
            (user.phone?.contains(_searchQuery) ?? false);
      }).toList();
    }
  }

  /// Update search query and filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applySearchFilter();
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

