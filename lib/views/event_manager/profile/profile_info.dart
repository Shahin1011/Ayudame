import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/app_icons.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/event_manager/profile/EventEditProfile.dart';
import 'package:middle_ware/viewmodels/event_manager_viewmodel.dart';
import '../../../widgets/custom_appbar.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final EventManagerViewModel _viewModel = Get.find<EventManagerViewModel>();

  @override
  void initState() {
    super.initState();
    // Fetch newly when entering this screen to ensure fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: "Profile Info",
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.profileIcon,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () async {
              await Get.to(() => const EventEditProfileScreen());
              _viewModel.fetchProfile();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final manager = _viewModel.currentManager.value;

        if (manager == null) {
          return const Center(child: Text("Failed to load profile"));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await _viewModel.fetchProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              manager.profilePicture != null &&
                                  manager.profilePicture!.isNotEmpty
                              ? NetworkImage(manager.profilePicture!)
                                    as ImageProvider
                              : const AssetImage('assets/images/profile.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await Get.to(
                                () => const EventEditProfileScreen(),
                              );
                              _viewModel.fetchProfile();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1C5941),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                AppIcons.camera,
                                width: 16,
                                height: 16,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      manager.fullName ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
                      child: Text(
                        manager.userType ?? 'Event Manager',
                        style: const TextStyle(
                          fontFamily: "Inter",
                          color: Colors.white,
                          fontSize: 14,
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
                  children: [
                    _InfoRow(
                      iconPath: AppIcons.profileIcon,
                      label: 'Full Name',
                      value: manager.fullName ?? 'N/A',
                    ),
                    _InfoRow(
                      iconPath: AppIcons.date,
                      label: 'Date of Birth',
                      value: manager.dateOfBirth ?? 'N/A',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Contact Information
                _infoCard(
                  title: 'Contact Information',
                  children: [
                    _InfoRow(
                      iconPath: AppIcons.email,
                      label: 'Email',
                      value: manager.email ?? 'N/A',
                    ),
                    _InfoRow(
                      iconPath: AppIcons.phone,
                      label: 'Phone',
                      value: manager.phoneNumber ?? 'N/A',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Identification
                _infoCard(
                  title: 'Identification',
                  children: [
                    _InfoRow(
                      iconPath: AppIcons.id,
                      label: 'ID Type',
                      value: manager.idType ?? 'N/A',
                    ),
                    _InfoRow(
                      iconPath: AppIcons.id,
                      label: 'ID Number',
                      value: manager.identificationNumber ?? 'N/A',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Business Information
                _infoCard(
                  title: 'Business Information',
                  children: [
                    _InfoRow(
                      iconPath: AppIcons.category,
                      label: 'Category',
                      value: manager.category ?? 'N/A',
                    ),
                    _InfoRow(
                      iconPath: AppIcons.location,
                      label: 'Address',
                      value: manager.address ?? 'N/A',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
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
