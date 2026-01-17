import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/viewmodels/event_manager_viewmodel.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../widgets/custom_text_field.dart';

class EventEditProfileScreen extends StatefulWidget {
  const EventEditProfileScreen({super.key});

  @override
  State<EventEditProfileScreen> createState() => _EventEditProfileScreenState();
}

class _EventEditProfileScreenState extends State<EventEditProfileScreen> {
  final _viewModel = Get.find<EventManagerViewModel>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _categoryController = TextEditingController();
  final _currentPassController = TextEditingController(); // Added

  bool _isObscurePass = true;
  bool _isObscureConfirm = true;
  bool _isObscureCurrent = true;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() {
    final manager = _viewModel.currentManager.value;
    if (manager != null) {
      _nameController.text = manager.fullName ?? '';
      _emailController.text = manager.email ?? '';
      _phoneController.text = manager.phoneNumber ?? '';
      _dobController.text = manager.dateOfBirth ?? '';
      _categoryController.text = manager.category ?? '';
      _addressController.text = manager.address ?? '';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Using gallery as default
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const CustomAppBar(title: "Edit Profile", showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            // Profile Picture Picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (_viewModel.currentManager.value?.profilePicture !=
                                        null &&
                                    _viewModel
                                        .currentManager
                                        .value!
                                        .profilePicture!
                                        .isNotEmpty
                                ? NetworkImage(
                                        _viewModel
                                            .currentManager
                                            .value!
                                            .profilePicture!,
                                      )
                                      as ImageProvider
                                : const AssetImage(
                                    'assets/images/profile.png',
                                  )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 30.h,
                        width: 30.w,
                        decoration: const BoxDecoration(
                          color: AppColors.mainAppColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // ১. Full Name Field
            CustomTextField(controller: _nameController, hintText: 'Full name'),
            SizedBox(height: 16.h),

            // ২. E-mail address Field
            CustomTextField(
              controller: _emailController,
              hintText: 'E-mail address',
            ),
            SizedBox(height: 16.h),

            // Current Password (Required for password changes)
            CustomTextField(
              controller: _currentPassController,
              hintText: 'Current Password',
              isPassword: _isObscureCurrent,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscureCurrent
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: () =>
                    setState(() => _isObscureCurrent = !_isObscureCurrent),
              ),
            ),
            SizedBox(height: 16.h),

            // ৩. New Password Field
            CustomTextField(
              controller: _passController,
              hintText: 'New Password',
              isPassword: _isObscurePass,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscurePass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: () =>
                    setState(() => _isObscurePass = !_isObscurePass),
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
                  _isObscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: () =>
                    setState(() => _isObscureConfirm = !_isObscureConfirm),
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
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _dobController,
                  hintText: 'mm/dd/yyyy',
                  readOnly: true,
                  suffixIcon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey.shade400,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ৭. Category Field
            CustomTextField(
              controller: _categoryController,
              hintText: 'Category',
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
      child: Obx(
        () => ElevatedButton(
          onPressed: _viewModel.isLoading.value
              ? null
              : () {
                  _viewModel.updateProfile(
                    fullName: _nameController.text,
                    email: _emailController.text,
                    phoneNumber: _phoneController.text,
                    dateOfBirth: _dobController.text,
                    currentPassword: _currentPassController.text.isNotEmpty
                        ? _currentPassController.text
                        : null,
                    newPassword: _passController.text.isNotEmpty
                        ? _passController.text
                        : null,
                    confirmPassword: _confirmPassController.text.isNotEmpty
                        ? _confirmPassController.text
                        : null,
                    category: _categoryController.text.isNotEmpty
                        ? _categoryController.text
                        : null,
                    address: _addressController.text.isNotEmpty
                        ? _addressController.text
                        : null,
                    profilePicturePath: _selectedImage?.path,
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B4D3E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            elevation: 0,
          ),
          child: _viewModel.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
