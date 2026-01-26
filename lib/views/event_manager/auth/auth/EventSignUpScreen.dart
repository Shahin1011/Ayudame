import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:middle_ware/core/theme/app_colors.dart';
import '../../../../viewmodels/event_manager_viewmodel.dart';

class EventSignUpScreen extends StatefulWidget {
  const EventSignUpScreen({super.key});

  @override
  State<EventSignUpScreen> createState() => _EventSignUpScreenState();
}

class _EventSignUpScreenState extends State<EventSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = Get.put(EventManagerViewModel());

  // Controllers based on the image provided
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _dobController = TextEditingController();

  String? _selectedIdType;
  File? _idCardFront;
  File? _idCardBack;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'front') _idCardFront = File(image.path);
        if (type == 'back') _idCardBack = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'It only takes a minute to create your account',
                  style: TextStyle(fontSize: 14, color: Color(0xFF737373)),
                ),
                const SizedBox(height: 30),

                // 1. Full Name
                _buildTextField(_fullNameController, 'Full name'),
                const SizedBox(height: 16),

                // 2. Email Address
                _buildTextField(_emailController, 'E-mail address'),
                const SizedBox(height: 16),

                // 3. Password
                _buildTextField(
                  _passwordController,
                  'Password',
                  obscure: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Confirm Password
                _buildTextField(
                  _confirmPasswordController,
                  'Confirm Password',
                  obscure: _obscureConfirmPassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Phone Number
                _buildTextField(
                  _phoneController,
                  'Phone number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // 6. Select ID Type (Dropdown)
                _buildDropdownField(),
                const SizedBox(height: 16),

                // 7. Identification Number
                _buildTextField(_idNumberController, 'Identification Number'),
                const SizedBox(height: 20),

                // 8. Date of Birth
                const Text(
                  'Date of birth',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  _dobController,
                  'dd/mm/yy',
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      _dobController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                  suffix: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 24),

                // 9. ID Information Section
                const Text(
                  'ID Information*',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Please upload real and valid information',
                  style: TextStyle(fontSize: 12, color: Color(0xFF737373)),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildDashedUploadBox(
                            _idCardFront,
                            () => _pickImage('front'),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ID Card Front',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF737373),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildDashedUploadBox(
                            _idCardBack,
                            () => _pickImage('back'),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ID Card Back',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF737373),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // 10. Sign Up Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _viewModel.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                // Additional validation for required fields
                                if (_dobController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Please select date of birth",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                if (_selectedIdType == null ||
                                    _selectedIdType!.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Please select ID type",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                if (_idNumberController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Please enter identification number",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                if (_idCardFront == null ||
                                    _idCardBack == null) {
                                  Get.snackbar(
                                    "Error",
                                    "Please upload both sides of your ID card",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                _viewModel.register(
                                  fullName: _fullNameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phoneNumber: _phoneController.text.trim(),
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                  dateOfBirth: _dobController.text.trim(),
                                  idType: _selectedIdType ?? '',
                                  identificationNumber: _idNumberController.text
                                      .trim(),
                                  idCardFrontPath: _idCardFront!.path,
                                  idCardBackPath: _idCardBack!.path,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF1C5941,
                        ), // Matching Dark Green
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: _viewModel.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Common Text Field Builder
  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD8D8D8)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hint';
          }
          if (hint.contains('E-mail') && !GetUtils.isEmail(value)) {
            return 'Please enter a valid email';
          }
          if (hint.contains('Password') && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          if (hint.contains('Confirm Password') &&
              value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Color(0xFF737373),
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: suffix,
          // Removed errorStyle height 0 to let user see why field is invalid
        ),
      ),
    );
  }

  // ID Type Dropdown
  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedIdType,
        hint: Text(
          "Select ID Type",
          style: TextStyle(
            color: Color(0xFF737373),
            fontFamily: "inter",
            fontSize: 14,
          ),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? "Required" : null,
        items: [
          DropdownMenuItem<String>(value: "nid", child: Text("NID")),
          DropdownMenuItem<String>(value: "passport", child: Text("Passport")),
          DropdownMenuItem<String>(
            value: "driving license",
            child: Text("Driving License"),
          ),
        ],
        onChanged: (newValue) => setState(() => _selectedIdType = newValue),
      ),
    );
  }

  // Dashed Upload Box for ID
  Widget _buildDashedUploadBox(File? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD1D1D1),
            style: BorderStyle.solid,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: file == null
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
                  ],
                )
              : Image.file(file, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
