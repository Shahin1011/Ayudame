import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart' show ImageSource;
import 'package:middle_ware/models/user/profile/profile_model.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';
import 'package:middle_ware/views/user/profile/ProfilePage.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/profile/profile_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../controller/profile/edit_profile_controller.dart';
import '../../../utils/token_service.dart';
import '../../../widgets/user_custom_text_field.dart';
import 'package:get/get.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel? profile;
  bool isLoading = false;
  final EditProfile _controller = Get.put(EditProfile());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    profile = Get.arguments as UserModel?;
    if (profile == null) {
      // Handle null safely
      Get.snackbar("Error", "User data not found");
      return;
    }

    // Prefill controllers
    nameController.text = profile?.fullName ?? "";
    emailController.text = profile?.email ?? "";


    // Set initial image if available
    if (profile?.profilePicture != null && profile!.profilePicture!.isNotEmpty) {
      _controller.setInitialImage(profile?.profilePicture ?? "");
    }
  }


  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> updateUser() async {
    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }

    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Alert", "No authentication token");
      return;
    }

    setState(() => isLoading = true);

    File? imageFile = _controller.selectedImage.value;
    String newName = nameController.text.trim();
    String newPhone = phoneController.text.trim();

    try {
      final response = await _controller.uploadProfile(
        fullname: newName,
        profilePicture: imageFile,
        phoneNumber: newPhone,
        token: token,
      );

      if (response["status"] == 200) {

        // Update ProfileController instantly
        final p = Get.find<ProfileController>();
        p.fetchProfile();

        Get.snackbar(
          "Success",
          response["body"]["message"] ?? "Updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.off(() => ProfilePage());
      } else {
        Get.snackbar(
          "Error",
          response["body"]["message"] ?? "Update failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }



  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(title: "Edit Profile"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.055),


                    Center(
                      child: Stack(
                        children: [
                          Obx(() {
                            final imageUrl = _controller.userProfileImageUrl.value;
                            final file = _controller.selectedImage.value;

                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.mainAppColor, width: 1.5),
                              ),
                              child: ClipOval(
                                child: SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: file != null
                                  // Picked image
                                      ? Image.file(file, fit: BoxFit.cover)

                                  // Server image with shimmer (same as profile page)
                                      : CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      "assets/images/emptyUser.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          Positioned(
                            bottom: 5,
                            right: 2,
                            child: GestureDetector(
                              onTap: (){
                                _controller.pickImage(ImageSource.gallery);
                              },
                              child: SvgPicture.asset("assets/icons/inputImageIcon.svg", width: 28.w, height: 28.h),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField1(
                      textEditingController: nameController,
                      hintText: 'Full Name',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: Colors.black38,
                      ),
                      fillColor: const Color(0xFFFFFFFF),
                      fieldBorderColor: AppColors.grey,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'E-mail address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField1(
                      textEditingController: emailController,
                      hintText: 'E-mail address',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: Colors.black38,
                      ),
                      fillColor: const Color(0xFFFFFFFF),
                      fieldBorderColor: AppColors.grey,
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField1(
                      textEditingController: phoneController,
                      hintText: 'phone number',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: Colors.black38,
                      ),
                      fillColor: const Color(0xFFFFFFFF),
                      fieldBorderColor: AppColors.grey,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.050,),

                    GestureDetector(
                      onTap: isLoading ? null : updateUser,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.mainAppColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          isLoading ? "Loading..." : "Save Changes",
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE6E6E6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
