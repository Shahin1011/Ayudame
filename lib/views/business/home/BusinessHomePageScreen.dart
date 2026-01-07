import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/business/employee/all_employee.dart';
import 'package:middle_ware/views/business/home/provider.dart';
import 'package:middle_ware/views/business/profile/BusinessProfile.dart';
import '../../../core/app_icons.dart';
import '../../../core/routes/app_routes.dart';
import '../Activities/ActivitiesPage.dart';
import 'BusinessNotificationPage.dart';
import '../../../widgets/provider_ui_card.dart';

class BusinessHomePageScreen extends StatefulWidget {
  const BusinessHomePageScreen({super.key});

  @override
  State<BusinessHomePageScreen> createState() => _BusinessHomePageScreenState();
}

class _BusinessHomePageScreenState extends State<BusinessHomePageScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const BusinessEmployeeListScreen(), //EmployeeDetailsScreen
    const ActivitiesPage(),
    const Businessprofile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1C5941),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home_nav.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/homes.svg',
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/employee.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/employees.svg',
              width: 24,
              height: 24,
            ),
            label: 'Employee',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/activity.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/activitys.svg',
              width: 28,
              height: 28,
            ),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profileIconn.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/profilesIcon.svg',
              width: 24,
              height: 24,
              color: const Color(0xFF1C5941),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home Content Widget
class _HomeContent extends StatelessWidget {
  const _HomeContent();

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
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFD4B896),
                  backgroundImage: AssetImage('assets/images/men.png'),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Seam Rahman',
                        style: TextStyle(
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
                        builder: (context) =>  BusinessNotificationPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      AppIcons.notification,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF2D6A4F),
                        BlendMode.srcIn,
                      ),
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),

              ],
            ),
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
                kToolbarHeight + 80.h,
                16.w,
                24.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          color: const Color(0xFFFFE5E5),
                          iconPath: 'assets/icons/booking.svg',
                          iconColor: const Color(0xFFFF6B6B),
                          value: '1,237',
                          label: 'Total Booking',
                          percentage: '+8%',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildStatCard(
                          color: const Color(0xFFFFE8D6),
                          iconPath: 'assets/icons/income.svg',
                          iconColor: const Color(0xFFFF9F43),
                          value: '\$50,500',
                          label: 'Total Income',
                          percentage: '+8%',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          color: const Color(0xFFE8F5E9),
                          iconPath: 'assets/icons/user.svg',
                          iconColor: const Color(0xFF4CAF50),
                          value: '786',
                          label: 'Active Users',
                          percentage: '+8%',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildStatCard(
                          color: AppColors.eventBackground,
                          iconPath: 'assets/icons/order.svg',
                          iconColor: const Color(0xFF9C27B0),
                          value: '850',
                          label: 'Active Orders',
                          percentage: '+2%',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
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
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
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

            // All Providers Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Providers',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => BusinessProvidersScreen());
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

            // Provider Card 1

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GestureDetector(

                onTap: () {
                  Get.to(() => BusinessProvidersScreen());
                },

                child: ProviderUICard(

                  imageUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
                  profileUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100',
                  name: 'Jackson Builder',
                  location: 'Dhanmondi Dhaka 1209',
                  postedTime: '1 day ago',
                  serviceTitle: 'Expert House Cleaning Service',
                  description: 'I take care of every corner, deep cleaning every room with care...',
                  rating: 4.0,
                  reviewCount: 120,
                  price: 'Appointment Price: \$100',
                  showOnlineIndicator: true,
                  onViewDetails: () {
                    Get.to(() => BusinessProvidersScreen());
                  },

                ),
              ),
            ),

            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.businessEmployee);
                },
                child: ProviderUICard(
                  imageUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
                  profileUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100',
                  name: 'Jackson Builder',
                  location: 'Dhanmondi Dhaka 1209',
                  postedTime: '1 day ago',
                  serviceTitle: 'House Cleaning',
                  description: 'I take care of every corner, deep cleaning every room with care.',
                  rating: 4.0,
                  reviewCount: 120,
                  price: 'Appointment Price: \$100',
                  showOnlineIndicator: true,
                  onViewDetails: () {
                    Get.to(() => const BusinessEmployeeListScreen());
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

  Widget _buildStatCard({
    required Color color,
    required String iconPath,
    required Color iconColor,
    required String value,
    required String label,
    required String percentage,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: SvgPicture.asset(
                  iconPath,
                  color: iconColor,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
