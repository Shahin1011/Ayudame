import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/business/employee/create_employee.dart';
import '../../../../models/business_employee_model.dart';
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
                _viewModel.fetchAllEmployees(
                  forceRefresh: true,
                ); // Force refresh after return
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
                        borderRadius: 12,
                        name: employee.name ?? 'No Name',
                        location:
                            employee.headline ??
                            employee.serviceCategory ??
                            'Service Provider', // Using headline or category as sub-text
                        serviceTitle:
                            employee.headline ??
                            employee.serviceCategory ??
                            'Service',
                        description:
                            employee.about ?? 'No description available',
                        rating: employee.rating ?? 0.0,
                        reviewCount: employee.totalReviews ?? 0,
                        price: _getDisplayPrice(employee),
                        onViewDetails: () {
                          Get.toNamed(
                            AppRoutes.businessEmployee,
                            arguments: employee,
                          );
                        },
                        imageUrl:
                            (employee.servicePhoto != null &&
                                employee.servicePhoto!.isNotEmpty)
                            ? employee.servicePhoto!
                            : 'assets/images/men_cleaning.jpg',
                        profileUrl:
                            (employee.profilePicture != null &&
                                employee.profilePicture!.isNotEmpty)
                            ? employee.profilePicture!
                            : 'assets/images/profile.png',
                        postedTime: employee.availableTime ?? 'Available',
                        showOnlineIndicator: true,
                        showFavorite: false,
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

  String _getDisplayPrice(BusinessEmployeeModel employee) {
    if (employee.appointmentOptions != null &&
        employee.appointmentOptions!.isNotEmpty) {
      final prices = employee.appointmentOptions!
          .map((e) => e.price)
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      if (prices.isNotEmpty) {
        prices.sort();
        return "\$${prices.first.toStringAsFixed(0)}";
      }
    }
    return "\$${employee.pricing}";
  }
}
