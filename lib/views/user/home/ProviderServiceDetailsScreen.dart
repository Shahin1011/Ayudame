import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../controller/user/service/service_details_controller.dart';
import '../../../models/user/service/service_details_model.dart' as model;
import '../../../core/routes/app_routes.dart';
import 'NearYouProviderProfileScreen.dart';

class ProviderServiceDetailsScreen extends StatefulWidget {
  const ProviderServiceDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProviderServiceDetailsScreen> createState() => _ProviderServiceDetailsScreenState();
}

class _ProviderServiceDetailsScreenState extends State<ProviderServiceDetailsScreen> {
  final ServiceDetailsController controller = Get.put(ServiceDetailsController());
  
  String? initialProviderId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    String? serviceId;

    if (args is Map) {
      serviceId = args['serviceId'];
      initialProviderId = args['providerId'];
    } else if (args is String) {
      serviceId = args;
    }

    if (serviceId != null) {
      Future.microtask(() => controller.fetchServiceDetails(serviceId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E4E);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: CustomAppBar(title: "Service Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryGreen));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final data = controller.serviceDetails.value;
        if (data == null) {
          return const Center(child: Text("Service details not available"));
        }

        final provider = data.provider;
        final service = data.service;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Provider Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: (provider?.image != null && provider!.image!.isNotEmpty)
                              ? NetworkImage(provider.image!)
                              : null,
                          child: (provider?.image == null || provider!.image!.isEmpty)
                              ? Icon(Icons.person, size: 30.sp, color: Colors.grey)
                              : null,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider?.name ?? "Provider Name",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 14.sp, color: Colors.grey[600]),
                                  SizedBox(width: 0.w),
                                  Expanded(
                                    child: Text(
                                      provider?.address ?? "Address not available",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton(
                          onPressed: () {
                             final providerId = provider?.id ?? service?.providerId ?? initialProviderId;
                             if (providerId != null) {
                               Get.to(() => const NearYouProviderProfileScreen(), arguments: providerId);
                             } else {
                               Get.snackbar("Error", "Provider profile ID not available");
                             }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            minimumSize: Size(0, 32.h),
                          ),
                          child: Text(
                            "View profile",
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Service Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: (service?.image != null && service!.image!.isNotEmpty)
                          ? Image.network(
                              service.image!,
                              width: double.infinity,
                              height: 170.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                            )
                          : _buildPlaceholderImage(),
                    ),
                    SizedBox(height: 20.h),

                    // Title
                    Text(
                      service?.title ?? "No Title",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // About
                    Text(
                      "About this Service",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildNumberedList(service?.about),
                    SizedBox(height: 16.h),

                    // Why Choose Us
                    Text(
                      "Why Chose Us",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (service?.whyChooseUs != null) ...[
                      _buildNumberedPoint(1, service!.whyChooseUs!.twentyFourSeven),
                      _buildNumberedPoint(2, service.whyChooseUs!.efficientAndFast),
                      _buildNumberedPoint(3, service.whyChooseUs!.affordablePrices),
                      _buildNumberedPoint(4, service.whyChooseUs!.expertTeam),
                    ],
                    SizedBox(height: 24.h),

                    // Reviews
                    Text(
                      "Top Reviews",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (service?.topReviews == null || service!.topReviews!.isEmpty)
                       Text("No reviews yet", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                    if (service?.topReviews != null)
                      ...?service?.topReviews!.map((review) => _buildReviewItem(review)).toList(),
                    
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, -4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          (service?.appointmentEnabled == true) ? "Appointment Price: " : "Service Price: ",
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        Text(
                          () {
                            if (service?.appointmentEnabled == true && service?.appointmentSlots != null && service!.appointmentSlots!.isNotEmpty) {
                              // Find lowest price from slots
                              num minPrice = service.appointmentSlots!.map((e) => e.price ?? 0).reduce((a, b) => a < b ? a : b);
                              return "\$$minPrice";
                            }
                            return "\$${service?.basePrice ?? 0}";
                          }(),
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                           final Map<String, dynamic> args = {
                             'serviceId': service?.serviceId,
                             'providerId': provider?.id,
                             'providerName': provider?.name,
                             'providerImage': provider?.image,
                             'providerAddress': provider?.address,
                             'serviceTitle': service?.title,
                             'servicePrice': service?.basePrice,
                             'availableTime': provider?.availableTime,
                                'appointmentSlots': service?.appointmentSlots?.map((e) => {
                                'id': e.id,
                                'duration': e.duration,
                                'durationUnit': e.durationUnit,
                                'price': e.price,
                              }).toList(),
                           };

                           if (service?.appointmentEnabled == true) {
                              Get.toNamed(AppRoutes.userAppointment, arguments: args);
                           } else {
                              Get.toNamed(AppRoutes.userBooking, arguments: args);
                           }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          (service?.appointmentEnabled == true) ? "Make an appointment" : "Get this service",
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 190.h,
      color: Colors.grey[200],
      child: Icon(Icons.image, size: 50.sp, color: Colors.grey),
    );
  }

  Widget _buildNumberedList(String? about) {
    if (about == null || about.isEmpty) return const SizedBox.shrink();
    
    // Split byproduct or sentences. 
    // In many cases, descriptions from APIs are just blocks. 
    // We try to split by newline or '. '
    List<String> items = about.split(RegExp(r'\n|\. ')).where((s) => s.trim().isNotEmpty).toList();
    
    if (items.isEmpty) return Text(about, style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]));

    return Column(
      children: List.generate(items.length, (index) {
         String text = items[index].trim();
         if (!text.endsWith('.') && !about.contains('\n')) text += '.';
         return _buildNumberedPoint(index + 1, text);
      }),
    );
  }

  Widget _buildNumberedPoint(int number, String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. ",
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(model.TopReview review) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: (review.user?.image != null && review.user!.image!.isNotEmpty)
                    ? NetworkImage(review.user!.image!)
                    : null,
                child: (review.user?.image == null || review.user!.image!.isEmpty)
                    ? Icon(Icons.person, size: 22.sp, color: Colors.grey)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user?.name ?? "Anonymous",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 14.sp,
                          color: index < (review.rating?.toInt() ?? 0) ? const Color(0xFFFFC107) : Colors.grey[300],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Text(
                review.createdAt ?? "", // e.g. "1 Month ago"
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.comment ?? "",
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }
}
