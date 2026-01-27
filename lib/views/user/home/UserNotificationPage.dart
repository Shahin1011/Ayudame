import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../controller/user/home/notification_controller.dart';
import '../../../models/user/home/notification_model.dart';

class userNotificationPage extends StatelessWidget {
  const userNotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      appBar: CustomAppBar(title: "Notification"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.fetchNotifications,
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        if (controller.notificationList.isEmpty) {
          return const Center(child: Text("No notifications found!"));
        }

        return Column(
          children: [
            Expanded(
              child: Container(
                color: Color(0xFFF3F8F4),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: controller.notificationList.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notificationList[index];
                    return _buildNotificationItem(context, notification, controller);
                  },
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
    NotificationController controller,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                        notification.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                      GestureDetector(
                        onTap: (){
                          _showDeleteConfirmDialog(context, notification.id, controller);
                        },
                        child: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),

                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatTime(notification.createdAt),
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    // Simple time ago logic or date formatting
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _showDeleteConfirmDialog(BuildContext context, String id, NotificationController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Notification"),
          content: const Text("Are you sure you want to delete this notification?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteNotification(id);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
