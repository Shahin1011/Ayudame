import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/provider/auth/provider_otp_verification_for_signup.dart';
import 'package:middle_ware/widgets/custom_loading_button.dart';
import '../../../utils/constants.dart' hide AppColors;
import 'package:middle_ware/views/provider/auth/provider_otp_verification_for_signup.dart';

class SignUpProviderScreen extends StatefulWidget {
  const SignUpProviderScreen({Key? key}) : super(key: key);

  @override
  State<SignUpProviderScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _occupationController = TextEditingController();
  final _referenceIdController = TextEditingController();

  File? _idCardFront;
  File? _idCardBack;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final String _registerApiUrl = "${AppConstants.BASE_URL}/api/providers/register";

  String? _imageSubtypeForPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'jpeg';
      case 'png':
        return 'png';
      case 'webp':
        return 'webp';
      default:
        return null;
    }
  }

  Future<void> _pickImage(bool isFront) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isFront) {
          _idCardFront = File(image.path);
        } else {
          _idCardBack = File(image.path);
        }
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _occupationController.dispose();
    _referenceIdController.dispose();
    super.dispose();
  }

  Future<void> _registerProvider() async {
    if (!_formKey.currentState!.validate()) return;

    if (_idCardFront == null || _idCardBack == null) {
      Get.snackbar(
        "Missing ID",
        "Please upload both front and back of your ID card.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (!await _hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }

    final frontSubtype = _imageSubtypeForPath(_idCardFront!.path);
    final backSubtype = _imageSubtypeForPath(_idCardBack!.path);
    if (frontSubtype == null || backSubtype == null) {
      Get.snackbar(
        "Invalid Format",
        "Only JPG, JPEG, PNG, or WEBP files are allowed.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_registerApiUrl),
      );

      request.fields['fullName'] = _fullNameController.text.trim();
      request.fields['email'] = _emailController.text.trim();
      request.fields['phoneNumber'] = _phoneController.text.trim();
      request.fields['password'] = _passwordController.text.trim();
      request.fields['confirmPassword'] = _confirmPasswordController.text.trim();

      final occupation = _occupationController.text.trim();
      if (occupation.isNotEmpty) {
        request.fields['occupation'] = occupation;
      }

      final referenceId = _referenceIdController.text.trim();
      if (referenceId.isNotEmpty) {
        request.fields['referenceId'] = referenceId;
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'idCardFront',
          _idCardFront!.path,
          filename: "id_card_front.$frontSubtype",
          contentType: MediaType('image', frontSubtype),
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'idCardBack',
          _idCardBack!.path,
          filename: "id_card_back.$backSubtype",
          contentType: MediaType('image', backSubtype),
        ),
      );

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      final data = json.decode(responseBody);

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        Get.snackbar(
          "Success",
          data["message"] ?? "OTP has been sent to your email.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.to(
          () => const ProviderOtpVerificationScreen(),
          arguments: {
            "email": _emailController.text.trim(),
          },
        );
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Signup failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Header
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'It only takes a minute to create your account',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),



                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      hintText:'Full name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your full name";
                      }
                      return null;
                    },
                  ),
                ),



                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'E-mail address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Phone number',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your phone number";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // ID Information
                const Text(
                  'ID Information*',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF424242),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Please upload real and valid information',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 12),

                // ID Card Images
                Row(
                  children: [
                    // ID Card Front
                    Expanded(
                      child: _buildIdCardPicker(
                        'ID Card Front',
                        _idCardFront,
                            () => _pickImage(true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // ID Card Back
                    Expanded(
                      child: _buildIdCardPicker(
                        'ID Card Back',
                        _idCardBack,
                            () => _pickImage(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Password

                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText:     'Password',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF9E9E9E),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),


                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText:  'Confirm Password',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF9E9E9E),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Occupation (Optional)
                const Text(
                  'Select occupation(Optional)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF424242),
                    fontWeight: FontWeight.w500,
                  ),
                ),


                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _occupationController,
                    decoration: const InputDecoration(
                      hintText:  'Your profession',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),

                // Reference ID (Optional)
                const Text(
                  'Reference ID(Optional)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF424242),
                    fontWeight: FontWeight.w500,
                  ),
                ),


                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _referenceIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText:   'Fill the number',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 32),

                CustomLoadingButton(
                  title: "Sign Up",
                  isLoading: _isLoading,
                  onTap: _registerProvider,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdCardPicker(String label, File? image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: image == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
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
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF757575),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            children: [
              Image.file(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
