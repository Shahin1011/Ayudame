import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/provider/auth/LoginProviderScreen.dart';

class SignUpProviderScreen extends StatefulWidget {
  const SignUpProviderScreen({super.key});

  @override
  State<SignUpProviderScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _occupationController = TextEditingController();
  final _referenceIdController = TextEditingController();

  File? _idCardFront;
  File? _idCardBack;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final ImagePicker _picker = ImagePicker();

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
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _occupationController.dispose();
    _referenceIdController.dispose();
    super.dispose();
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
                    controller: _emailPhoneController,
                    decoration: const InputDecoration(
                      hintText: 'E-mail address or phone number',
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

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => LoginProviderScreen () );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C5941),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign UP',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
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