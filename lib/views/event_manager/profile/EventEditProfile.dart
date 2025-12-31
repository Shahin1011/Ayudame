import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/event_manager/profile/profile_info.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/custom_text_field.dart'; // আপনার কাস্টম টেক্সট ফিল্ড

class EventEditProfileScreen extends StatefulWidget {
  const EventEditProfileScreen({super.key});

  @override
  State<EventEditProfileScreen> createState() => _EventEditProfileScreenState();
}

class _EventEditProfileScreenState extends State<EventEditProfileScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();


  bool _isObscurePass = true;
  bool _isObscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const CustomAppBar(
        title: "Edit Profile",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            // ১. Full Name Field
            CustomTextField(
              controller: _nameController,
              hintText: 'Full name',
            ),
            SizedBox(height: 16.h),

            // ২. E-mail address Field
            CustomTextField(
              controller: _emailController,
              hintText: 'E-mail address',
            ),
            SizedBox(height: 16.h),

            // ৩. Password Field (With Eye Icon)
            CustomTextField(
              controller: _passController,
              hintText: 'Password',
              isPassword: _isObscurePass,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: () => setState(() => _isObscurePass = !_isObscurePass),
              ),
            ),
            SizedBox(height: 16.h),

            // ৪. Confirm Password Field
            CustomTextField(
              controller: _confirmPassController,
              hintText: 'Confirm Password',
              isPassword: _isObscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
              ),
            ),
            SizedBox(height: 16.h),

            // ৫. Phone Number Field
            CustomTextField(
              controller: _phoneController,
              hintText: 'Phone number',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.h),

            // ৬. Date of Birth Field (With Calendar Icon)
            CustomTextField(
              controller: _dobController,
              hintText: 'mm/dd/yyyy',
              readOnly: true,
              suffixIcon: Icon(
                Icons.calendar_month_outlined,
                color: Colors.grey.shade400,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 16.h),

            // ৭. Select Category (Dropdown Style)
            CustomTextField(
              hintText: 'Select Category',
              readOnly: true,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 16.h),

            // ৮. Business Address Field
            CustomTextField(
              controller: _addressController,
              hintText: 'Business Address',
            ),
            SizedBox(height: 40.h),

            // ৯. Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() =>  ProfileInfoScreen());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B4D3E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}