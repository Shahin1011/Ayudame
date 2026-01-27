// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:middle_ware/services/api_service.dart';
// import 'package:middle_ware/utils/token_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'local_notifications_service.dart';
//
//
// class FirebaseMessagingService {
//   FirebaseMessagingService._internal();
//
//   static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
//   final firebaseMessagingService = FirebaseMessagingService.instance();
//
//
//   factory FirebaseMessagingService.instance() => _instance;
//
//   LocalNotificationsService? _localNotificationsService;
//
//   Future<void> init({required LocalNotificationsService localNotificationsService}) async {
//     _localNotificationsService = localNotificationsService;
//
//     _handlePushNotificationsToken();
//
//     _requestPermission();
//
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     FirebaseMessaging.onMessage.listen(_onForegroundMessage);
//
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
//
//     // Check for initial message that opened the app from terminated state
//     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _onMessageOpenedApp(initialMessage);
//     }
//   }
//
//   /// Retrieves and manages the FCM token for push notifications
//   Future<void> _handlePushNotificationsToken() async {
//     // Get the FCM token for the device
//     final token = await FirebaseMessaging.instance.getToken();
//     print('Push notifications token: $token');
//
//     if (token != null) {
//       _sendTokenToServer(token);
//     }
//
//     // Listen for token refresh events
//     FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
//       print('FCM token refreshed: $fcmToken');
//       _sendTokenToServer(fcmToken);
//     }).onError((error) {
//       // Handle errors during token refresh
//       print('Error refreshing FCM token: $error');
//     });
//   }
//
//   Future<void> _sendTokenToServer(String token) async {
//     try {
//       final authToken = await TokenService().getToken();
//       if (authToken == null) return;
//
//       final url = Uri.parse("${ApiService.BASE_URL}/api/notifications/register-token");
//
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $authToken',
//         },
//         body: jsonEncode({'fcmToken': token}),
//       );
//
//       print("Token Sync Status: ${response.statusCode}");
//     } catch (e) {
//       print("Error sending FCM token to server: $e");
//     }
//   }
//
//   /// Requests notification permission from the user
//   Future<void> _requestPermission() async {
//     // Request permission for alerts, badges, and sounds
//     final result = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Log the user's permission decision
//     print('User granted permission: ${result.authorizationStatus}');
//   }
//
//   /// Handles messages received while the app is in the foreground
//   void _onForegroundMessage(RemoteMessage message) {
//     print('Foreground message received: ${message.data.toString()}');
//     final notificationData = message.notification;
//     if (notificationData != null) {
//       // Display a local notification using the service
//       _localNotificationsService?.showNotification(
//           notificationData.title, notificationData.body, message.data.toString()
//         );
//     }
//   }
//
//   void _onMessageOpenedApp(RemoteMessage message) {
//     print('Notification caused the app to open: ${message.data.toString()}');
//     // TODO: Add navigation or specific handling based on message data
//   }
// }
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Background message received: ${message.data.toString()}');
// }