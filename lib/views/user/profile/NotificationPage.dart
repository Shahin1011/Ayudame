
import 'package:flutter/material.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Notification"),
      body: SafeArea(
        child: Column(
          children: [
            
            // Notifications List
            Expanded(
            child: Container(
            color: Color(0xFFF3F8F4),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),

                children: [
                  _buildNotificationItem(
                    'https://randomuser.me/api/portraits/men/32.jpg',
                    'New message from Tannin',
                    'Hes, I need your recent works asap! I\'ll be waite...',
                    '1 day ago',
                  ),
                  _buildNotificationItem(
                    'https://randomuser.me/api/portraits/women/44.jpg',
                    'New message from Saran Chen',
                    'Hes, I need your recent works asap! I\'ll be waite...',
                    '2 day ago',
                  ),
                  _buildNotificationItem(
                    'https://randomuser.me/api/portraits/women/65.jpg',
                    'New message from Saran Chen',
                    'Hes, I need your recent works asap! I\'ll be waite...',
                    '3 day ago',
                  ),
                  _buildNotificationItem(
                    'https://randomuser.me/api/portraits/women/28.jpg',
                    'New message from Saran Chen',
                    'Hes, I need your recent works asap! I\'ll be waite...',
                    '4 day ago',
                  ),
                ],
              ),
            ),
            )
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),

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
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 12),
          // Content
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
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}