import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../../viewmodels/business_auth_viewmodel.dart';
import '../../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _viewModel = Get.find<BusinessAuthViewModel>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _selectedImage;
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _obscure3 = true;

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() {
    final business = _viewModel.currentBusiness.value;
    if (business != null) {
      _nameController.text = business.ownerName ?? '';
      _emailController.text = business.email ?? '';
      _phoneController.text = business.phone ?? '';
      _dobController.text = business.dateOfBirth ?? '';
      _occupationController.text = business.occupation ?? '';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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

  Future<void> _handleSave() async {
    // 1. Update Password if fields are provided
    if (_currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      await _viewModel.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      // Clear password fields after success (optional, or handle in viewmodel success callback)
      if (!_viewModel.isLoading.value) {
        // Basic check if error didn't keep loading state or throw
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    }

    // 2. Update Profile Info
    // Only call if there are changes to profile fields to avoid unnecessary API calls if just password changed
    // For now, we'll assume we always want to ensure profile data is up to date or user clicked save intending to save all.
    // However, if password failed, we might want to stop. But let's try to save profile too.

    await _viewModel.updateProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      occupation: _occupationController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      profilePicturePath: _selectedImage?.path,
      // Passwords are handled by separate API now, so don't pass them to updateProfile unless backend still accepts them optionally
      // but USER gave specific endpoint for change password.
      // We will NULL them here to ignore in updateProfile logic
      currentPassword: null,
      newPassword: null,
      confirmPassword: null,
    );
  }

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
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) as ImageProvider
                        : _viewModel.currentBusiness.value?.logo != null &&
                              _viewModel.currentBusiness.value!.logo!
                                  .startsWith('http')
                        ? NetworkImage(_viewModel.currentBusiness.value!.logo!)
                        : const AssetImage('assets/images/profile.png')
                              as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: _buildCameraIcon(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(height: 20.h),
            _buildFieldLabel('Full Name'),
            CustomTextField(controller: _nameController, hintText: 'Name'),
            SizedBox(height: 15.h),
            _buildFieldLabel('E-mail address'),
            CustomTextField(
              controller: _emailController,
              hintText: 'E-mail address',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 15.h),
            _buildFieldLabel('Phone number'),
            CustomTextField(
              controller: _phoneController,
              hintText: 'Phone number',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 15.h),
            _buildFieldLabel('Date of birth'),
            CustomTextField(
              controller: _dobController,
              hintText: 'YYYY-MM-DD',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_month, color: Colors.grey),
                onPressed: () => _selectDate(context),
              ),
              readOnly: true,
            ),
            SizedBox(height: 15.h),
            _buildFieldLabel('Select occupation'),
            CustomTextField(
              controller: _occupationController,
              hintText: 'Doctor',
            ),
            SizedBox(height: 15.h),
            _buildFieldLabel('Current Password'),
            _buildPasswordField(
              _currentPasswordController,
              _obscure1,
              (v) => setState(() => _obscure1 = v),
            ),
            SizedBox(height: 15.h),
            _buildFieldLabel('New Password'),
            _buildPasswordField(
              _newPasswordController,
              _obscure2,
              (v) => setState(() => _obscure2 = v),
            ),
            SizedBox(height: 15.h),
            _buildFieldLabel('Confirm Password'),
            _buildPasswordField(
              _confirmPasswordController,
              _obscure3,
              (v) => setState(() => _obscure3 = v),
            ),
            SizedBox(height: 30.h),
            _buildSaveButton('Save Changes'),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      label,
      style: GoogleFonts.montserrat(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildPasswordField(
    TextEditingController controller,
    bool obscure,
    Function(bool) toggle,
  ) => CustomTextField(
    controller: controller,
    isPassword: obscure,
    hintText: '********',
    suffixIcon: IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: Colors.grey,
      ),
      onPressed: () => toggle(!obscure),
    ),
  );

  Widget _buildCameraIcon() => Container(
    padding: EdgeInsets.all(4.w),
    decoration: const BoxDecoration(
      color: Color(0xFF1B4D3E),
      shape: BoxShape.circle,
    ),
    child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18.sp),
  );

  Widget _buildSaveButton(String text) => Obx(() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: _viewModel.isLoading.value ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B4D3E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: _viewModel.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
              ),
      ),
    );
  });
}
