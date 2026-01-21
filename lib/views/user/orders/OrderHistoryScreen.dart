import 'package:flutter/material.dart';
import 'package:middle_ware/core/routes/app_routes.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:middle_ware/views/user/orders/OrderDetailsScreen.dart';
import '../../../controller/user/orders/order_controller.dart';
import '../../../models/user/orders/order_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderController _controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(title: "Order History"),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Tabs
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTab('Appointment'),
                const SizedBox(width: 8),
                _buildTab('On going'),
                const SizedBox(width: 8),
                _buildTab('Completed'),
                const SizedBox(width: 8),
                _buildTab('Rejected'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Order List
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller.orderList.isEmpty) {
                return const Center(child: Text("No orders found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _controller.orderList.length,
                itemBuilder: (context, index) {
                  final order = _controller.orderList[index];
                  return GestureDetector(
                    onTap: () => _navigateToOrderDetails(order),
                    child: _buildAppointmentCard(order),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title) {
    return Obx(() {
      final isSelected = _controller.currentTab.value == title;
      return GestureDetector(
        onTap: () {
          _controller.changeTab(title);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2D5F4C) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF2D5F4C) : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppointmentCard(OrderModel order) {
    // Determine status display and color
    String displayStatus = order.bookingStatus ?? 'Unknown';
    Color statusColor = Colors.grey;

    if (displayStatus.toLowerCase() == 'pending') {
      statusColor = Colors.orange;
    } else if (displayStatus.toLowerCase() == 'accepted' || displayStatus.toLowerCase() == 'ongoing') {
      statusColor = const Color(0xFF2D5F4C); // Greenish
    } else if (displayStatus.toLowerCase() == 'completed') {
      statusColor = const Color(0xFF4CAF50); // Green
    } else if (displayStatus.toLowerCase() == 'cancelled' || displayStatus.toLowerCase() == 'rejected') {
      statusColor = const Color(0xFFE53935); // Red
    }

    // Capitalize first letter of status
    displayStatus = displayStatus.isNotEmpty
        ? displayStatus[0].toUpperCase() + displayStatus.substring(1)
        : displayStatus;


    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(order.provider?.user?.profilePicture ?? 'https://via.placeholder.com/150'),
              ),
              const SizedBox(width: 12),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.provider?.user?.fullName ?? 'Provider',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          // Simple date formatting, can use DateFormat from intl package properly
                          order.bookingDate?.split('T')[0] ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFFFC107),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${order.provider?.rating ?? 0.0} (${order.provider?.totalReviews ?? 0})",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.serviceSnapshot?.serviceName ?? 'Service Name',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price: \$${order.totalAmount ?? 0}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  displayStatus,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToOrderDetails(OrderModel order) {
    // Navigate to details screen, passing arguments if needed
    Get.to(() => OrderDetailsScreen(), arguments: order);
  }
}
