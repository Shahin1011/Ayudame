import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:middle_ware/views/business/employee/create_employee.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/business_employee_model.dart';
import '../../../viewmodels/business_employee_viewmodel.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  int selectedTab = 0; // 0: Overview, 1: Activities, 2: Orders
  late BusinessEmployeeModel employee;
  final BusinessEmployeeViewModel _viewModel =
      Get.find<BusinessEmployeeViewModel>();

  @override
  void initState() {
    super.initState();
    // Expect employee object passed via arguments
    if (Get.arguments is BusinessEmployeeModel) {
      employee = Get.arguments as BusinessEmployeeModel;
    } else {
      // Fallback
      employee = BusinessEmployeeModel(name: "Unknown");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: "Employee",
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showActionSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildTabSwitcher(),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: AppColors.bgColor,
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage:
                    employee.profileImage != null &&
                        employee.profileImage!.isNotEmpty
                    ? (employee.profileImage!.startsWith('http')
                          ? NetworkImage(employee.profileImage!)
                          : AssetImage(employee.profileImage!) as ImageProvider)
                    : const AssetImage('assets/images/provider_avatar.png'),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1C5941),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            employee.name ?? 'No Name',
            style: const TextStyle(
              color: AppColors.dark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            employee.headline ?? employee.serviceCategory ?? 'No Category',
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              // Outer border matching the dark green theme
              border: Border.all(color: const Color(0xFF1B5E44), width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Shrinks to fit content
              children: [
                const Text(
                  'Call now',
                  style: TextStyle(
                    color: Color(0xFF1B5E44),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                  ),
                ),
                const SizedBox(width: 12),
                // Icon container with solid background
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E44),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons
                        .phone_outlined, // Use SvgPicture.asset if using your svg file
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(String iconPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.mainAppColor,
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SvgPicture.asset(
        iconPath,
        color: Colors.white,
        width: 18,
        height: 18,
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tabButton("Overview", 0),
          _tabButton("Activities", 1),
          _tabButton("Orders", 2),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainAppColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1C5941)
                : AppColors.mainAppColor,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "Inter",
              color: isSelected ? AppColors.white : AppColors.mainAppColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildActivities();
      case 2:
        return _buildOrders();
      default:
        return Container();
    }
  }

  Widget _buildOverview() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.0,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          children: [
            _statTile(
              'assets/icons/job.svg',
              "Total Jobs",
              "1,247",
              const Color(0xFFCC75D4),
              Colors.white,
            ),
            _statTile(
              'assets/icons/rating.svg',
              "Rating",
              "4.9",
              const Color(0xFFFF9F19),
              Colors.white,
            ),
            _statTile(
              'assets/icons/income.svg',
              "Earnings",
              "\$ 12,222",
              const Color(0xFF70CA88),
              Colors.white,
            ),
            _statTile(
              'assets/icons/join.svg',
              "Joined",
              "Jan 15, 2024",
              const Color(0xFF3C94DB),
              Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upcoming Schedules",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              _scheduleCard("Home Cleaning", "Arif hasan", "Today, 2:00 pm"),
              Divider(height: 1),
              _scheduleCard("Home Cleaning", "Arif hasan", "Tomorrow, 2:00 pm"),
              Divider(height: 1),
              _scheduleCard("Home Cleaning", "Arif hasan", "Today, 2:00 pm"),
            ],
          ),
        ),

        SizedBox(height: 25),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contract Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              _contractItem(
                'assets/icons/phone.svg',
                "Phone",
                employee.phone ?? "N/A",
              ),
              _contractItem(
                'assets/icons/email.svg',
                "Email",
                employee.email ?? "N/A",
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _statTile(
    String iconPath,
    String label,
    String value,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SvgPicture.asset(
                  iconPath,
                  color: iconColor,
                  width: 17,
                  height: 15,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _scheduleCard(String title, String name, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              'assets/icons/clean.svg',
              color: AppColors.mainAppColor,
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contractItem(String iconPath, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            color: AppColors.mainAppColor,
            width: 22,
            height: 22,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // <----------- Activities Section --------->

  Widget _buildActivities() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: index == 3
                  ? Colors.red.shade50
                  : Colors.green.shade50,
              child: SvgPicture.asset(
                index == 3
                    ? 'assets/icons/cancel.svg'
                    : 'assets/icons/check.svg',
                width: 18,
                height: 18,
                color: index == 3 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index == 3 ? "Job #1247 Canceled" : "Completed Job #1247",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    "2 hours ago",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Text(
              "#1247",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // <----------- order Section --------->

  Widget _buildOrders() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "#1248",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  index == 0
                      ? "In Progress"
                      : index == 3
                      ? "Canceled"
                      : "Completed",
                  style: TextStyle(
                    color: index == 0
                        ? Colors.blue
                        : index == 3
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Seam Rahman",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Expert Home Cleaning Service",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const Text(
                  "\$120",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // <----------- showActionSheet --------->

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: SvgPicture.asset('assets/icons/eddit.svg'),
                title: const Text(
                  "Edit Employee",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Get.to(() => CreateEmployee(employee: employee));
                },
              ),
            ),

            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/block.svg',
                  color: Colors.black87,
                ),
                title: const Text(
                  "Block Employee",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 54,
              decoration: BoxDecoration(
                color: Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/remove.svg',
                  color: Colors.red,
                ),
                title: const Text(
                  "Remove Employee",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (employee.id != null) {
                    _viewModel.deleteEmployee(employee.id!);
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
