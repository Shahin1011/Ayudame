import 'dart:convert';
import 'package:get/get.dart';
import 'package:middle_ware/services/api_service.dart';
import '../../../models/user/home/notification_model.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notificationList = <NotificationModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await ApiService.get(
        endpoint: '/api/notifications?page=1&limit=20',
        requireAuth: true,
      );

      print("Notification Response Status: ${response.statusCode}");
      print("Notification Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final model = NotificationResponse.fromJson(body);
        
        if (model.success) {
          notificationList.assignAll(model.data.notifications);
        } else {
           errorMessage.value = "Failed to load notifications: Success=false";
        }
      } else {
        errorMessage.value = "Failed to load notifications: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      // Optimistic update or waiting for response?
      // Usually better to show loading during delete.
      
      final response = await ApiService.delete(
        endpoint: '/notifications/$id',
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        // Success, remove from list
        notificationList.removeWhere((notification) => notification.id == id);
        Get.snackbar("Success", "Notification deleted successfully");
        fetchNotifications(); // Refresh list to be sure
      } else {
        Get.snackbar("Error", "Failed to delete notification");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
