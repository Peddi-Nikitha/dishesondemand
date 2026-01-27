/// Notification model for delivery boy and user notifications.
class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // e.g. 'order', 'promo', 'system'
  final String? orderId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.orderId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return AppNotification(
      id: id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? 'system',
      orderId: data['orderId'],
      isRead: data['isRead'] ?? false,
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'orderId': orderId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? title,
    String? message,
    String? type,
    String? orderId,
    bool? isRead,
  }) {
    return AppNotification(
      id: id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      orderId: orderId ?? this.orderId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}


