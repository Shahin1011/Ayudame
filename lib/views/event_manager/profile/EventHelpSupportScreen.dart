import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

import 'EventContactUsScreen.dart';
import 'EventFaqScreen.dart';

class EventHelpSupportScreen extends StatelessWidget {
  const EventHelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Help & Support"),
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [


          const SizedBox(height: 16),

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
                  child: _buildMenuItem(title: 'Faq',  onTap: () => Get.to(() => EventFaqScreen()),),
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
                  child: _buildMenuItem(
                    title: 'Contact Us',
                    onTap: () => Get.to(() => EventContactUsScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
