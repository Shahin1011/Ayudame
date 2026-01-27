import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../viewmodels/event_manager_viewmodel.dart';

class EventPrivacyPolicyScreen extends StatefulWidget {
  const EventPrivacyPolicyScreen({super.key});

  @override
  State<EventPrivacyPolicyScreen> createState() =>
      _EventPrivacyPolicyScreenState();
}

class _EventPrivacyPolicyScreenState extends State<EventPrivacyPolicyScreen> {
  // Use Get.put to ensure the controller is available if not already found
  final EventManagerViewModel _viewModel = Get.put(EventManagerViewModel());

  @override
  void initState() {
    super.initState();
    // Fetch policy when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchPrivacyPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Privacy Policy"),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy & Policy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Dynamic Content
              Text(
                _viewModel.privacyPolicyContent.value.isEmpty
                    ? 'No privacy policy available.'
                    : _viewModel.privacyPolicyContent.value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
