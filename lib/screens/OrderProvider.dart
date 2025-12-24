import 'package:flutter/material.dart';

class OrderHistoryProviderScreen extends StatefulWidget {
  const OrderHistoryProviderScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryProviderScreen> createState() => _OrderHistoryProviderScreenState();
}

class _OrderHistoryProviderScreenState extends State<OrderHistoryProviderScreen> {
  int _selectedTab = 0;
  int _selectedIndex = 2; // For bottom navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different routes based on index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/provider/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/provider/create');
        break;
      case 2:
        Navigator.pushNamed(context, '/provider/order');
        break;
      case 3:
        Navigator.pushNamed(context, '/provider/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C5F4F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Order history',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Filter tabs - now scrollable
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('Appointment', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('Accepted', 1),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cancelled', 2),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', 3),
                ],
              ),
            ),
          ),
          // Order list
          Expanded(
            child: _selectedTab == 0
                ? _buildAppointmentTab()
                : _selectedTab == 1
                ? _buildAcceptedTab()
                : _selectedTab == 2
                ? _buildCancelledTab()
                : _selectedTab == 3
                ? _buildPendingTab()
                : _buildEmptyTab(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2D6A4F),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 24),
              label: 'Create service',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined, size: 24),
              label: 'Order history',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C5F4F) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildAppointmentCard(context),
        const SizedBox(height: 16),
        _buildAppointmentCard(context),
        const SizedBox(height: 16),
        _buildAppointmentCard(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAcceptedTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildAcceptedCard(context, price: 500, isOngoing: false),
        const SizedBox(height: 16),
        _buildAcceptedCard(context, price: 1000, downPayment: 2, isOngoing: true),
        const SizedBox(height: 16),
        _buildAcceptedCard(context, price: 50, isOngoing: false),
        const SizedBox(height: 16),
        _buildAcceptedCard(context, price: 1000, downPayment: 200, isOngoing: true),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCancelledTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildCancelledCard(context),
        const SizedBox(height: 16),
        _buildCancelledCard(context),
        const SizedBox(height: 16),
        _buildCancelledCard(context),
        const SizedBox(height: 16),
        _buildCancelledCard(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPendingTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildPendingCard(context, totalPrice: 1200, downPayment: 200),
        const SizedBox(height: 16),
        _buildPendingCard(context, totalPrice: 1000, downPayment: 200),
        const SizedBox(height: 16),
        _buildPendingCard(context, totalPrice: 450, downPayment: 90),
        const SizedBox(height: 16),
        _buildPendingCard(context, totalPrice: 800, downPayment: 160),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmptyTab() {
    return const Center(
      child: Text('No orders found'),
    );
  }

  Widget _buildAppointmentCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile and time
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage: const AssetImage('assets/images/men.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seam Rahman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '(448 reviews)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Text(
                '12:25 pm',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Address
          const Text(
            'Address: 123 Oak Street Spring,ILB 64558',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Date
          const Text(
            'Date: 29 October, 2025',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Problem note
          const Text(
            'Problem Note:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const Text(
            'Please ensure all windows are securely locked after cleaning.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // Price
          const Text(
            'Price: \$120',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2C5F4F)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Reschedule',
                    style: TextStyle(color: Color(0xFF2C5F4F)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5F4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Cancel button
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedCard(BuildContext context,
      {required int price, int? downPayment, required bool isOngoing}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile and time
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seam Rahman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '(448 reviews)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Text(
                '12:25 pm',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Address
          const Text(
            'Address: 123 Oak Street Spring,ILB 64558',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Date
          const Text(
            'Date: 29 October, 2025',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Problem note
          const Text(
            'Problem Note:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const Text(
            'Please ensure all windows are securely locked after cleaning.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // Price or Total Price
          if (downPayment != null) ...[
            Text(
              'Total Price: \$$price',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Down payment: \$$downPayment',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white, size: 14),
                ),
              ],
            ),
          ] else
            Text(
              'Price: \$$price',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 16),
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C5F4F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                isOngoing ? 'On Going' : 'Accepted appointment',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile and time
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seam Rahman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.6',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '(448 reviews)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Text(
                '12:25 pm',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Address
          const Text(
            'Address: 123 Oak Street Spring,ILB 64558',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Date
          const Text(
            'Date: 29 October, 2025',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Problem note
          const Text(
            'Problem Note:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const Text(
            'Please ensure all windows are securely locked after cleaning.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // Price
          const Text(
            'Price: \$120',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Cancelled button
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Cancelled',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(BuildContext context,
      {required int totalPrice, required int downPayment}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile and time
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seam Rahman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.6',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '(448 reviews)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Text(
                '12:25 pm',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Address
          const Text(
            'Address: 123 Oak Street Spring,ILB 64558',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Date
          const Text(
            'Date: 29 October, 2025',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Problem note
          const Text(
            'Problem Note:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const Text(
            'Please ensure all windows are securely locked after cleaning.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // Price information
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price: \$$totalPrice',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Down payment: \$$downPayment',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5F4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
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