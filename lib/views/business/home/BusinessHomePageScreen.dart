import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/business/profile/BusinessProfile.dart';
import '../../../core/routes/app_routes.dart';
import '../Activities/ActivitiesPage.dart';
import 'BusinessNotificationPage.dart';

class BusinessHomePageScreen extends StatefulWidget {
  const BusinessHomePageScreen({super.key});

  @override
  State<BusinessHomePageScreen> createState() => _BusinessHomePageScreenState();
}

class _BusinessHomePageScreenState extends State<BusinessHomePageScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const BusinessEmployeeListScreen(),
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
              'assets/icons/homes.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/homes.svg',
              width: 24,
              height: 24,
              color: const Color(0xFF1C5941),
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
              'assets/icons/employee.svg',
              width: 24,
              height: 24,
              color: const Color(0xFF1C5941),
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
              'assets/icons/activity.svg',
              width: 24,
              height: 24,
              color: const Color(0xFF1C5941),
            ),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Profiles.svg',
              width: 24,
              height: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/Profiles.svg',
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
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        elevation: 0,
        toolbarHeight: 90.h,
        leadingWidth: 80.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w, top: 10.h, bottom: 10.h),
          child: const CircleAvatar(
            radius: 40.0,
            backgroundColor: Color(0xFFFFFFFF),
            child: CircleAvatar(
              radius: 36.0,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Seam Rahman',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BusinessNotificationPage(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  'assets/icons/notificationIcon.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
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
                kToolbarHeight + 90.h,
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
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Providers...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: SvgPicture.asset(
                        'assets/icons/search-01.svg',
                        color: Colors.grey[400],
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
                      Get.toNamed(AppRoutes.userProviders);
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
            _buildProviderCard(
              name: 'Jackson Butler',
              location: 'San Francisco Way 1318',
              title: 'Expert House Cleaning Service',
              description:
                  'I take care of every corner, deep cleaning and scrubs without damaging your home items.',
              rating: '4.00',
              reviews: '102',
              price: '\$63',
              buttonText: 'Add an Employee',
              buttonColor: const Color(0xFF1C5941),
              onTap: () {},
            ),

            SizedBox(height: 16.h),

            // My Employees Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Employees',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.businessEmployee);
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

            // Provider Card 2
            _buildProviderCard(
              name: 'Jackson Butler',
              location: 'San Francisco Way 1318',
              title: 'Expert House Cleaning Service',
              description:
                  'I take care of every corner, deep cleaning and scrubs without damaging your home items.',
              rating: '4.00',
              reviews: '102',
              price: '\$63',
              buttonText: 'View Details',
              buttonColor: const Color(0xFF1C5941),
              onTap: () {
                Get.toNamed(AppRoutes.businessEmployee);
              },
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

  Widget _buildProviderCard({
    required String name,
    required String location,
    required String title,
    required String description,
    required String rating,
    required String reviews,
    required String price,
    required String buttonText,
    required Color buttonColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: Image.asset(
              'assets/images/provider_service.jpg',
              width: double.infinity,
              height: 150.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 150.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 50.w, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundImage: const AssetImage(
                        'assets/images/provider_avatar.png',
                      ),
                      backgroundColor: Colors.grey[300],
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12.sp,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                location,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ...List.generate(
                          4,
                          (index) => SvgPicture.asset(
                            'assets/icons/star.svg',
                            width: 14.w,
                            height: 14.h,
                            color: const Color(0xFFFFC107),
                          ),
                        ),
                        Icon(
                          Icons.star_border,
                          size: 14.sp,
                          color: const Color(0xFFFFC107),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '$rating ($reviews)',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Approximate Price: $price',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onTap ?? () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Business Employee List Screen Widget
class BusinessEmployeeListScreen extends StatelessWidget {
  const BusinessEmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C5941),
        elevation: 0,
        title: Text(
          'Employees',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.businessEmployee);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: const AssetImage(
                      'assets/images/provider_avatar.png',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Employee ${index + 1}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Expert House Cleaning Service',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            ...List.generate(
                              4,
                              (i) => SvgPicture.asset(
                                'assets/icons/star.svg',
                                width: 14.w,
                                height: 14.h,
                                color: const Color(0xFFFFC107),
                              ),
                            ),
                            Icon(
                              Icons.star_border,
                              size: 14.sp,
                              color: const Color(0xFFFFC107),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '4.0 (102)',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
