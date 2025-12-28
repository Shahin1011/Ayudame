import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../views/event_manager/event/CreateEventPage.dart';
import '../views/event_manager/home/EventHomeScreen.dart';
import '../views/event_manager/profile/EventProfile.dart';

class BottomNavEScreen extends StatefulWidget {
  const BottomNavEScreen({super.key});

  @override
  State<BottomNavEScreen> createState() => _BottomNavEScreenState();
}

class _BottomNavEScreenState extends State<BottomNavEScreen> {
  int selectedIndex = 0;

  void navigationItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    EventHomeScreen(),
    CreateEventPage(),
    EventProfilePage(),
  ];

  // Create nav items in a getter
  List<BottomNavigationBarItem> get _navItems => [
    _navItem(AppIcons.home, AppIcons.homes, "Home", 0),
    _navItem(AppIcons.create, AppIcons.creates, "Create Event", 1),
    _navItem(AppIcons.profile, AppIcons.profiles, "Profile", 2),
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
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.08),
              offset: const Offset(4, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFFE3E6F0), width: 1),
          ),
        ),
        height: 95.h,
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

  BottomNavigationBarItem _navItem(
    String unselected,
    String selected, // Only one path needed
    String label,
    int index,
  ) {
    final bool isSelected = selectedIndex == index;
    final Color iconColor = isSelected
        ? AppColors.mainAppColor
        : AppColors.grey;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            selectedIndex == index ? selected : unselected,
            colorFilter: ColorFilter.mode(
              selectedIndex == index ? AppColors.mainAppColor : AppColors.grey,
              BlendMode.srcIn,
            ),
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(height: 10.h),
        ],
      ),
      label: label,
    );
  }
}
