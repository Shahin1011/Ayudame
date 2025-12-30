import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../widgets/provider_ui_card.dart';

class BusinessEmployeeListScreen extends StatelessWidget {
  const BusinessEmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C5941),
        elevation: 0,
        title: Text(
          'Employees',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.businessEmployee);
            },
            child: ProviderUICard(
              name: 'Employee ${index + 1}',
              location: 'San Francisco Way 1318',
              serviceTitle: 'Expert House Cleaning Service',
              description:
                  'I take care of every corner, deep cleaning and scrubs without damaging your home items.',
              rating: 4.0,
              reviewCount: 102,
              price: '\$63',
              buttonText: 'View Details',
              onViewDetails: () {
                Get.toNamed(AppRoutes.businessEmployee);
              },
              imageUrl:
                  'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
              profileUrl:
                  'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100',
              postedTime: '1 day ago',
            ),
          );
        },
      ),
    );
  }
}
