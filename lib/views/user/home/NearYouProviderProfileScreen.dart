import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../controller/user/home/provider_profile_controller.dart';
import '../../../core/routes/app_routes.dart';
import 'ProviderServiceDetailsScreen.dart';

class NearYouProviderProfileScreen extends StatefulWidget {
  const NearYouProviderProfileScreen({Key? key}) : super(key: key);

  @override
  State<NearYouProviderProfileScreen> createState() => _NearYouProviderProfileScreenState();
}

class _NearYouProviderProfileScreenState extends State<NearYouProviderProfileScreen> {
  final ProviderProfileController controller = Get.put(ProviderProfileController());
  final Color primaryGreen = const Color(0xFF1B5E4E);

  @override
  void initState() {
    super.initState();
    final providerId = Get.arguments;
    if (providerId != null && providerId is String) {
      Future.microtask(() => controller.fetchProviderProfile(providerId));
    }
  }

  @override
  void dispose() {
    Get.delete<ProviderProfileController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: CustomAppBar(title: "Provider Profile"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E4E)));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    final providerId = Get.arguments;
                    if (providerId != null) controller.fetchProviderProfile(providerId);
                  },
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        final profile = controller.providerProfile.value;
        if (profile == null) {
          return const Center(child: Text("No profile data available"));
        }

        return Column(
          children: [
            _buildProfileHeader(profile.provider),
            _buildTabSelector(),
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: _buildTabContent(profile),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProfileHeader(dynamic provider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.grey[200],
            backgroundImage: (provider?.image != null && provider!.image!.isNotEmpty)
                ? NetworkImage(provider.image!)
                : null,
            child: (provider?.image == null || provider!.image!.isEmpty)
                ? Icon(Icons.person, size: 50.sp, color: Colors.grey)
                : null,
          ),
          SizedBox(height: 12.h),
          Text(
            provider?.name ?? "Provider Name",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20.sp),
              SizedBox(width: 4.w),
              Text(
                "${provider?.rating ?? 0.0}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                "(${provider?.totalReviews ?? 0})",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTabButton("All Services", 0),
          _buildTabButton("Reviews", 1),
          _buildTabButton("Portfolio", 2),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
          color: isSelected ? primaryGreen : (Colors.grey[300] ?? Colors.grey),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(dynamic profile) {
    switch (controller.selectedTab.value) {
      case 0:
        return _buildAllServices(profile.allServices?.services);
      case 1:
        return _buildReviews(profile.reviews);
      case 2:
        return _buildPortfolio(profile.portfolio);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAllServices(List<dynamic>? services) {
    if (services == null || services.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Text("No services found", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
        ),
      );
    }

    return Column(
      children: services.map((service) => _buildServiceCard(service)).toList(),
    );
  }

  Widget _buildServiceCard(dynamic service) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                child: (service.image != null && service.image!.isNotEmpty)
                    ? Image.network(
                        service.image!,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  radius: 16.r,
                  child: Icon(Icons.favorite_border, size: 18.sp, color: Colors.redAccent),
                ),
              ),
            ],
          ),
          
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: Colors.grey[200],
                    backgroundImage: (controller.providerProfile.value?.provider?.image != null && controller.providerProfile.value!.provider!.image!.isNotEmpty)
                          ? NetworkImage(controller.providerProfile.value!.provider!.image!)
                          : null,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.providerProfile.value?.provider?.name ?? "Provider Name",
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          Text(
                            controller.providerProfile.value?.provider?.address ?? "Address",
                            style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${service.daysAgo ?? 0} days ago",
                      style: TextStyle(fontSize: 11.sp, color: primaryGreen, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Service Title
                Text(
                  service.title ?? "Service Title",
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 8.h),
                
                // Service Description
                Text(
                  service.about ?? "",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[700], height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                
                // Rating
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 16.sp,
                          color: index < (service.rating?.toInt() ?? 0) ? Colors.amber : Colors.grey[300],
                        );
                      }),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "${service.rating ?? 0.0}",
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "(${service.totalReviews ?? 0})",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                
                // Price and Button
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.appointmentEnabled == true 
                          ? "Appointment Price: \$${service.minAppointmentPrice ?? 0}"
                          : "Service Price: \$${service.basePrice ?? 0}",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Pass both IDs to ensure "View profile" works in the next screen
                        Get.to(() => const ProviderServiceDetailsScreen(), arguments: {
                          'serviceId': service.serviceId,
                          'providerId': Get.arguments, 
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        elevation: 0,
                      ),
                      child: Text("View Details", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(List<dynamic>? reviews) {
    if (reviews == null || reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Text("No reviews found", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Reviews",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        ...reviews.map((review) => _buildReviewItem(review)).toList(),
      ],
    );
  }

  Widget _buildReviewItem(dynamic review) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: (review.user?.image != null && review.user!.image!.isNotEmpty)
                    ? NetworkImage(review.user!.image!)
                    : null,
                child: (review.user?.image == null || review.user!.image!.isEmpty)
                    ? Icon(Icons.person, size: 20.sp)
                    : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.user?.name ?? "User", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    _buildRatingStars(review.rating?.toInt() ?? 0),
                  ],
                ),
              ),
              Text(
                "1 Month ago", // Hardcoded for now or use a formatter
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            review.comment ?? "",
            style: TextStyle(fontSize: 12.sp, color: Colors.black87, height: 1.5),
          ),
          SizedBox(height: 10.h),
          Divider(color: Colors.grey[200]),
        ],
      ),
    );
  }

  Widget _buildPortfolio(List<dynamic>? portfolio) {
    if (portfolio == null || portfolio.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Text("No portfolio items found", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
        ),
      );
    }

    return Column(
      children: portfolio.map((item) => _buildPortfolioCard(item)).toList(),
    );
  }

  Widget _buildPortfolioCard(dynamic item) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: (item.beforeImage != null && item.beforeImage!.isNotEmpty)
                          ? Image.network(item.beforeImage!, height: 110.h, width: double.infinity, fit: BoxFit.cover)
                          : Container(height: 110.h, color: Colors.grey[200]),
                    ),
                    SizedBox(height: 8.h),
                    Text("Before", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: (item.afterImage != null && item.afterImage!.isNotEmpty)
                          ? Image.network(item.afterImage!, height: 110.h, width: double.infinity, fit: BoxFit.cover)
                          : Container(height: 110.h, color: Colors.grey[200]),
                    ),
                    SizedBox(height: 8.h),
                    Text("After", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            item.about ?? "Portfolio Description",
            style: TextStyle(
              fontSize: 12.sp, 
              color: const Color(0xFF2E7D32), // Darker green for text
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          _buildBulletPoint("Professional and high-quality results."),
          _buildBulletPoint("Transformed the space completely and efficiently."),
          _buildBulletPoint("Satisfaction guaranteed with our expert work."),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 11.sp, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16.sp,
        );
      }),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 170.h,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(Icons.image, size: 50.sp, color: Colors.grey),
    );
  }
}
