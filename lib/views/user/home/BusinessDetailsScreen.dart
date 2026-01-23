import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../controller/user/home/business_details_controller.dart';
import '../../../models/user/home/business_details_model.dart';
import '../../../models/user/home/provider_profile_model.dart';
import 'widgets/custom_employee_card.dart';
import 'ProviderServiceDetailsScreen.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  final BusinessDetailsController controller = Get.put(BusinessDetailsController());
  late String businessOwnerId;

  @override
  void initState() {
    super.initState();
    businessOwnerId = Get.arguments as String;
    Future.microtask(() => controller.fetchBusinessDetails(businessOwnerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: CustomAppBar(title: "Business Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E4E)));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final data = controller.businessData.value;
        if (data == null) {
          return const Center(child: Text("No data found"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(data.businessDetails!),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAboutSection(data.businessDetails!),
                    SizedBox(height: 20.h),
                    _buildTabBar(),
                    SizedBox(height: 20.h),
                    _buildTabContent(data),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BusinessHeaderInfo details) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: (details.businessCoverPhoto != null && details.businessCoverPhoto!.isNotEmpty)
                ? Image.network(
                    details.businessCoverPhoto!,
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildCoverPlaceholder(),
                  )
                : _buildCoverPlaceholder(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (details.businessPhoto != null && details.businessPhoto!.isNotEmpty)
                      ? Image.network(
                          details.businessPhoto!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.business, size: 30.sp, color: Colors.grey),
                        )
                      : Icon(Icons.business, size: 30.sp, color: Colors.grey),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.businessName ?? "Business Name",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4.w),
                        Text(
                          "${details.employeeCount ?? 0} Employees",
                          style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.cleaning_services_outlined, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4.w),
                        Text(
                          "${details.serviceCount ?? 0} Services",
                          style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: Color(0xFF1B5E4E), size: 20),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        details.businessLocation ?? "Address",
                        style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BusinessHeaderInfo details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "About",
          style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        Text(
          details.about ?? "No information available.",
          style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabItem(0, "Team"),
          _buildTabItem(1, "Services"),
          _buildTabItem(2, "Reviews"),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    bool isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B5E4E) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BusinessDetailsData data) {
    switch (controller.selectedTab.value) {
      case 0:
        return _buildTeamTab(data);
      case 1:
        return _buildServicesTab(data);
      case 2:
        return _buildReviewsTab(data);
      default:
        return Container();
    }
  }

  Widget _buildTeamTab(BusinessDetailsData data) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            onChanged: (v) => controller.updateSearch(v),
            decoration: InputDecoration(
              hintText: "Search Services..",
              hintStyle: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
              icon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              focusedBorder: InputBorder.none
            ),
          ),
        ),
        SizedBox(height: 20.h),
        if (controller.filteredTeam.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                "No Employee available",
                style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.filteredTeam.length,
          itemBuilder: (context, index) {
            final member = controller.filteredTeam[index];
            return CustomEmployeeCard(
              providerName: member.employeeName ?? "Unknown",
              location: member.employeeAddress ?? "Location",
              activeStatus: "${member.daysAgo} day ago",
              serviceTitle: member.serviceHeadline ?? "Service Title",
              serviceDescription: member.serviceDescription ?? "Description",
              reviews: "${member.rating?.toStringAsFixed(1) ?? "0.0"} (${member.totalReviews ?? 0})",
              appointmentPrice: member.minAppointmentPrice?.toDouble(),
              servicePrice: member.basePrice?.toDouble(),
              serviceImage: member.employeeServicePhoto,
              providerImage: member.employeeImage,
              serviceId: member.employeeId, // ID of the service matching the employee
              providerId: member.employeeId, // The specific Employee ID needed for the profile API
              appointmentEnabled: member.appointmentEnabled,
            );
          },
        ),
      ],
    );
  }

  Widget _buildServicesTab(BusinessDetailsData data) {
    if (data.services == null || data.services!.isEmpty) {
      return const Center(child: Text("No services listed"));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.services!.length,
      itemBuilder: (context, index) {
        final service = data.services![index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/service.svg", height: 24.h, width: 24.w),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  service.headline ?? "Service",
                  style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(BusinessDetailsData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Reviews",
          style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 15.h),
        if (data.reviews == null || data.reviews!.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                "No reviews available",
                style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.reviews!.length,
            itemBuilder: (context, index) {
              return _buildReviewItem(data.reviews![index]);
            },
          ),
      ],
    );
  }

  Widget _buildReviewItem(ProviderReview review) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                backgroundImage: (review.user?.image != null && review.user!.image!.isNotEmpty)
                    ? NetworkImage(review.user!.image!)
                    : null,
                child: (review.user?.image == null || review.user!.image!.isEmpty)
                    ? Icon(Icons.person, color: Colors.grey, size: 24.sp)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.user?.name ?? "Anonymous",
                        style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < (review.rating ?? 0).floor() ? Colors.amber : Colors.grey[300],
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                review.createdAt ?? "Some time ago",
                style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.comment ?? "",
            style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[700], height: 1.4),
          ),
        ],
      ),
    );
  }
  Widget _buildCoverPlaceholder() {
    return Container(
      height: 150.h,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(Icons.business, size: 50.sp, color: Colors.grey),
    );
  }
}
