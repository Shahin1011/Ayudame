import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_text_field.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String selectedHomeType = 'Apartment';
  String selectedOutdoorSpace = 'No Yard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 3),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.grey,
                            child: Icon(
                              Icons.person,
                              size: 60.sp,
                              color: AppColors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _buildInputField('Full Name', 'Name'),
            SizedBox(height: 20.h),
            _buildInputField('E-mail address', 'E-mail address or phone number'),
            SizedBox(height: 20.h),
            _buildInputField('Phone number', 'E-mail address or phone number'),
            SizedBox(height: 20.h),
            _buildTextArea('About', 'Introduce yourself to potential clients...', maxLength: 500),
            SizedBox(height: 20.h),
            _buildInputField('Pet number', '03', keyboardType: TextInputType.number),
            SizedBox(height: 20.h),
            _buildInputField('Street', 'Street Number and Name'),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(child: _buildInputField('State', 'State')),
                SizedBox(width: 12.w),
                Expanded(child: _buildInputField('Zip Code', 'Zip Code')),
              ],
            ),
            SizedBox(height: 20.h),
            _buildDropdown('Home Type', selectedHomeType, ['Apartment', 'Townhouse', 'House', 'Condo'], (value) {
              setState(() {
                selectedHomeType = value!;
              });
            }),
            SizedBox(height: 20.h),
            _buildInputField('Home Size (sq ft)', 'e.g. 800', keyboardType: TextInputType.number),
            SizedBox(height: 20.h),
            _buildDropdown('Outdoor Space', selectedOutdoorSpace, ['Fenced Yard', 'Unfenced Yard', 'No Yard'], (value) {
              setState(() {
                selectedOutdoorSpace = value!;
              });
            }),
            SizedBox(height: 40.h),
            // Save Changes Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainAppColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: hint,
          keyboardType: keyboardType ?? TextInputType.text,
          fieldBorderRadius: 14,
          fillColor: AppColors.white,
        ),
      ],
    );
  }

  Widget _buildTextArea(String label, String hint, {int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: hint,
          maxLines: 4,
          maxLength: maxLength,
          fieldBorderRadius: 12,
          fieldBorderColor: AppColors.grey,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE3E6F0)),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: options.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}