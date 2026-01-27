
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';

// TOP-LEVEL FUNCTION - Must be outside the class
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message: ${message.notification?.title}');
}

class NotificationService {
  static const String _channelId = 'app_notifications';
  static const String _channelName = 'App Notifications';
  static const String _channelDescription = 'General notifications';
  static const String _prefNotificationsEnabled = 'notifications_enabled';

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static bool _isNotificationsEnabled = true;

  static Future<void> initialize() async {
    // Set background handler FIRST
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initializeLocalNotifications();
    await _loadNotificationPreferences();
    await _initializeFirebase();
    await _setupFirebaseListeners();
  }

  static Future<void> getFcmToken() async {
    try {
      // Wait for initialization
      await Future.delayed(const Duration(seconds: 2));

      final NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: true, // Changed to false for explicit permission
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('❌ Notification permission denied');
        return;
      }

      // Get token with retry
      String? fcmToken;
      int attempts = 0;
      const maxAttempts = 3;

      while (fcmToken == null && attempts < maxAttempts) {
        attempts++;
        try {
          debugPrint('🔄 Attempting to get FCM token (attempt $attempts)');
          fcmToken = await _firebaseMessaging.getToken();

          if (fcmToken != null) {
            await PrefsHelper.setString(AppConstants.fcmToken, fcmToken);
            debugPrint('✅ FCM Token: $fcmToken');

            // Subscribe to topic
            await _firebaseMessaging.subscribeToTopic('signedInUsers');
            debugPrint('✅ Subscribed to signedInUsers topic');
            break;
          }
        } catch (error) {
          debugPrint('❌ Failed attempt $attempts: $error');
          if (attempts < maxAttempts) {
            await Future.delayed(Duration(seconds: attempts * 2));
          }
        }
      }

      if (fcmToken == null) {
        debugPrint('❌ Failed to get FCM token after $maxAttempts attempts');
      }
    } catch (error) {
      debugPrint('❌ Error getting FCM token: $error');
    }
  }

  static Future<void> _loadNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationsEnabled = prefs.getBool(_prefNotificationsEnabled) ?? true;
  }

  static Future<void> _saveNotificationPreference(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefNotificationsEnabled, isEnabled);
    _isNotificationsEnabled = isEnabled;
  }

  static Future<void> toggleNotifications(bool isEnabled) async {
    if (isEnabled) {
      debugPrint('✅ Notifications enabled');
    } else {
      await _localNotifications.cancelAll();
      debugPrint('❌ Notifications disabled and cleared');
    }
    await _saveNotificationPreference(isEnabled);
  }

  static Future<bool> getNotificationPreference() async {
    await _loadNotificationPreferences();
    return _isNotificationsEnabled;
  }

  static Future<void> _initializeFirebase() async {
    try {
      if (Platform.isIOS) {
        await Future.delayed(const Duration(seconds: 3));
      }

      final NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: true,
      );

      debugPrint('📱 Notification permission: ${settings.authorizationStatus}');

      await Future.delayed(const Duration(seconds: 1));

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {

        final savedToken = await PrefsHelper.getString(AppConstants.fcmToken);

        if (savedToken == null) {
          debugPrint("🔑 No saved token → getting new one");
          await getFcmToken();
        } else {
          debugPrint("🔑 Using saved FCM Token: $savedToken");
          await _firebaseMessaging.subscribeToTopic('signedInUsers');
        }
      } else {
        debugPrint('❌ Notification permission denied or not determined');
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        debugPrint('🔄 FCM Token refreshed: $newToken');
        await PrefsHelper.setString(AppConstants.fcmToken, newToken);
        await _firebaseMessaging.subscribeToTopic('signedInUsers');
      });
    } catch (error) {
      debugPrint('❌ Firebase initialization error: $error');
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Request Android permissions
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    debugPrint('✅ Local notifications initialized');
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _setupFirebaseListeners() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📬 Foreground message: ${message.notification?.title}');
      _handleForegroundMessage(message);
    });

    // Background/opened app messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📬 App opened from notification: ${message.notification?.title}');
      // Handle navigation here if needed

    });

    // Terminated state messages
    final RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('📬 App opened from terminated state: ${initialMessage.notification?.title}');
      // Handle navigation here if needed
    }

    debugPrint('✅ Firebase listeners setup complete');
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    if (!_isNotificationsEnabled) {
      debugPrint('⚠️ Notifications disabled, skipping');
      return;
    }

    final notification = message.notification;
    if (notification != null) {
      debugPrint('📨 Showing notification: ${notification.title}');
      _showLocalNotification(
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
      );
    }
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    if (!_isNotificationsEnabled) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        platformDetails,
      );

      debugPrint('✅ Local notification shown: $title');
    } catch (error) {
      debugPrint('❌ Error showing local notification: $error');
    }
  }

  static void _handleNotificationTap(NotificationResponse response) {
    debugPrint('👆 Notification tapped: ${response.payload}');
    // Add navigation logic here based on notification payload
    // Example: Navigate to specific screen based on notification type
    // Get.to(() => SpecificScreen(payload: response.payload));
  }

  /// Request notification permissions explicitly
  static Future<bool> requestNotificationPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      debugPrint('📱 Notification permission granted: $granted');
      return granted;
    } catch (e) {
      debugPrint('❌ Error requesting notification permission: $e');
      return false;
    }
  }

  /// Get the current FCM token
  static Future<String?> getFcmTokenDirect() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Unsubscribe from a specific topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic $topic: $e');
    }
  }

  static bool get isNotificationsEnabled => _isNotificationsEnabled;
}

class PrefsHelper {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}