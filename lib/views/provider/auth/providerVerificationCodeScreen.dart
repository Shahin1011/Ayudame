import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:middle_ware/services/api_service.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import 'package:middle_ware/views/provider/auth/provider_new_password_screen.dart';
import '../../../utils/constants.dart' hide AppColors;
import '../../../widgets/custom_loading_button.dart';

class ProviderVerificationCodeScreen extends StatefulWidget {
  const ProviderVerificationCodeScreen({super.key});

  @override
  State<ProviderVerificationCodeScreen> createState() => _ProviderVerificationCodeScreenState();
}

class _ProviderVerificationCodeScreenState extends State<ProviderVerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  late String _email;

  final String _verifyOtpUrl =
      "${ApiService.BASE_URL}/api/providers/verify-otp";

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    _email = args["email"] ?? "";
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join().trim();
    if (otp.length != 6) {
      Get.snackbar("Invalid Code", "Please enter the 6-digit code.");
      return;
    }

    if (!await _hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _email,
          "otp": otp,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resetToken =
            data['data']?['resetToken'] ??
            data['resetToken'] ??
            data['data']?['token'] ??
            data['token'];
        if (resetToken is! String || resetToken.isEmpty) {
          Get.snackbar(
            "Error",
            "Reset token missing from response.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        Get.snackbar(
          "Success",
          data["message"] ?? "OTP verified.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(
          () => const ProviderNewPasswordScreen(),
          arguments: {"resetToken": resetToken},
        );
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Verification failed",
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
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
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
          'Back to Login',
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
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Shield Icon
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFF1C5941),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 32,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            const Text(
              'Enter Verification Code',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              _email.isEmpty
                  ? 'We\'ve sent a 6-digit code to your email.'
                  : 'We\'ve sent a 6-digit code to $_email',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 46,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      }
                      if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Paste Code Link
            TextButton(
              onPressed: () async {
                final data = await Clipboard.getData('text/plain');
                if (data != null && data.text != null) {
                  final code = data.text!.replaceAll(RegExp(r'[^0-9]'), '');
                  for (int i = 0; i < code.length && i < 6; i++) {
                    _controllers[i].text = code[i];
                  }
                }
              },
              child: const Text(
                'Paste Code',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1C5941),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Verify Button
            CustomLoadingButton(
              title: "Verify",
              isLoading: _isLoading,
              onTap: _verifyOtp,
            ),

            const SizedBox(height: 20),

            // Didn't receive code text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Didn\'t receive the code? ',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1C5941),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Back to Login
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
                'Back to Login',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
