import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String _selectedTab = 'Appointment';

  final List<Map<String, dynamic>> _appointmentOrders = [
    {
      'name': 'Tamim',
      'rating': '3.8(1,200)',
      'service': 'Expert House Cleaning Services',
      'price': '\$100',
      'date': '01/09/2025',
      'status': 'On going',
      'statusType': 'ongoing',
      'statusColor': Color(0xFF2D5F4C),
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    },
    {
      'name': 'Robil Rahaman',
      'rating': '4.2(1,200)',
      'service': 'Expert House Cleaning Services',
      'price': '\$100',
      'date': '01/09/2025',
      'status': 'Pending',
      'statusType': 'pending',
      'statusColor': Color(0xFFFF9800),
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    },
    {
      'name': 'Tamim',
      'rating': '3.8(1,200)',
      'service': 'Expert House Cleaning Services',
      'price': '\$100',
      'date': '01/09/2025',
      'status': 'Cancelled',
      'statusType': 'cancelled',
      'statusColor': Color(0xFFE53935),
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    },
    {
      'name': 'Sarah Johnson',
      'rating': '4.5(800)',
      'service': 'Home Deep Cleaning',
      'price': '\$150',
      'date': '02/09/2025',
      'status': 'Reschedule',
      'statusType': 'reschedule',
      'statusColor': Color(0xFF2196F3),
      'image': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=200',
    },
  ];

  final List<Map<String, dynamic>> _ongoingOrders = [
    {
      'name': 'Tamim',
      'rating': '3.8(1,200)',
      'service': 'Expert House Cleaning Services',
      'price': '\$100',
      'date': '01/09/2025',
      'status': 'On going',
      'statusType': 'ongoing',
      'statusColor': Color(0xFF2D5F4C),
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    },
    {
      'name': 'Robil Rahaman',
      'rating': '4.2(1,200)',
      'service': 'Expert House Cleaning Services',
      'price': '\$100',
      'date': '01/09/2025',
      'status': 'On going',
      'statusType': 'ongoing',
      'statusColor': Color(0xFF2D5F4C),
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    },
  ];

  final List<Map<String, dynamic>> _completedOrders = [
    {
      'name': 'Tamim',
      'rating': '3.8(1,200)',
      'service': 'Expert House Cleaning Services',
      'price': '\$100',
      'date': '01/09/2025',
      'status': 'Completed',
      'statusType': 'completed',
      'statusColor': Color(0xFF4CAF50),
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    },
    {
      'name': 'Tamin Sarkar',
      'rating': '4.8(1,200)',
      'service': 'Expert House Cleaning Services',
      'price': '\$100',
      'date': '07/08/2025',
      'status': 'Completed',
      'statusType': 'completed',
      'statusColor': Color(0xFF4CAF50),
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    },
  ];

  final List<Map<String, dynamic>> _rejectedOrders = [
    {
      'name': 'Tamim',
      'rating': '3.8(1,200)',
      'service': 'Expert House Cleaning Services',
      'price': '\$100',
      'date': '01/09/2025',
      'status': 'Cancelled',
      'statusType': 'cancelled',
      'statusColor': Color(0xFFE53935),
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    },
    {
      'name': 'John Doe',
      'rating': '4.5(1,100)',
      'service': 'Pet Care Services',
      'price': '\$80',
      'date': '06/08/2025',
      'status': 'Cancelled',
      'statusType': 'cancelled',
      'statusColor': Color(0xFFE53935),
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    },
  ];

  void _navigateToOrderDetails(Map<String, dynamic> order) {
    final statusType = order['statusType'];

    switch (statusType) {
      case 'ongoing':
        Navigator.pushNamed(context, '/order/details');
        break;
      case 'pending':
        Navigator.pushNamed(context, '/order/details');
        break;
      case 'cancelled':
        Navigator.pushNamed(context, '/order/details');
        break;
      case 'completed':
        Navigator.pushNamed(context, '/order/details');
        break;
      case 'reschedule':
        Navigator.pushNamed(context, '/order/details');
        break;
      default:
        Navigator.pushNamed(context, '/order/details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2D5F4C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    ),
                    const Expanded(
                      child: Text(
                        'Order history',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getOrdersByTab().length,
              itemBuilder: (context, index) {
                final order = _getOrdersByTab()[index];
                return GestureDetector(
                  onTap: () => _navigateToOrderDetails(order),
                  child: _buildAppointmentCard(order),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getOrdersByTab() {
    switch (_selectedTab) {
      case 'Appointment':
        return _appointmentOrders;
      case 'On going':
        return _ongoingOrders;
      case 'Completed':
        return _completedOrders;
      case 'Rejected':
        return _rejectedOrders;
      default:
        return _appointmentOrders;
    }
  }

  Widget _buildTab(String title) {
    final isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
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
  }

  Widget _buildAppointmentCard(Map<String, dynamic> order) {
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
                backgroundImage: NetworkImage(order['image']),
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
                          order['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          order['date'],
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
                          order['rating'],
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
            order['service'],
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
                'Appointment Price: ${order['price']}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: order['statusColor'],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order['status'],
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
}