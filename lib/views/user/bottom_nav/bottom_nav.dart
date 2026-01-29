import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:middle_ware/views/user/profile/NotificationPage.dart';
import 'package:middle_ware/views/user/categories/CategoriesPage.dart';
import 'package:middle_ware/views/user/home/HomeScreen.dart';
import 'package:middle_ware/views/user/orders/OrderHistoryScreen.dart';
import 'package:middle_ware/views/user/profile/ProfilePage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../utils/app_icons.dart';



class UserBottomNavScreen extends StatefulWidget {
  const UserBottomNavScreen({super.key});

  @override
  State<UserBottomNavScreen> createState() => _UserBottomNavScreenState();
}

class _UserBottomNavScreenState extends State<UserBottomNavScreen> {
  int selectedIndex = 0;

  void navigationItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    CategoriesPage(),
    OrderHistoryScreen(),
    ProfilePage(),
  ];

  // Create nav items in a getter
  List<BottomNavigationBarItem> get _navItems => [
    _navItem(AppIcons.userHomeIcon, AppIcons.userHomeIconS, "Home", 0),
    _navItem(AppIcons.userCategories, AppIcons.userCategoriesS, "Categories",  1),
    _navItem(AppIcons.userOrderIcon, AppIcons.userOrderS, "Order History",  2),
    _navItem(AppIcons.userProfile, AppIcons.userProfileS, "Profile",  3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE7F4F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: const Color(0xFF000000).withOpacity(0.08),
          //     offset: const Offset(4, 0),
          //     blurRadius: 4,
          //     spreadRadius: 0,
          //   ),
          // ],
          border: const Border(
            top: BorderSide(
              color: Color(0xFFE3E6F0),
              width: 1,
            ),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.12,
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          selectedItemColor: AppColors.mainAppColor,
          selectedLabelStyle: TextStyle(
            fontFamily: 'SegeoUi_bold',
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            color: AppColors.mainAppColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'SegeoUi_bold',
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.grey,
          ),
          showSelectedLabels: true,
          unselectedItemColor: AppColors.grey,
          backgroundColor: Colors.transparent,
          onTap: navigationItemTap,
          items: _navItems,
        ),
      ),
    );
  }

  // 🎯 FIX: Simplified _navItem and added color logic for SVG
  BottomNavigationBarItem _navItem(
      String unselected,
      String selected,// Only one path needed
      String label,
      int index,
      ) {

    final bool isSelected = selectedIndex == index;
    final Color iconColor = isSelected
        ? AppColors.mainAppColor
        : AppColors.grey;

    return BottomNavigationBarItem(
      // 🎯 FIX: Removed the unnecessary Column and SizedBox(height: 10.h)
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            selectedIndex == index ? selected : unselected,
          ),
          SizedBox(height: 5.h),
        ],
      ),
      label: label,
    );
  }
}