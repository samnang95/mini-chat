import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/services/user_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    // Request permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // Get FCM Token
      try {
        if (GetPlatform.isIOS) {
          // Wait for APNS token on iOS before getting FCM token
          await _fcm.getAPNSToken();
        }
        
        String? token = await _fcm.getToken();
        if (token != null) {
          print('FCM Token: $token');
          _saveTokenToDatabase(token);
        }
      } catch (e) {
        print('Warning: Failed to get FCM token. (This is normal on iOS Simulators): $e');
      }

      // Listen to token refreshes
      _fcm.onTokenRefresh.listen(_saveTokenToDatabase);

      // Initialize Local Notifications for Foreground
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
      
      await _localNotifications.initialize(initSettings);

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        _showLocalNotification(message);
      });

      // Background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }

    return this;
  }

  void _saveTokenToDatabase(String token) {
    try {
      final userService = Get.find<UserService>();
      if (userService.currentUser.value != null) {
        userService.updateFcmToken(token);
      }
    } catch (e) {
      print('Could not save token: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
      );
    }
  }
}
