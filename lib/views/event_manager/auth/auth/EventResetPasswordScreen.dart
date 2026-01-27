import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/viewmodels/event_manager_viewmodel.dart';

class EventResetPasswordScreen extends StatefulWidget {
  const EventResetPasswordScreen({super.key});

  @override
  State<EventResetPasswordScreen> createState() =>
      _EventResetPasswordScreenState();
}

class _EventResetPasswordScreenState extends State<EventResetPasswordScreen> {
  final _viewModel = Get.find<EventManagerViewModel>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: const Color(
          0xFFF5F5F5,
        ), // Matched BusinessResetPasswordScreen
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Title
            const Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            const Text(
              'Enter your new password to reset your account access.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // New Password Label
            const Text(
              'New Password',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter new password',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1C5941)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Confirm Password Label
            const Text(
              'Confirm Password',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Re-enter new password',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1C5941)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _viewModel.isLoading.value
                      ? null
                      : () {
                          _viewModel.resetPassword(
                            _newPasswordController.text,
                            _confirmPasswordController.text,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C5941),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _viewModel.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
