import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0ED),
      appBar: CustomAppBar(title: "Contract us"),
      body: Column(
        children: [
          SizedBox(height: 20.h),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildContactItem(
                    icon: Icons.camera_alt_outlined,
                    title: 'Instagram',
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildContactItem(
                    icon: Icons.language,
                    title: 'Website',
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 12),

                // Twitter
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildContactItem(
                    icon: Icons.phone_outlined,
                    title: 'Twitter',
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildContactItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    onTap: () {
                      // Launch Email
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
