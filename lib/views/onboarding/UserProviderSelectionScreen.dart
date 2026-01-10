import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';

import '../../core/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
class UserProviderSelectionScreen extends StatefulWidget {
  const UserProviderSelectionScreen({super.key});

  @override
  State<UserProviderSelectionScreen> createState() =>
      _UserProviderSelectionScreenState();
}

class _UserProviderSelectionScreenState
    extends State<UserProviderSelectionScreen> {
  String selectedType = 'User'; // Default selection

  void _navigateToSelectedScreen() {
    switch (selectedType) {
      case 'User':
        Get.toNamed(AppRoutes.userlogin);
        break;
      case 'Provider':
        Get.toNamed(AppRoutes.providerLogin);
        break;
      case 'Business owner':
        Get.toNamed(AppRoutes.businessLogin);
        break;
      case 'Event manager':
        Get.toNamed(AppRoutes.eventLogin);
        break;
    }
  }

  Widget _buildSelectionCard({
    required String type,
    required String iconPath,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C5941) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1C5941)
                : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : const Color(0xFF1C5941),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1C5941),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First Row
              Row(
                children: [
                  Expanded(
                    child: _buildSelectionCard(
                      type: 'User',
                      iconPath: 'assets/images/user.svg',
                      isSelected: selectedType == 'User',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSelectionCard(
                      type: 'Provider',
                      iconPath: 'assets/images/provider.svg',
                      isSelected: selectedType == 'Provider',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Second Row
              Row(
                children: [
                  Expanded(
                    child: _buildSelectionCard(
                      type: 'Business owner',
                      iconPath: 'assets/images/business.svg',
                      isSelected: selectedType == 'Business owner',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSelectionCard(
                      type: 'Event manager',
                      iconPath: 'assets/images/event.svg',
                      isSelected: selectedType == 'Event manager',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToSelectedScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C5941),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
