import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'dart:io';
import '../../../viewmodels/business_auth_viewmodel.dart';

class BusinessSignUpScreen extends StatefulWidget {
  const BusinessSignUpScreen({Key? key}) : super(key: key);

  @override
  State<BusinessSignUpScreen> createState() => _BusinessSignUpScreenState();
}

class _BusinessSignUpScreenState extends State<BusinessSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final BusinessAuthViewModel _authViewModel = Get.put(BusinessAuthViewModel());

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessCategoryController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _occupationController = TextEditingController();
  final _referenceIdController = TextEditingController();

  File? _businessPhoto;
  File? _idCardFront;
  File? _idCardBack;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailPhoneController.dispose();
    _dobController.dispose();
    _businessNameController.dispose();
    _businessCategoryController.dispose();
    _businessAddressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _occupationController.dispose();
    _referenceIdController.dispose();
    super.dispose();
  }

  // Image Picking Logic
  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'business') _businessPhoto = File(image.path);
        if (type == 'front') _idCardFront = File(image.path);
        if (type == 'back') _idCardBack = File(image.path);
      });
    }
  }

  // Date Picking Logic
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1C5941),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor, // AppColors.bgColor
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'It only takes a minute to create your account',
                  style: TextStyle(fontSize: 13, color: Color(0xFF5E5E5E)),
                ),
                const SizedBox(height: 25),

                // Full Name
                _buildTextField(
                  _fullNameController,
                  'Full name',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter full name';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Email/Phone
                _buildTextField(
                  _emailPhoneController,
                  'E-mail address or phone number',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter email or phone';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date of Birth
                const Text(
                  'Date of birth',
                  style: TextStyle(fontSize: 14, fontFamily: "Inter", fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      _dobController,
                      'dd/mm/yy',
                      suffixIcon: Icons.calendar_month_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please select date of birth';
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Business Details
                _buildLabelledField(
                  'Business name',
                  _businessNameController,
                  'Enter your business name',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter business name';
                    return null;
                  },
                ),
                _buildLabelledField(
                  'Business category',
                  _businessCategoryController,
                  'Enter business category',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter business category';
                    return null;
                  },
                ),
                _buildLabelledField(
                  'Business address',
                  _businessAddressController,
                  'Enter business address',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter business address';
                    return null;
                  },
                ),

                // Business Photo
                const Text(
                  'Business photo',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                _buildImagePickerBox(
                  'Upload',
                  _businessPhoto,
                  () => _pickImage('business'),
                  isLarge: true,
                ),
                const SizedBox(height: 20),

                // ID Information
                const Text(
                  'ID Information*',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Please upload real and valid information',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF5E5E5E)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildImagePickerBox(
                        'ID Card Front',
                        _idCardFront,
                        () => _pickImage('front'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildImagePickerBox(
                        'ID Card Back',
                        _idCardBack,
                        () => _pickImage('back'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Passwords
                _buildPasswordField(
                  _passwordController,
                  'Password',
                  _obscurePassword,
                  () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter password';
                    if (value.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildPasswordField(
                  _confirmPasswordController,
                  'Confirm Password',
                  _obscureConfirmPassword,
                  () {
                    setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please confirm password';
                    if (value != _passwordController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Optional Fields
                _buildLabelledField(
                  'Select occupation(Optional)',
                  _occupationController,
                  'Your profession',
                ),
                _buildLabelledField(
                  'Reference ID(Optional)',
                  _referenceIdController,
                  'Fill the number',
                  isNumber: true,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 30),

                // Sign Up Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _authViewModel.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                if (_businessPhoto == null) {
                                  Get.snackbar(
                                    "Required",
                                    "Please upload a business photo",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                if (_idCardFront == null ||
                                    _idCardBack == null) {
                                  Get.snackbar(
                                    "Required",
                                    "Please upload both sides of your ID Card",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                _authViewModel.registerFromUI(
                                  fullName: _fullNameController.text.trim(),
                                  contact: _emailPhoneController.text.trim(),
                                  businessName: _businessNameController.text
                                      .trim(),
                                  category: _businessCategoryController.text
                                      .trim(),
                                  address: _businessAddressController.text
                                      .trim(),
                                  password: _passwordController.text,
                                  dob: _dobController.text.trim(),
                                  occupation: _occupationController.text.trim(),
                                  referenceId: _referenceIdController.text
                                      .trim(),
                                  businessPhotoPath: _businessPhoto?.path,
                                  idCardFrontPath: _idCardFront?.path,
                                  idCardBackPath: _idCardBack?.path,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C5941),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _authViewModel.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Sign UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    IconData? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8D8D8)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          fillColor: Color(0xFFFAFAFA),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBFBFBF), fontSize: 14),
          border: InputBorder.none,
          errorStyle: const TextStyle(height: 0.1, fontSize: 10),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Color(0xFFBFBFBF), size: 20)
              : null,
        ),
      ),
    );
  }

  Widget _buildLabelledField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontFamily: "Inter", fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller,
          hint,
          keyboardType: isNumber ? TextInputType.number : keyboardType,
          validator: validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    bool obscure,
    VoidCallback toggle, {
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          errorStyle: const TextStyle(height: 0.1, fontSize: 10),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerBox(
    String label,
    File? image,
    VoidCallback onTap, {
    bool isLarge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isLarge ? 130 : 110,
        width: isLarge ? 130 : double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD1D1D1),
            style: BorderStyle.solid,
          ),
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C5941),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
      ),
    );
  }
}
