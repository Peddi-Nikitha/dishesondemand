import 'package:firebase_messaging/firebase_messaging.dart';

/// Wrapper around Firebase Cloud Messaging configuration.
class MessagingService {
  MessagingService._internal();

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permissions (especially important on iOS / web)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Optionally configure how notifications are presented when app is in foreground (iOS/macOS)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token (can be sent to backend if needed)
    await _messaging.getToken();

    // Listen for messages while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // For now we just keep this hook; UI-specific handling can be added later.
    });

    // When user taps on a notification and opens the app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navigation based on message.data can be handled here in the future.
    });
  }
}


