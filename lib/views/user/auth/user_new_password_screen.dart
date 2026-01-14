import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:middle_ware/widgets/custom_loading_button.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../utils/constants.dart' hide AppColors;
import '../../../widgets/user_custom_text_field.dart';


class UserNewPasswordScreen extends StatefulWidget{

  @override
  State<UserNewPasswordScreen> createState() => _UserNewPasswordScreenState();
}

class _UserNewPasswordScreenState extends State<UserNewPasswordScreen> {

  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  final updatePassUrl = "${AppConstants.BASE_URL}/api/auth/set-new-password";

  Future<void> _setNewPassword ( String newPassword, String confirmPassword) async {
    if (!_formKey.currentState!.validate()) return;

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }


    final body = {
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    setState(() { isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse(updatePassUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          data["message"] ?? "updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.userlogin);

      } else {
        Get.snackbar("Error", data['message'] ?? "Login failed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      setState(() { isLoading = false; });
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
          'Update Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              Text(
                'Set a new password',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 0.h),
              Text(
                'Please set a new password for your account to \ncontinue',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24.h),

              CustomTextField1(
                textEditingController: newPassController,
                hintText: 'Password',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: Colors.black38,
                ),
                isPassword: true,
                fillColor: const Color(0xFFFFFFFF),
                fieldBorderColor: AppColors.grey,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a new password";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 18.h),

              CustomTextField1(
                textEditingController: confirmPassController,
                hintText: 'Confirm Password',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: Colors.black38,
                ),
                isPassword: true,
                fillColor: const Color(0xFFFFFFFF),
                fieldBorderColor: AppColors.grey,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please re-enter your password";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  } else if (value != newPassController.text) {
                    return "Password mismatch";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),

              CustomLoadingButton(
                title: "Update password",
                isLoading: isLoading,
                onTap: (){
                  _setNewPassword( newPassController.text.trim(), confirmPassController.text.trim());
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}