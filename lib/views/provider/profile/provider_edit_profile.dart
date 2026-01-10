import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../widgets/custom_text_field.dart';


class ProviderEditProfileScreen extends StatefulWidget {
  const ProviderEditProfileScreen ({super.key});

  @override
  State<ProviderEditProfileScreen > createState() => _ProviderEditProfileScreenState();
}

class _ProviderEditProfileScreenState extends State<ProviderEditProfileScreen > {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _obscure3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(radius: 50.r, backgroundImage: const AssetImage('assets/images/profile.png')),
                  Positioned(bottom: 0, right: 0, child: _buildCameraIcon()),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            _buildFieldLabel('Full Name'),
            CustomTextField(controller: _nameController, hintText: 'Name'),
            SizedBox(height: 15.h),
            _buildFieldLabel('E-mail address or phone number'),
            CustomTextField(controller: _emailController, hintText: 'E-mail address or phone number'),
            SizedBox(height: 15.h),
            _buildFieldLabel('Date of birth'),
            CustomTextField(
              controller: _dobController,
              hintText: '11/12/2025',
              suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
            ),
            SizedBox(height: 15.h),
            _buildFieldLabel('Select occupation'),
            CustomTextField(controller: _occupationController, hintText: 'Doctor'),
            SizedBox(height: 15.h),
            _buildFieldLabel('Current Password'),
            _buildPasswordField(_obscure1, (v) => setState(() => _obscure1 = v)),
            SizedBox(height: 15.h),
            _buildFieldLabel('New Password'),
            _buildPasswordField(_obscure2, (v) => setState(() => _obscure2 = v)),
            SizedBox(height: 15.h),
            _buildFieldLabel('Confirm Password'),
            _buildPasswordField(_obscure3, (v) => setState(() => _obscure3 = v)),
            SizedBox(height: 30.h),
            _buildSaveButton('Save Changes'),
          ],
        ),
      ),
    );
  }


  Widget _buildFieldLabel(String label) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(label, style: GoogleFonts.montserrat(fontSize: 14.sp, fontWeight: FontWeight.w500)),
  );

  Widget _buildPasswordField(bool obscure, Function(bool) toggle) => CustomTextField(
    isPassword: obscure,
    hintText: '********',
    suffixIcon: IconButton(
      icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
      onPressed: () => toggle(!obscure),
    ),
  );

  Widget _buildCameraIcon() => Container(
    padding: EdgeInsets.all(4.w),
    decoration: const BoxDecoration(color: Color(0xFF1B4D3E), shape: BoxShape.circle),
    child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18.sp),
  );

  Widget _buildSaveButton(String text) => SizedBox(
    width: double.infinity,
    height: 50.h,
    child: ElevatedButton(
      onPressed: () {
        Get.back();
      },
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4D3E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Inter")),
    ),
  );
}