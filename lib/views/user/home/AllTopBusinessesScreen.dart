import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../controller/user/home/top_businesses_controller.dart';
import 'widgets/custom_top_businesses_card.dart';

class AllTopBusinessesScreen extends StatefulWidget {
  const AllTopBusinessesScreen({Key? key}) : super(key: key);

  @override
  State<AllTopBusinessesScreen> createState() => _AllTopBusinessesScreenState();
}

class _AllTopBusinessesScreenState extends State<AllTopBusinessesScreen> {
  final TopBusinessesController controller = Get.find<TopBusinessesController>();

  @override
  void initState() {
    super.initState();
    // Fetch more if needed, here we just refresh with a higher limit or keep current
    controller.fetchTopBusinesses(limit: 50); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: CustomAppBar(title: "Top Businesses"),
      body: Obx(() {
        if (controller.isLoading.value && controller.businesses.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E4E)));
        }

        if (controller.errorMessage.isNotEmpty && controller.businesses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () => controller.fetchTopBusinesses(limit: 50),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        if (controller.businesses.isEmpty) {
          return const Center(child: Text("No businesses found"));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          itemCount: controller.businesses.length,
          itemBuilder: (context, index) {
            final business = controller.businesses[index];
            return CustomTopbusinessesCard(
              title: business.businessName ?? "Business Name",
              review: (business.businessRating ?? 0.0).toStringAsFixed(1),
              location: business.businessAddress ?? "Address not available",
              numberEmployees: business.employeeCount ?? 0,
              numberOfServices: business.serviceCount ?? 0,
              businessPhoto: business.businessPhoto,
              businessOwnerId: business.businessOwnerId,
            );
          },
        );
      }),
    );
  }
}
