import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/routes/app_routes.dart';
import '../../../utils/constants.dart';
import 'package:middle_ware/services/api_service.dart';
import '../../../widgets/custom_loading_button.dart';

class ProviderForgotPasswordScreen extends StatefulWidget {
  const ProviderForgotPasswordScreen({super.key});

  @override
  State<ProviderForgotPasswordScreen> createState() =>
      _ProviderForgotPasswordScreenState();
}

class _ProviderForgotPasswordScreenState
    extends State<ProviderForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  final String _forgotPasswordUrl =
      "${ApiService.BASE_URL}/api/providers/forgot-password";

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    if (!await _hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_forgotPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _emailController.text.trim(),
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          data["message"] ?? "OTP has been sent to your email.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(
          AppRoutes.providerOtp,
          arguments: {"email": _emailController.text.trim()},
        );
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Request failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
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
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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

            const SizedBox(height: 8),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email or phone',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  size: 20,
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1C5941)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your email";
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            CustomLoadingButton(
              title: "Send Reset Code",
              isLoading: _isLoading,
              onTap: _sendResetCode,
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
                          Get.toNamed(AppRoutes.providerLogin);
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
