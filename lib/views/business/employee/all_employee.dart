import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/business/employee/create_employee.dart';
import '../../../../viewmodels/business_employee_viewmodel.dart';

import '../../../core/routes/app_routes.dart';
import '../../../widgets/CustomDashedBorder.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/provider_ui_card.dart';

class BusinessEmployeeListScreen extends StatelessWidget {
  BusinessEmployeeListScreen({super.key});

  final BusinessEmployeeViewModel _viewModel = Get.put(
    BusinessEmployeeViewModel(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "My Employee "),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 🔹 Create Employee Button (Dashed)
            InkWell(
              onTap: () async {
                await Get.to(() => const CreateEmployee());
                _viewModel.fetchAllEmployees(); // Refresh after return
              },
              child: CustomPaint(
                painter: DashedBorderPainter(
                  color: const Color(0xFF1E5631),
                  strokeWidth: 1.5,
                  dashWidth: 6,
                  dashSpace: 4,
                  borderRadius: 12,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Create an employee",
                        style: TextStyle(
                          color: Color(0xFF1E5631),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.add, color: Color(0xFF1E5631)),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 🔹 Employee List
            Expanded(
              child: Obx(() {
                if (_viewModel.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1E5631)),
                  );
                }

                if (_viewModel.employeeList.isEmpty) {
                  return const Center(child: Text("No employees found"));
                }

                return ListView.builder(
                  itemCount: _viewModel.employeeList.length,
                  itemBuilder: (context, index) {
                    final employee = _viewModel.employeeList[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to detail screen, passing the employee object or ID
                        Get.toNamed(
                          AppRoutes.businessEmployee,
                          arguments: employee,
                        );
                      },
                      child: ProviderUICard(
                        name: employee.name ?? 'No Name',
                        location:
                            employee.headline ??
                            'No Headline', // Using headline as sub-text
                        serviceTitle: employee.serviceCategory ?? 'Service',
                        description:
                            employee.about ?? 'No description available',
                        rating: 4.5, // Placeholder rating
                        reviewCount: 0, // Placeholder
                        price: '\$${employee.price?.toStringAsFixed(0) ?? '0'}',
                        onViewDetails: () {
                          Get.toNamed(
                            AppRoutes.businessEmployee,
                            arguments: employee,
                          );
                        },
                        // Use servicePhoto (idCardBack) as the main service image
                        imageUrl:
                            (employee.idCardBack != null &&
                                employee.idCardBack!.isNotEmpty)
                            ? employee.idCardBack!
                            : 'assets/images/men_cleaning.jpg',
                        // Use photo (profileImage) as the profile picture
                        profileUrl:
                            (employee.profileImage != null &&
                                employee.profileImage!.isNotEmpty)
                            ? employee.profileImage!
                            : 'assets/images/profile.png',
                        postedTime: employee.availableTime ?? 'Available',
                        showOnlineIndicator: true,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
