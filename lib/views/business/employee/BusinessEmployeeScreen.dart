import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  int selectedTab = 0; // 0: Overview, 1: Activities, 2: Orders

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrow_back.svg',
            color: Colors.white,
            width: 20,
            height: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Employee',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/more_vert.svg',
              color: Colors.white,
            ),
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
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(
                  'assets/images/provider_avatar.png',
                ), // Make sure path is correct
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
          const Text(
            'Seam Rahman',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Provider',
            style: TextStyle(color: AppColors.grey, fontSize: 14),
          ),
          const Text(
            'Exper House Cleaning Service',
            style: TextStyle(color: AppColors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleIcon('assets/icons/call.svg'),
              const SizedBox(width: 20),
              _circleIcon('assets/icons/chat.svg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(String iconPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.mainAppColor,
        border: Border.all(color: Colors.white24),
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
          color: isSelected ? const Color(0xFF1C5941) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1C5941) : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
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
              'assets/icons/calendar.svg',
              "Total Jobs",
              "1,247",
              const Color(0xFFFFEAEA),
              Colors.red,
            ),
            _statTile(
              'assets/icons/star.svg',
              "Rating",
              "4.9",
              const Color(0xFFFFEAEA),
              Colors.red,
            ),
            _statTile(
              'assets/icons/wallet.svg',
              "Earnings",
              "\$ 12,222",
              const Color(0xFFFFEAEA),
              Colors.red,
            ),
            _statTile(
              'assets/icons/person_add.svg',
              "Joined",
              "Jan 15, 2024",
              const Color(0xFFFFEAEA),
              Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 25),
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
        _scheduleCard("Home Cleaning", "Arif hasan", "Tomorrow, 2:00 pm"),
        const SizedBox(height: 25),
        const Text(
          "Contract Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        _contractItem('assets/icons/phone.svg', "Phone", "+1 235455 5255 44"),
        _contractItem('assets/icons/email.svg', "Email", "Siamrrr85@gmail.com"),
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
                  width: 14,
                  height: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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
        border: Border.all(color: Colors.grey.shade100),
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
              'assets/icons/cleaning_service.svg',
              color: Colors.green,
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
              fontSize: 11,
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
            color: Colors.green,
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
            const Divider(height: 25),
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

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
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
            const SizedBox(height: 10),
            ListTile(
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
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/remove_person.svg',
                color: Colors.red,
              ),
              title: const Text(
                "Remove Employee",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
