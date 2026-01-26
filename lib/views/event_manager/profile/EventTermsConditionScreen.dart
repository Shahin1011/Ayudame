import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../viewmodels/event_manager_viewmodel.dart';

class EventTermsConditionScreen extends StatefulWidget {
  const EventTermsConditionScreen({super.key});

  @override
  State<EventTermsConditionScreen> createState() =>
      _EventTermsConditionScreenState();
}

class _EventTermsConditionScreenState extends State<EventTermsConditionScreen> {
  final EventManagerViewModel _viewModel = Get.put(EventManagerViewModel());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchTermsAndConditions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Terms & Condition"),
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
                  'Terms & Condition',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _viewModel.termsContent.value.isEmpty
                      ? 'No terms and conditions available.'
                      : _viewModel.termsContent.value,
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
