import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:middle_ware/views/user/auth/LoginScreen.dart';
import 'package:middle_ware/views/user/orders/OrderHistoryScreen.dart';
import 'package:middle_ware/views/user/profile/EditProfileScreen.dart';
import 'package:middle_ware/views/user/profile/HelpSupportScreen.dart';
import 'package:middle_ware/views/user/profile/NotificationPage.dart';
import 'package:middle_ware/views/user/profile/WishlistScreen.dart';
import 'package:middle_ware/views/user/profile/my_events.dart';
import 'package:middle_ware/views/user/profile/user_bank_information.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/profile/profile_controller.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'PrivacyPolicyScreen.dart';
import 'TermsConditionScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProfilePage extends StatelessWidget {
   ProfilePage({Key? key}) : super(key: key);


   final _controller = ValueNotifier<bool>(false);
   final ProfileController profileController = Get.put(ProfileController());

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(title: "Profile"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    Obx(() {
                      if (profileController.isLoading.value) {
                        return const CircularProgressIndicator();
                      }

                      if (profileController.errorMessage.isNotEmpty) {
                        return Text(profileController.errorMessage.value);
                      }

                      final user = profileController.user.value;
                      if (user == null) {
                        return const Text("User data not found");
                      }

                      return Column(
                        children: [
                          // ----------- Profile Image ----------
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.mainAppColor,
                                  width: 1.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey[200],
                                child: ClipOval(
                                  child: user == null
                                      ? Image.asset(
                                    "assets/images/emptyUser.png",
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  )
                                      : CachedNetworkImage(
                                    imageUrl: user.profilePicture ?? "",
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 110,
                                        height: 110,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      "assets/images/emptyUser.png",
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      );
                    }),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                    /// Account Information Details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Color(0xFFE3E6F0),
                          width: 0.6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Information",
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                          settingsTile(
                            iconPath: "assets/icons/editProfile.svg",
                            title: "Edit Profile",
                            onTap: () {
                              final user = profileController.user.value;
                              if (user != null) {
                                Get.to(() => EditProfileScreen(), arguments: user);
                              } else {
                                Get.snackbar("Error", "User data not found");
                              }
                            },
                          ),
                          SizedBox(height: 16.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/icons/people.png", width: 24, height: 24, color: Color(0xFF4d4d4d),),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Switch to provider",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4d4d4d),
                                    ),
                                  ),
                                ],
                              ),
                              AdvancedSwitch(
                                activeColor: AppColors.mainAppColor,
                                inactiveColor: Color(0xFF787880).withOpacity(0.16),
                                width: 48.w,
                                height: 25.h,
                                controller: _controller,
                                borderRadius: BorderRadius.circular(77),
                              ),

                            ],
                          ),
                          SizedBox(height: 16.h),
                          settingsTile(
                            iconPath: "assets/icons/wishlistIcon.svg",
                            title: "Wishlist",
                            onTap: () {
                              Get.to(() => WishlistScreen());
                            },
                          ),
                          SizedBox(height: 16.h),
                          settingsTile(
                            iconPath: "assets/icons/eventIcon.svg",
                            title: "My events",
                            onTap: () {
                              Get.to(() => MyEvents());
                            },
                          ),
                          SizedBox(height: 16.h),
                          settingsTile(
                            iconPath: "assets/icons/orderHistory.svg",
                            title: "order history",
                            onTap: () {
                              Get.to(() => OrderHistoryScreen());
                            },
                          ),
                          SizedBox(height: 16.h),
                          settingsTile(
                            iconPath: "assets/icons/bankIcon.svg",
                            title: "Bank Information",
                            onTap: () {
                              Get.to(() => userBankInformation());
                            },
                          ),
                          SizedBox(height: 16.h),

                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),


                    /// Policy Center Details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Color(0xFFE3E6F0),
                          width: 0.6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Policy Center",
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                          settingsTile(
                            iconPath: "assets/icons/privacyIcon.svg",
                            title: "Privacy Policy",
                            onTap: () {
                              Get.to(() => PrivacyPolicyScreen());
                            },
                          ),
                          SizedBox(height: 16.h),
                          settingsTile(
                            iconPath: "assets/icons/termsIcon.svg",
                            title: "Terms & Conditions",
                            onTap: () {
                              Get.to(() => TermsConditionScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    /// Settings Details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Color(0xFFE3E6F0),
                          width: 0.6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Settings",
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          settingsTile(
                            title: "Notification",
                            onTap: () {
                              Get.to(() => NotificationPage());
                            },
                            iconPath: 'assets/icons/notification.svg',
                          ),
                          SizedBox(height: 16.h),
                          settingsTile(
                            title: "Help & support",
                            onTap: () {
                              Get.to(() => HelpSupportScreen());
                            },
                            iconPath: 'assets/icons/helpIcon.svg',
                          ),
                          SizedBox(height: 16.h),
                          settingsTile(
                            title: "Log out",
                            onTap: () {
                              Get.to(() => UserLoginScreen());
                            },
                            iconPath: 'assets/icons/logout.svg',
                          ),
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: (){
                              _showDeleteDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset("assets/icons/delete.svg"),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Delete Account",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-Regular',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.red),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsTile({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath, color: Color(0xFF4d4d4d),),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4d4d4d),
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 17, color: Color(0xFF4d4d4d),),
        ],
      ),
    );
  }
  

  // -------------------- Delete Confirmation Dialog --------------------
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SvgPicture.asset("assets/icons/deleteIcon.svg"),
              ),
              SizedBox(height: 12.h),
              Text(
                "Delete Account",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mainAppColor,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Are you sure to delete this account?",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF494949),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainAppColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}