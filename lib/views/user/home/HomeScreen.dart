import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:middle_ware/views/user/categories/widgets/custom_provider_card.dart';
import 'package:middle_ware/views/user/home/widgets/custom_bussiness_card.dart';
import 'package:middle_ware/views/user/home/widgets/custom_events_card.dart';
import 'package:middle_ware/views/user/home/widgets/custom_featured_provider_card.dart';
import 'package:middle_ware/views/user/home/widgets/custom_top_businesses_card.dart';
import 'package:middle_ware/views/user/profile/my_events.dart';
import '../../../controller/user/home/event_controller.dart';
import '../../../controller/user/home/nearby_providers_controller.dart';
import '../../../controller/user/home/recent_providers_controller.dart';
import '../../../controller/user/home/featured_providers_controller.dart';
import '../../../controller/user/home/top_businesses_controller.dart';
import '../../../controller/user/profile/profile_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ProfileController profileController = Get.put(ProfileController());
  final EventController eventController = Get.put(EventController());
  final RecentProviderController recentController = Get.put(RecentProviderController());
  final NearbyProvidersController nearbyController = Get.put(NearbyProvidersController());
  final TopBusinessesController topBusinessesController = Get.put(TopBusinessesController());
  final FeaturedProvidersController featuredProvidersController = Get.put(FeaturedProvidersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor1,
      body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Section
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2D6A4F),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 16.h),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Profile Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.userProfile);
                            },
                            child: Row(
                              children: [
                                Obx(() {
                                  final user = profileController.user.value;
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 30.r,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: (user?.profilePicture != null && user!.profilePicture!.isNotEmpty)
                                          ? NetworkImage(user.profilePicture!)
                                          : null,
                                      child: (user?.profilePicture == null || user!.profilePicture!.isEmpty)
                                          ? Icon(Icons.person, color: Colors.grey, size: 30.r)
                                          : null,
                                    ),
                                  );
                                }),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome Back',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Obx(() {
                                      final user = profileController.user.value;
                                      return Text(
                                        user?.fullName ?? 'User Name',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.notifications);
                            },
                            child: SvgPicture.asset(
                              "assets/icons/NotificationICon.svg",
                              width: 34.w,
                              height: 34.h,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                  
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search providers, businesses, services..',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                              size: 28,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Content Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),

                            /// -------------- Featured Providers ----------------------------------- ///
                            Obx(() {
                              if (featuredProvidersController.isLoading.value) {
                                return SizedBox(
                                  height: 400.h,
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              }

                              if (featuredProvidersController.allFeaturedServices.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return SizedBox(
                                height: 370.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  itemCount: featuredProvidersController.allFeaturedServices.length,
                                  itemBuilder: (context, index) {
                                    final item = featuredProvidersController.allFeaturedServices[index];
                                    final provider = item.provider;
                                    final service = item.service;

                                    return Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: SizedBox(
                                        width: 310.w,
                                        child: CustomFeaturedProviderCard(
                                          providerName: provider.name ?? 'Unknown',
                                          location: provider.address ?? 'No Address',
                                          activeStatus: provider.activityTime ?? '',
                                          serviceTitle: service.serviceName ?? 'No Service',
                                          serviceDescription: service.serviceDetail ?? 'No Description',
                                          reviews: "${service.rating?.toStringAsFixed(1) ?? '0.0'} (${service.totalReviews ?? 0})",
                                          appointmentPrice: service.appointmentEnabled == true 
                                              ? (service.appointmentSlots != null && service.appointmentSlots!.isNotEmpty 
                                                  ? (service.appointmentSlots![0]['price']?.toDouble() ?? 0.0) 
                                                  : 0.0)
                                              : null,
                                          servicePrice: service.basePrice?.toDouble(),
                                          providerImage: provider.profileImage,
                                          serviceImage: service.servicePhoto,
                                          serviceId: service.serviceId,
                                          providerId: provider.providerId,
                                          appointmentEnabled: service.appointmentEnabled,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                            SizedBox(height: 18.h),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Near You",
                                  style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
                                ),
                                Obx(() => Text(
                                  "Within ${nearbyController.searchRadiusKm.value} km radius",
                                  style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            Obx(() {
                              if (nearbyController.isLoading.value) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (nearbyController.errorMessage.isNotEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      nearbyController.errorMessage.value,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }

                              if (nearbyController.categories.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text("No nearby providers found"),
                                  ),
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.95,
                                ),
                                itemCount: nearbyController.categories.length,
                                itemBuilder: (context, index) {
                                  final category = nearbyController.categories[index];
                                  
                                  // Parse average distance from string or use the numeric value if available
                                  double avgDistance = 0.0;
                                  if (category.averageDistanceKm != null) {
                                    avgDistance = double.tryParse(category.averageDistanceKm!) ?? 0.0;
                                  } else if (category.averageDistance != null) {
                                     // If we only have meters (assuming numeric averageDistance is meters), convert to km 
                                     // But based on JSON example, averageDistanceKm should be present.
                                     avgDistance = (category.averageDistance!.toDouble()) / 1000;
                                  }

                                  return BusinessCard(
                                    name: category.categoryName ?? 'Unknown',
                                    category: "${category.providerCount ?? 0} Providers",
                                    distance: avgDistance,
                                    showDistance: (category.providerCount ?? 0) > 0,
                                    image: category.categoryImage ?? '',
                                    categoryId: category.categoryId ?? '',
                                  );
                                },
                              );
                            }),
                            SizedBox(height: 20.h),


                            /// ------------------------ Events Section --------------------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Events",
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Get.to(() => MyEvents());
                                  },
                                  child: Text(
                                    "View all",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mainAppColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 260.h,
                              child: Obx(() {
                                if(eventController.isLoading.value){
                                  return Center(child: CircularProgressIndicator());
                                }

                                if(eventController.errorMessage.isNotEmpty){
                                  return Center(
                                    child: Text(
                                      eventController.errorMessage.value,
                                      style: TextStyle(color: Colors.red),
                                    ),

                                  );
                                }

                                if (eventController.eventList.isEmpty) {
                                 return  Center(child: Text("No events available"));
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(top: 10.h,),
                                  itemCount: eventController.eventList.length,
                                  itemBuilder: (context, index) {
                                    final event = eventController.eventList[index];

                                    return Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: SizedBox(
                                        width: 300.w,
                                        child: CustomEventCard(
                                          title: event.eventType,
                                          eventName: event.eventName,
                                          eventImage: event.eventImage,
                                          date: event.formattedDate,
                                          timeRange: event.formattedTime,
                                          location: event.eventLocation,
                                          attendingCount: event.ticketsSold,
                                          eventId: event.eventId,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              })

                            ),
                            SizedBox(height: 18.h),


                            /// ---------------------------- Recent provider section ------------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Providers",
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){},
                                  child: Text(
                                    "View all",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mainAppColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            SizedBox(
                              height: 400.h,
                              child: Obx(() {
                                if (recentController.isLoading.value) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (recentController.providerList.isEmpty) {
                                  return const Center(child: Text("No recent providers found"));
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  itemCount: recentController.providerList.length,
                                  itemBuilder: (context, index) {
                                    final provider = recentController.providerList[index];

                                    return Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: SizedBox(
                                        width: 320.w,
                                        child: CustomProviderCard(
                                          providerName: provider.fullName,
                                          location: provider.location.address,
                                          activeStatus: provider.isAvailable ? "Available" : "Unavailable",
                                          serviceTitle: provider.lastService.service.name,
                                          serviceDescription:
                                          provider.lastService.service.description,
                                          reviews:
                                          "${provider.rating} (${provider.totalReviews})",
                                          servicePrice:
                                          provider.lastService.service.basePrice.toDouble(),
                                          appointmentPrice: null,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),

                            SizedBox(height: 18.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Top Businesses",
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.allTopBusinesses);
                                  },
                                  child: Text(
                                    "View all",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mainAppColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            Obx(() {
                              if (topBusinessesController.isLoading.value) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (topBusinessesController.errorMessage.isNotEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      topBusinessesController.errorMessage.value,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }

                              if (topBusinessesController.businesses.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text("No top businesses found"),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: topBusinessesController.businesses.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final business = topBusinessesController.businesses[index];
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
                            SizedBox(height: 10.h),

                          ],
                       ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}


