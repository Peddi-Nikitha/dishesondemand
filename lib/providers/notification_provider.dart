import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

/// Provider for managing notifications state (delivery boy and user).
class NotificationProvider with ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;
  String? _deliveryBoyId;
  String? _userId;
  StreamSubscription<List<AppNotification>>? _subscription;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Attach delivery boy id and start listening to notifications.
  void setDeliveryBoyId(String? id) {
    if (_deliveryBoyId == id) return;

    _subscription?.cancel();
    _deliveryBoyId = id;
    _userId = null; // Clear userId when setting deliveryBoyId

    if (_deliveryBoyId != null) {
      _listenToDeliveryBoyNotifications();
    } else {
      _notifications = [];
      notifyListeners();
    }
  }

  /// Attach user id and start listening to notifications.
  void setUserId(String? id) {
    if (_userId == id) return;

    _subscription?.cancel();
    _userId = id;
    _deliveryBoyId = null; // Clear deliveryBoyId when setting userId

    if (_userId != null) {
      _listenToUserNotifications();
    } else {
      _notifications = [];
      notifyListeners();
    }
  }

  void _listenToDeliveryBoyNotifications() {
    if (_deliveryBoyId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = _repository
        .streamNotificationsForDeliveryBoy(_deliveryBoyId!)
        .listen((data) {
      _notifications = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  void _listenToUserNotifications() {
    if (_userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = _repository
        .streamNotificationsForUser(_userId!)
        .listen((data) {
      _notifications = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> markAllAsRead() async {
    if (_deliveryBoyId != null) {
      await _repository.markAllAsReadForDeliveryBoy(_deliveryBoyId!);
    } else if (_userId != null) {
      await _repository.markAllAsReadForUser(_userId!);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);
  }
}


