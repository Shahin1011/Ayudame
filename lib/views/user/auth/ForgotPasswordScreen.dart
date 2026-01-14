import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../utils/constants.dart' hide AppColors;
import '../../../widgets/custom_loading_button.dart';
import '../../../widgets/user_custom_text_field.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final TextEditingController emailOrPhoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// Check Internet
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  final url = "${AppConstants.BASE_URL}/api/auth/forgot-password";

  /// Forgot Password API
  Future<void> forgotPassword(String email) async {
    if (!_formKey.currentState!.validate()) return;

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(
          AppRoutes.verificationCodeScreen,
          arguments: {"email": email},
        );
      } else {
        Get.snackbar(
          "Failed",
          data['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
      );
    } finally {
      setState(() => isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Title
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Description
              const Text(
                'Don\'t worry! Enter your registered email\nor phone number.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Email or Phone Label
              const Text(
                'Enter your email or phone number',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 8),

              CustomTextField1(
                textEditingController: emailOrPhoneController,
                hintText: 'Enter your e-mail or phone number',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: Colors.black38,
                ),
                fillColor: const Color(0xFFFFFFFF),
                fieldBorderColor: AppColors.grey,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email or phone number";
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 24),
              CustomLoadingButton(
                title: "Sent Reset Code",
                isLoading: isLoading,
                onTap: () {
                  forgotPassword(emailOrPhoneController.text.trim());
                },
              ),

              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Remembered your password? ',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.userlogin);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Need Help?',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
