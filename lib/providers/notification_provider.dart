import 'package:flutter/foundation.dart';

import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

/// Provider for managing notifications state (delivery boy).
class NotificationProvider with ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;
  String? _deliveryBoyId;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  /// Attach delivery boy id and start listening to notifications.
  void setDeliveryBoyId(String? id) {
    if (_deliveryBoyId == id) return;

    _deliveryBoyId = id;

    if (_deliveryBoyId != null) {
      _listenToNotifications();
    } else {
      _notifications = [];
      notifyListeners();
    }
  }

  void _listenToNotifications() {
    if (_deliveryBoyId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    _repository
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

  Future<void> markAllAsRead() async {
    if (_deliveryBoyId == null) return;
    await _repository.markAllAsRead(_deliveryBoyId!);
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);
  }
}


