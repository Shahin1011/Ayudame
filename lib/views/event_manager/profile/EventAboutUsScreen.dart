import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../viewmodels/event_manager_viewmodel.dart';

class EventAboutUsScreen extends StatefulWidget {
  const EventAboutUsScreen({Key? key}) : super(key: key);

  @override
  State<EventAboutUsScreen> createState() => _EventAboutUsScreenState();
}

class _EventAboutUsScreenState extends State<EventAboutUsScreen> {
  final EventManagerViewModel _viewModel = Get.put(EventManagerViewModel());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchAboutUs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "About Us"),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _viewModel.aboutUsContent.value.isEmpty
                      ? 'No about us information available.'
                      : _viewModel.aboutUsContent.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
