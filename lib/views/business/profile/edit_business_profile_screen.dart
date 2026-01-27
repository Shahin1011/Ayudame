import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/viewmodels/business_auth_viewmodel.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class EditBusinessProfileScreen extends StatefulWidget {
  const EditBusinessProfileScreen({super.key});

  @override
  State<EditBusinessProfileScreen> createState() =>
      _EditBusinessProfileScreenState();
}

class _EditBusinessProfileScreenState extends State<EditBusinessProfileScreen> {
  final BusinessAuthViewModel _viewModel = Get.find<BusinessAuthViewModel>();

  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _locationController;
  late TextEditingController _aboutController;

  File? _logoFile;
  File? _coverFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final business = _viewModel.businessProfile.value;
    _nameController = TextEditingController(text: business?.businessName ?? "");
    _categoryController = TextEditingController(
      text: business?.businessType ?? "",
    );
    _locationController = TextEditingController(text: business?.address ?? "");
    _aboutController = TextEditingController(text: business?.description ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isLogo) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isLogo) {
          _logoFile = File(image.path);
        } else {
          _coverFile = File(image.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      appBar: const CustomAppBar(title: "Edit Business Profile"),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business cover photo',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () => _pickImage(false),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: _coverFile != null
                              ? Image.file(
                                  _coverFile!,
                                  height: 160.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : (_viewModel.businessProfile.value?.coverPhoto !=
                                        null &&
                                    _viewModel
                                        .businessProfile
                                        .value!
                                        .coverPhoto!
                                        .startsWith('http'))
                              ? Image.network(
                                  _viewModel.businessProfile.value!.coverPhoto!,
                                  height: 160.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Image.asset(
                                    'assets/images/b_cover.png',
                                    height: 160.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/b_cover.png',
                                  height: 160.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  _input('Business name', _nameController),
                  _input('Business category', _categoryController),
                  _input('Business location', _locationController),
                  _input('About', _aboutController, maxLines: 4),

                  SizedBox(height: 12.h),
                  Text('Business photo', style: TextStyle(fontSize: 12.sp)),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () => _pickImage(true),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: _logoFile != null
                              ? Image.file(
                                  _logoFile!,
                                  height: 120.h,
                                  width: 120.h,
                                  fit: BoxFit.cover,
                                )
                              : (_viewModel.businessProfile.value?.logo !=
                                        null &&
                                    _viewModel.businessProfile.value!.logo!
                                        .startsWith('http'))
                              ? Image.network(
                                  _viewModel.businessProfile.value!.logo!,
                                  height: 120.h,
                                  width: 120.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Image.asset(
                                    'assets/images/b_logo.png',
                                    height: 120.h,
                                    width: 120.h,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/b_logo.png',
                                  height: 120.h,
                                  width: 120.h,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C5941),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: _viewModel.isLoading.value
                          ? null
                          : () {
                              _viewModel.updateBusinessProfile(
                                businessName: _nameController.text.trim(),
                                businessCategory: _categoryController.text
                                    .trim(),
                                businessAddress: _locationController.text
                                    .trim(),
                                description: _aboutController.text.trim(),
                                businessLogoPath: _logoFile?.path,
                                businessCoverPath: _coverFile?.path,
                              );
                            },
                      child: _viewModel.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            if (_viewModel.isLoading.value)
              Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp)),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}
