import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/services/business_auth_service.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class BusinessNotificationController extends GetxController {
  final BusinessAuthService _service = BusinessAuthService();
  var notifications = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _service
          .getNotifications(); // defaults: page=1, limit=20
      if (response['data'] != null) {
        notifications.assignAll(response['data']);
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes} mins ago';
      return 'Just now';
    } catch (e) {
      return '';
    }
  }
}

class BusinessNotificationPage extends StatelessWidget {
  const BusinessNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BusinessNotificationController());

    return Scaffold(
      appBar: const CustomAppBar(title: "Notification"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xFFF3F8F4),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.notifications.isEmpty) {
                    return const Center(child: Text("No notifications found"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final item = controller.notifications[index];
                      // Adjust fields based on actual API response structure
                      // Assuming: title, message, createdAt, etc.
                      return _buildNotificationItem(
                        item['senderAvatar'] ??
                            'https://via.placeholder.com/50',
                        item['title'] ?? 'Notification',
                        item['message'] ?? 'No detail provided',
                        controller.formatTime(item['createdAt']),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String avatarUrl,
    String title,
    String message,
    String time,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey[300],
            onBackgroundImageError: (_, __) {},
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.more_vert, size: 18.sp, color: Colors.grey[400]),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  time,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
