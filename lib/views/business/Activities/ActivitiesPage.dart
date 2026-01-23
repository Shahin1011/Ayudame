import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../viewmodels/business_auth_viewmodel.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final BusinessAuthViewModel _viewModel = Get.find<BusinessAuthViewModel>();
  String selectedTimeFilter = 'Today';
  String selectedCategoryFilter = 'All';

  final List<String> timeFilters = ['Today', 'This Week', 'This Month'];
  final List<String> categoryFilters = [
    'All',
    'Bookings',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.getActivities();
    });
  }

  // Activity mapping helper
  List<ActivityItem> get _mappedActivities {
    final activitiesData = _viewModel.activities.value ?? [];
    return activitiesData.map((data) {
      final type = data['type']?.toString().toLowerCase() ?? '';
      final status = data['status']?.toString().toLowerCase() ?? '';
      final userName = data['userName']?.toString() ?? 'Unknown';
      final orderId = data['orderId']?.toString() ?? ''; // Full ID for now
      final price = data['price']?.toString() ?? '0';
      final title = data['title']?.toString() ?? 'Service';
      final hoursAgo = data['hoursAgo']?.toString() ?? '0';
      final profilePic = data['userProfilePicture']?.toString() ?? '';

      // Determine category for filtering
      String category = 'All';
      if (type == 'booking') category = 'Bookings';
      if (status == 'completed') category = 'Completed';
      if (status == 'cancelled' || status == 'canceled') category = 'Cancelled';

      // Determine display type string
      String displayType = title;
      if (status == 'cancelled')
        displayType = 'Order cancelled';
      else if (type == 'booking')
        displayType = 'New booking received';
      else if (status == 'completed')
        displayType = 'Order completed';

      // Positive/Negative indicator
      bool isPositive = status != 'cancelled';

      return ActivityItem(
        type: displayType,
        category: category,
        name: userName,
        orderId: orderId.length > 6
            ? "#${orderId.substring(0, 5)}"
            : "#$orderId",
        amount: '\$$price',
        time: '$hoursAgo hours ago',
        isPositive: isPositive,
        avatar: profilePic.isNotEmpty
            ? profilePic
            : 'assets/images/profile.png',
        isNetworkImage: profilePic.isNotEmpty,
      );
    }).toList();
  }

  List<ActivityItem> get filteredActivities {
    List<ActivityItem> filtered = _mappedActivities;

    // Filter by Category
    if (selectedCategoryFilter != 'All') {
      filtered = filtered
          .where((item) => item.category == selectedCategoryFilter)
          .toList();
    }

    // Time filter logic would go here if API supported date filtering or we parsed dates
    // For now, API doesn't seem to return date in a filter-friendly way easily without parsing updatedAt
    // We'll keep time filter UI but it won't filter data strictly yet unless we implement date parsing logic.

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Activities", showBackButton: false),
      body: Column(
        children: [
          // Time Filter Tabs
          _buildTimeFilterTabs(),

          // Category Filter Chips
          _buildCategoryFilterChips(),

          // Activities List
          Expanded(
            child: Obx(() {
              if (_viewModel.activities.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final activities = filteredActivities;

              return activities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/inbox.svg',
                            width: 60,
                            height: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No activities found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        return _buildActivityCard(activities[index]);
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(title: 'Activities');
  }

  Widget _buildTimeFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: timeFilters.map((filter) {
          bool isSelected = selectedTimeFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTimeFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1C5941) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? null
                      : Border.all(color: AppColors.mainAppColor, width: 1),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.mainAppColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: categoryFilters.map((category) {
          bool isSelected = selectedCategoryFilter == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryFilter = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1C5941) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.mainAppColor, width: 1),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.mainAppColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityCard(ActivityItem activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: activity.isNetworkImage
                ? NetworkImage(activity.avatar)
                : AssetImage(activity.avatar) as ImageProvider,
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 12),

          // Activity Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.type,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: activity.isPositive
                            ? Colors.black87
                            : const Color(0xFFFF6B6B),
                      ),
                    ),
                    Text(
                      activity.amount,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      activity.name,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      activity.orderId,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  activity.time,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String type;
  final String category;
  final String name;
  final String orderId;
  final String amount;
  final String time;
  final bool isPositive;
  final String avatar;
  final bool isNetworkImage;

  ActivityItem({
    required this.type,
    required this.category,
    required this.name,
    required this.orderId,
    required this.amount,
    required this.time,
    required this.isPositive,
    required this.avatar,
    this.isNetworkImage = false,
  });
}
