import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';
import 'package:middle_ware/views/user/categories/widgets/custom_provider_card.dart';
import '../../../controller/user/category_controller/category_providers_list_controller.dart';

class ProvidersScreen extends StatefulWidget {
  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  final CategoryProvidersListController controller = Get.put(CategoryProvidersListController());

  @override
  void initState() {
    super.initState();
    final dynamic receivedArg = Get.arguments;
    print("ProvidersScreen received arguments: $receivedArg");
    
    final String? categoryId = receivedArg is String ? receivedArg : null;
    
    if (categoryId != null && categoryId.isNotEmpty) {
      Future.microtask(() => controller.fetchProvidersByCategory(categoryId));
    } else {
      print("ProvidersScreen: categoryId is null or empty!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor1,
      appBar: CustomAppBar(title: "Provider"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.allCategoryServices.isEmpty) {
            return const Center(child: Text("No providers found for this category"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: controller.allCategoryServices.length,
                  itemBuilder: (context, index) {
                    final item = controller.allCategoryServices[index];
                    final provider = item.provider;
                    final service = item.service;

                    return CustomProviderCard(
                      providerName: provider.name ?? 'Unknown',
                      location: provider.address ?? 'No Location',
                      activeStatus: '', // Not in this API response
                      serviceTitle: service.title ?? 'No Title',
                      serviceDescription: service.description ?? 'No Description',
                      reviews: "${service.rating?.toStringAsFixed(1) ?? '0.0'} (${service.totalReviews ?? 0})",
                      appointmentPrice: service.appointmentEnabled == true ? (service.price?.toDouble()) : null,
                      servicePrice: service.appointmentEnabled == false ? (service.price?.toDouble()) : null,
                      serviceImage: service.image,
                      providerImage: provider.profileImage,
                      serviceId: service.serviceId,
                      providerId: provider.providerId,
                      appointmentEnabled: service.appointmentEnabled,
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.060)
            ],
          );
        }),
      ),
    );
  }
}
