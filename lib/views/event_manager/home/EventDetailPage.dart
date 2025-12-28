import 'package:flutter/material.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class EventDetailPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String time;
  final String guests;
  final String price;
  final String location;

  const EventDetailPage({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.time,
    required this.guests,
    required this.price,
    required this.location,
    required String event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Event Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Earnings Summary Card
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Earnings Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem('Tickets', '500'),
                      _buildSummaryItem('Revenue', '\$900.50'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem('Tickets Sold', '100', icon: Icons.confirmation_num_outlined),
                      _buildSummaryItem('Attendees', '100', icon: Icons.people_outline),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Event Info Card
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/event_detail.png",
                      width: double.infinity,

                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text("Event Name", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const Text("Happy New Year Fest", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Event Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildIconDetail(Icons.calendar_today_outlined, "Date & Time", "August 15, 2023 at 06:00 PM - 11:00 PM"),
                  _buildIconDetail(Icons.location_on_outlined, "Location", "Central Park, New York"),
                  _buildIconDetail(Icons.confirmation_num_outlined, "Ticket Price", "\$50.00 per ticket"),
                  const SizedBox(height: 16),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text(
                    "Join us for an unforgettable night of music under the stars! Featuring top artists and bands.",
                    style: TextStyle(color: Colors.grey, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Attendees Card
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Attendees", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildAttendeeItem("Alice Jon", "alice@example.com", "2"),
                  _buildAttendeeItem("Alice Jon", "alice@example.com", "2"),
                  _buildAttendeeItem("Alice Jon", "alice@example.com", "2"),
                  _buildAttendeeItem("Alice Jon", "alice@example.com", "2"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for Section Cards
  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  // Helper for Top Summary Items
  Widget _buildSummaryItem(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) Icon(icon, size: 20, color: const Color(0xFF1C5941)),
            if (icon != null) const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  // Helper for Event Details
  Widget _buildIconDetail(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  // Helper for Attendee Rows
  Widget _buildAttendeeItem(String name, String email, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(email, style: const TextStyle(color:AppColors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.confirmation_num_outlined, size: 18, color: Color(0xFF1C5941)),
          const SizedBox(width: 8),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}