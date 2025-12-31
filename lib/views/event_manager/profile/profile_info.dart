import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/app_icons.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/event_manager/profile/EventEditProfile.dart';

import '../../../widgets/custom_appbar.dart';

class ProfileInfoScreen extends StatelessWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: "Profile Info",
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.create,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              Get.to(() => const EventEditProfileScreen());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage(
                        'assets/images/profile.png', // replace image
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1C5941),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          AppIcons.create,
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Seam Rahman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C5941),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Event Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Personal Information
            _infoCard(
              title: 'Personal Information',
              children: const [
                _InfoRow(
                  iconPath: AppIcons.profileIcon,
                  label: 'Full Name',
                  value: 'Seam Rahman',
                ),
                _InfoRow(
                  iconPath: AppIcons.date,
                  label: 'Date of Birth',
                  value: 'May 15, 1990',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Contact Information
            _infoCard(
              title: 'Contact Information',
              children: const [
                _InfoRow(
                  iconPath: AppIcons.email,
                  label: 'Email',
                  value: 'alice@example.com',
                ),
                _InfoRow(
                  iconPath: AppIcons.phone,
                  label: 'Phone',
                  value: '+1 (555) 123-4567',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Identification
            _infoCard(
              title: 'Identification',
              children: const [
                _InfoRow(
                  iconPath: AppIcons.id,
                  label: 'ID Type',
                  value: 'Passport',
                ),
                _InfoRow(
                  iconPath: AppIcons.id,
                  label: 'ID Number',
                  value: 'P123456789',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Business Information
            _infoCard(
              title: 'Business Information',
              children: const [
                _InfoRow(
                  iconPath: AppIcons.category,
                  label: 'Category',
                  value: 'Entertainment',
                ),
                _InfoRow(
                  iconPath: AppIcons.location,
                  label: 'Address',
                  value: '123 Event Street, New York, NY 10001',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Card
  static Widget _infoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

// Reusable Row Widget
class _InfoRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _InfoRow({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
