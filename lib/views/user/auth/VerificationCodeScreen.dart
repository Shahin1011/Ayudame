import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:middle_ware/widgets/custom_loading_button.dart';
import '../../../core/routes/app_routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/theme/app_colors.dart';
import '../../../utils/constants.dart' hide AppColors;
import 'package:get/get.dart';
import 'package:middle_ware/services/api_service.dart';


class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {

  late String email;
  bool isLoading = false;
  final TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    email = args["email"];
  }



  Future<bool> verifyUser(String email, String code) async {
    final url = "${ApiService.BASE_URL}/api/auth/verify-otp";

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return false;
    }

    final body = {'email': email, 'otp': code};

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {

        Get.snackbar(
          "Success",
          data["message"] ?? "OTP Verified successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(AppRoutes.userNewPasswordScreen,);

        return true;
      } else {
        String message = "Code wrong";
        try {
          final body = jsonDecode(response.body);
          message = body['message'] ?? message;
        } catch (_) {}
        Get.snackbar("Failed", message);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  @override
  void dispose() {
    pinController.dispose();
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'OTP Verification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
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
                "We've sent a 6-digit code to $email",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
        
              PinCodeEnter(context),
        
        
              const SizedBox(height: 20),
        
              // Paste Code Link
              TextButton(
                onPressed: () async {
                  final data = await Clipboard.getData('text/plain');
                  if (data != null && data.text != null) {
                    final code = data.text!.replaceAll(RegExp(r'[^0-9]'), '');
                    if (code.length >= 6) {
                      pinController.text = code.substring(0, 6);
                    } else {
                      pinController.text = code;
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
        
              CustomLoadingButton(
                title: "Verify",
                isLoading: isLoading,
                onTap: (){
                  final otp = pinController.text.trim();
                  verifyUser(email, otp);
                },
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
                  Get.toNamed(AppRoutes.userlogin);
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
      ),
    );
  }

  PinCodeTextField PinCodeEnter(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      enableActiveFill: true,
      showCursor: true,
      cursorColor: AppColors.mainAppColor,
      obscureText: false,
      textStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.mainAppColor,
        //fontFamily: "Satoshi",
      ),
      controller: pinController,
      animationType: AnimationType.scale,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        borderWidth: 0.5,
        fieldHeight: 45.h,
        fieldWidth: 45.w,
        fieldOuterPadding: EdgeInsets.symmetric(horizontal: 4),
        inactiveColor: Color(0xFF5E5E5E),
        inactiveFillColor: AppColors.white,
        selectedFillColor: Colors.white,
        disabledColor: AppColors.white,
        activeFillColor: Colors.white,
        selectedColor: AppColors.mainAppColor,
        activeColor: AppColors.mainAppColor,
      ),
      hintCharacter: '-',
      animationDuration: const Duration(milliseconds: 100),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onChanged: (value) {
        // _controller.otpCode.value = value;
      },
      onCompleted: (value) {
        print("Entered Code: $value");
      },
    );
  }

}
