import 'package:flutter/material.dart';

class PaymentHistoryDetailPage extends StatelessWidget {
  const PaymentHistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D6A4F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Payment History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Section
            Column(
              children: [
                // Profile Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 38,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/45.jpg',
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Seam Rahman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Details Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    'Category:',
                    'Expert house cleaning service',
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow(
                    'Total price:',
                    '\$500',
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow(
                    'Down Payment:',
                    '\$150',
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow(
                    'A/C:',
                    '2050**********5154',
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow(
                    'Date:',
                    '01/09/2025',
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow(
                    'Time:',
                    '12:25 PM',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Complete',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2D6A4F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}