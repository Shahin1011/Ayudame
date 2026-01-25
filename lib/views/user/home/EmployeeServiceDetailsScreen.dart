import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../controller/user/home/employee_service_details_controller.dart';
import '../../../models/user/home/employee_profile_model.dart';
import '../../../models/user/home/provider_profile_model.dart';
import '../../../core/routes/app_routes.dart';
import 'NearYouProviderProfileScreen.dart';

class EmployeeServiceDetailsScreen extends StatefulWidget {
  const EmployeeServiceDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeServiceDetailsScreen> createState() => _EmployeeServiceDetailsScreenState();
}

class _EmployeeServiceDetailsScreenState extends State<EmployeeServiceDetailsScreen> {
  final EmployeeServiceDetailsController controller = Get.put(EmployeeServiceDetailsController());
  
  String? employeeId;
  String? serviceId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      serviceId = args['serviceId'];
      employeeId = args['providerId']; // We pass employeeId as providerId in custom card
    }

    if (employeeId != null) {
      Future.microtask(() => controller.fetchEmployeeProfile(employeeId!));
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

        final profile = controller.employeeProfile.value;
        if (profile == null) {
          return const Center(child: Text("Employee details not available"));
        }

        // Find the specific service from the list
        ProfileService? service;
        if (serviceId != null && profile.allServices?.services != null) {
          service = profile.allServices!.services!.firstWhereOrNull(
            (s) => s.serviceId == serviceId
          );
        }
        
        // Fallback to first service if not found (or if serviceId was nul)
        service ??= profile.allServices?.services?.firstOrNull;

        if (service == null) {
          return const Center(child: Text("Service details not found"));
        }

        final provider = profile.provider;

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
                                provider?.name ?? "Employee Name",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 14.sp, color: Colors.grey[600]),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      provider?.address ?? "Address not available",
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
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
                        // ElevatedButton(
                        //   onPressed: () {
                        //      if (employeeId != null) {
                        //        Get.to(() => const NearYouProviderProfileScreen(), arguments: employeeId);
                        //      }
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: primaryGreen,
                        //     foregroundColor: Colors.white,
                        //     elevation: 0,
                        //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(6.r),
                        //     ),
                        //     minimumSize: Size(0, 32.h),
                        //   ),
                        //   child: Text(
                        //     "View profile",
                        //     style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Service Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: (service.image != null && service.image!.isNotEmpty)
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
                      service.title ?? "No Title",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // About
                    Text(
                      "About this Service",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildNumberedList(service.about),
                    SizedBox(height: 16.h),

                    // Why Choose Us
                    Text(
                      "Why Chose Us",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (service.whyChooseUs != null) ...[
                      _buildNumberedPoint(1, service.whyChooseUs!.twentyFourSeven),
                      _buildNumberedPoint(2, service.whyChooseUs!.efficientAndFast),
                      _buildNumberedPoint(3, service.whyChooseUs!.affordablePrices),
                      _buildNumberedPoint(4, service.whyChooseUs!.expertTeam),
                    ] else ...[
                      // If the API returns null, we show these default professional points
                      _buildNumberedPoint(1, "Comprehensive 24/7 service coverage"),
                      _buildNumberedPoint(2, "Efficiency and speed in every task"),
                      _buildNumberedPoint(3, "Highly affordable and competitive prices"),
                      _buildNumberedPoint(4, "Dedicated team of expert professionals"),
                    ],
                    
                    SizedBox(height: 24.h),

                    // Reviews
                    Text(
                      "Top Reviews",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    if (profile.reviews == null || profile.reviews!.isEmpty)
                       Text("No reviews yet", style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)),
                    if (profile.reviews != null)
                      ...profile.reviews!.take(3).map((review) => _buildReviewItem(review)).toList(),
                    
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
                          (service!.appointmentEnabled == true) ? "Appointment Price: " : "Service Price: ",
                          style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.black87),
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
                          style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
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
                             'providerId': employeeId, 
                             'providerName': provider?.name,
                             'providerImage': provider?.image,
                             'providerAddress': provider?.address,
                             'serviceTitle': service?.title,
                             'servicePrice': service?.basePrice,
                             'availableTime': provider?.availableTime,
                             'appointmentSlots': service?.appointmentSlots?.map((e) => {
                               'duration': e.duration,
                               'durationUnit': e.durationUnit,
                               'price': e.price,
                             }).toList(),
                           };

                           if (service!.appointmentEnabled == true) {
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
                          (service.appointmentEnabled == true) ? "Make an appointment" : "Get this service",
                          style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.bold),
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
      height: 170.h,
      color: Colors.grey[200],
      child: Icon(Icons.image, size: 50.sp, color: Colors.grey),
    );
  }

  Widget _buildNumberedList(String? about) {
    if (about == null || about.isEmpty) return const SizedBox.shrink();
    
    List<String> items = about.split(RegExp(r'\n|\. ')).where((s) => s.trim().isNotEmpty).toList();
    
    if (items.isEmpty) return Text(about, style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[700]));

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
            style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ProviderReview review) {
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
                      style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
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
                review.createdAt ?? "",
                style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.comment ?? "",
            style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }
}
