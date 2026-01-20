import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:middle_ware/views/user/categories/widgets/custom_provider_card.dart';
import 'package:middle_ware/views/user/home/widgets/custom_bussiness_card.dart';
import 'package:middle_ware/views/user/home/widgets/custom_events_card.dart';
import 'package:middle_ware/views/user/home/widgets/custom_provider_card.dart';
import 'package:middle_ware/views/user/home/widgets/custom_top_businesses_card.dart';
import 'package:middle_ware/views/user/profile/my_events.dart';
import '../../../controller/home/event_controller.dart';
import '../../../controller/home/recent_providers_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final EventController eventController = Get.put(EventController());
  final RecentProviderController recentController = Get.put(RecentProviderController());



  @override
  Widget build(BuildContext context) {

    final List<String> _names = [
      "Style Hair Cut",
      "Power Flex Gym",
      "Pure Life Wellness",
      "Knowledge Tree",
    ];

    final List<String> _categories = [
      "Beauty",
      "Fitness",
      "Health",
      "Education",
    ];

    final List<double> _distances = [0.8, 0.9, 1.2, 1.4];

    final List<String> _images = [
      'assets/images/hairCut.png',
      'assets/images/gymIcon.png',
      'assets/images/healthIcon.png',
      'assets/images/education.png',
    ];

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
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 30.r,
                                    backgroundImage: NetworkImage(
                                      'https://randomuser.me/api/portraits/men/32.jpg',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Welcome Back',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Sean Rahman',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                            Text(
                              "Near You",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                              ),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return CustomProviderCard(
                                  providerName: 'Shahin Alam',
                                  location: 'Dhanmondi, Dhaka 1209',
                                  activeStatus: '1 hour ago',
                                  serviceTitle: 'Expert House Cleaning Service',
                                  serviceDescription: 'I take care of every corner, deep cleaning every room without leaving your home fresh and perfectly tidy for you.',
                                  reviews: '4.00 (120)',
                                  appointmentPrice: 50,
                                  servicePrice: 100,
                                );
                              },
                            ),
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
                                Text(
                                  "Within 6 km radius",
                                  style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.95,
                              ),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                  return BusinessCard(
                                    name: _names[index],
                                    category: _categories[index],
                                    rating: 4.8,
                                    distance: _distances[index],
                                    image: _images[index],

                                 );
                              },
                            ),
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

                            ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: 5,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return CustomTopbusinessesCard(
                                  title: "Expert house cleaning service",
                                  review: "4.8",
                                  location: "321 Fashion Blvb,City Center",
                                  numberEmployees: 121,
                                  numberOfServices: 12,
                                );
                              },
                            ),
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


