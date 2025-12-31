import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  String selectedTimeFilter = 'Today';
  String selectedCategoryFilter = 'All';

  final List<String> timeFilters = ['Today', 'This Week', 'This Month'];
  final List<String> categoryFilters = [
    'All',
    'Bookings',
    'Completed',
    'Cancelled',
  ];

  late List<ActivityItem> allActivities;

  @override
  void initState() {
    super.initState();
    allActivities = [
      ActivityItem(
        type: 'Order completed',
        category: 'Completed',
        name: 'Seam Rahman',
        orderId: '#1565',
        amount: '\$150',
        time: '5 hours ago',
        isPositive: true,
        avatar: 'assets/images/profile.png',
      ),
      ActivityItem(
        type: 'New booking received',
        category: 'Bookings',
        name: 'Seam Rahman',
        orderId: '#1565',
        amount: '\$150',
        time: '5 hours ago',
        isPositive: true,
        avatar: 'assets/images/profile.png',
      ),
      ActivityItem(
        type: 'Payment received',
        category: 'Completed',
        name: 'Seam Rahman',
        orderId: '#1565',
        amount: '\$150',
        time: '5 hours ago',
        isPositive: true,
        avatar: 'assets/images/profile.png',
      ),
      ActivityItem(
        type: 'Order cancelled',
        category: 'Cancelled',
        name: 'Seam Rahman',
        orderId: '#1565',
        amount: '\$150',
        time: '5 hours ago',
        isPositive: false,
        avatar: 'assets/images/profile.png',
      ),
      ActivityItem(
        type: 'New booking received',
        category: 'Bookings',
        name: 'Seam Rahman',
        orderId: '#1565',
        amount: '\$150',
        time: '5 hours ago',
        isPositive: true,
        avatar: 'assets/images/profile.png',
      ),
      ActivityItem(
        type: 'Order completed',
        category: 'Completed',
        name: 'Seam Rahman',
        orderId: '#1566',
        amount: '\$200',
        time: '3 hours ago',
        isPositive: true,
        avatar: 'assets/images/profile.png',
      ),
      ActivityItem(
        type: 'Order cancelled',
        category: 'Cancelled',
        name: 'Seam Rahman',
        orderId: '#1567',
        amount: '\$100',
        time: '2 hours ago',
        isPositive: false,
        avatar: 'assets/images/profile.png',
      ),
    ];
  }

  List<ActivityItem> get filteredActivities {
    List<ActivityItem> filtered = allActivities;

    if (selectedCategoryFilter != 'All') {
      filtered = filtered
          .where((item) => item.category == selectedCategoryFilter)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: "Activities", showBackButton: false,),
      body: Column(
        children: [
          // Time Filter Tabs
          _buildTimeFilterTabs(),

          // Category Filter Chips
          _buildCategoryFilterChips(),

          // Activities List
          Expanded(
            child: filteredActivities.isEmpty
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
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      return _buildActivityCard(filteredActivities[index]);
                    },
                  ),
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
                      : Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
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
                    : Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
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
            backgroundImage: AssetImage(activity.avatar),
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

  ActivityItem({
    required this.type,
    required this.category,
    required this.name,
    required this.orderId,
    required this.amount,
    required this.time,
    required this.isPositive,
    required this.avatar,
  });
}
