import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/business/employee/all_employee.dart';
import 'package:middle_ware/views/business/home/provider.dart';
import '../../../core/app_icons.dart';
import '../../../core/routes/app_routes.dart';
import 'BusinessNotificationPage.dart';
import '../../../widgets/provider_ui_card.dart';
import '../../../viewmodels/business_auth_viewmodel.dart';

class BusinessHomePageScreen extends StatefulWidget {
  const BusinessHomePageScreen({super.key});

  @override
  State<BusinessHomePageScreen> createState() => _BusinessHomePageScreenState();
}

class _BusinessHomePageScreenState extends State<BusinessHomePageScreen> {
  final BusinessAuthViewModel _viewModel = Get.put(BusinessAuthViewModel());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.getStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColors.mainAppColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
            child: Obx(() {
              final business = _viewModel.currentBusiness.value;
              return Row(
                children: [
                  Container(
                    height: 51,
                    width: 51,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD4B896),
                      image: DecorationImage(
                        image:
                            business?.logo != null && business!.logo!.isNotEmpty
                            ? NetworkImage(business.logo!)
                            : const AssetImage('assets/images/men.png')
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          business?.ownerName ?? 'Owner',
                          style: const TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessNotificationPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: SvgPicture.asset(
                        AppIcons.notification,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2D6A4F),
                          BlendMode.srcIn,
                        ),
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards Section Background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1C5941),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                16.w,
                kToolbarHeight + 75.h,
                16.w,
                24.h,
              ),
              child: Obx(() {
                final stats = _viewModel.stats.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            iconBgColor: const Color(0xFFFF8A8A),
                            iconPath: 'assets/icons/booking.svg',
                            iconColor: AppColors.white,
                            value: stats?['totalBookings']?.toString() ?? '0',
                            label: 'Total Booking',
                            percentage:
                                '+${stats?['growth']?['totalBookings']?.toString() ?? '0'}%',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            iconBgColor: const Color(0xFFF07914),
                            iconPath: 'assets/icons/income.svg',
                            iconColor: AppColors.white,
                            value:
                                '\$${stats?['totalIncome']?.toString() ?? '0'}',
                            label: 'Total Income',
                            percentage:
                                '+${stats?['growth']?['totalIncome']?.toString() ?? '0'}%',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            iconBgColor: const Color(0xFF22C55E),
                            // Green
                            iconPath: 'assets/icons/user.svg',
                            iconColor: AppColors.white,
                            value:
                                stats?['totalEmployeesActive']?.toString() ??
                                '0',
                            label: 'Total Employee',
                            percentage:
                                '+${stats?['growth']?['totalEmployeesActive']?.toString() ?? '0'}%',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            iconBgColor: const Color(0xFFA855F7),
                            iconPath: 'assets/icons/order.svg',
                            iconColor: AppColors.white,
                            value:
                                stats?['totalActiveOrders']?.toString() ?? '0',
                            label: 'Active Orders',
                            percentage:
                                '+${stats?['growth']?['totalActiveOrders']?.toString() ?? '0'}%',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: 16.h),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Providers...',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: SvgPicture.asset(
                        'assets/icons/search-01.svg',
                        color: AppColors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // All Employee Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Employee',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => BusinessEmployeeListScreen());
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: const Color(0xFF1C5941),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => BusinessEmployeeListScreen());
                },
                child: ProviderUICard(
                  imageUrl: 'assets/images/men_cleaning.jpg',
                  profileUrl: 'assets/images/profile.png',
                  name: 'Jackson Builder',
                  location: 'Dhanmondi, Dhaka 1209',
                  postedTime: '1 day ago',
                  serviceTitle: 'Expert House Cleaning Service',
                  description:
                      'I take care of every corner, deep cleaning every room with care, leaving your home fresh and perfectly tidy for you.',
                  rating: 4.0,
                  reviewCount: 120,
                  price: '\$50',
                  showOnlineIndicator: true,
                  onViewDetails: () {
                    Get.to(() => BusinessEmployeeListScreen());
                  },
                ),
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatCard({
  required Color iconBgColor,

  required String iconPath,
  required Color iconColor,
  required String value,
  required String label,
  required String percentage,
}) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(
                iconPath,
                color: iconColor,
                width: 20.w,
                height: 20.h,
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                percentage,
                style: TextStyle(
                  color: const Color(0xFF2E7D32),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // ভ্যালু টেক্সট
        Text(
          value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4.h),
        // লেবেল টেক্সট
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}
