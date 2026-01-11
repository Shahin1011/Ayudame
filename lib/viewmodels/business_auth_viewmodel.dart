import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/business_model.dart';
import '../services/business_auth_service.dart';
import '../services/storage_service.dart';
import '../core/routes/app_routes.dart';

class BusinessAuthViewModel extends GetxController {
  // Controllers for Login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Controllers for Sign Up
  final businessNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final businessTypeController = TextEditingController();

  // Controllers for Forgot Password
  final forgotEmailController = TextEditingController();
  final verificationCodeController = TextEditingController();
  final newPasswordController = TextEditingController();

  final BusinessAuthService _authService = BusinessAuthService();

  // Observable states
  var isLoading = false.obs;
  var currentBusiness = Rxn<BusinessModel>();
  var isLoggedIn = false.obs;
  var rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  /// Check if business user is logged in
  Future<void> checkAuthStatus() async {
    try {
      final token = await StorageService.getToken();
      final role = await StorageService.getUserRole();

      if (token != null && token.isNotEmpty && role == 'business') {
        isLoggedIn.value = true;

        // Load business data from storage
        final businessId = await StorageService.getBusinessId();
        final email = await StorageService.getUserEmail();
        final businessName = await StorageService.getUserName();

        if (businessId != null) {
          currentBusiness.value = BusinessModel(
            id: businessId,
            email: email,
            businessName: businessName,
          );
        }
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      debugPrint("❌ Check Auth Status Error: $e");
      isLoggedIn.value = false;
    }
  }

  /// Business Login
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter email and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    debugPrint("🔐 Attempting Business Login...");
    debugPrint("📧 Email: ${emailController.text.trim()}");

    isLoading.value = true;

    try {
      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      debugPrint("✅ Login Response: ${response.success}");
      debugPrint("📝 Message: ${response.message}");

      if (response.success && response.data != null) {
        // Store token and business data
        await StorageService.saveToken(response.data!.token);
        await StorageService.saveUserId(response.data!.business.id ?? '');
        await StorageService.saveUserEmail(response.data!.business.email ?? '');
        await StorageService.saveUserName(
          response.data!.business.businessName ?? '',
        );
        await StorageService.saveUserRole('business');
        await StorageService.saveBusinessId(response.data!.business.id ?? '');

        debugPrint("💾 Token saved");
        debugPrint("👤 Business ID: ${response.data!.business.id}");

        // Update current business
        currentBusiness.value = response.data!.business;
        isLoggedIn.value = true;

        // Show success message
        Get.snackbar(
          "Success",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to business home
        Get.offNamed(AppRoutes.businessHome);
      } else {
        debugPrint("❌ Login failed: ${response.message}");
        Get.snackbar(
          "Error",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("❌ Login Exception: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Register from UI (Custom implementation for BusinessSignUpScreen)
  Future<void> registerFromUI({
    required String fullName,
    required String contact, // Email or Phone
    required String businessName,
    required String category,
    required String address,
    required String password,
    String? dob,
    String? occupation,
    String? referenceId,
    String? businessPhotoPath,
    String? idCardFrontPath,
    String? idCardBackPath,
  }) async {
    isLoading.value = true;

    try {
      // Determine if contact is email or phone
      String email = "";
      String phone = "";

      if (contact.contains('@')) {
        email = contact;
        // If phone is required by API but not provided in UI, we might need to handle it.
        // For now sending empty or maybe the same value if acceptable, strictly speaking API needs separate.
        phone = "0000000000"; // Placeholder or ask user to provide both
      } else {
        phone = contact;
        email = "$contact@placeholder.com"; // Placeholder if email required
      }

      // If the input contact looks like a phone and we have an email field requirement,
      // the current UI design is limited. We will try our best.
      // Ideally update UI to have both fields if API requires both.

      final response = await _authService.signUp(
        businessName: businessName,
        ownerName: fullName,
        email: email,
        phone: phone,
        password: password,
        address: address,
        businessType: category,
        businessPhoto: businessPhotoPath,
        idCardFront: idCardFrontPath,
        idCardBack: idCardBackPath,
        occupation: occupation,
        referenceId: referenceId,
      );

      if (response.success && response.data != null) {
        // Store token and business data
        await StorageService.saveToken(response.data!.token);
        await StorageService.saveUserId(response.data!.business.id ?? '');
        await StorageService.saveUserEmail(response.data!.business.email ?? '');
        await StorageService.saveUserName(
          response.data!.business.businessName ?? '',
        );
        await StorageService.saveUserRole('business');
        await StorageService.saveBusinessId(response.data!.business.id ?? '');

        // Update current business
        currentBusiness.value = response.data!.business;
        isLoggedIn.value = true;

        Get.snackbar(
          "Success",
          "Account created successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to business home
        Get.offNamed(AppRoutes.businessHome);
      } else {
        Get.snackbar(
          "Error",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("❌ Registration Exception: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Business Sign Up (Default)
  Future<void> signUp() async {
    // ... existing implementation ...
    if (businessNameController.text.isEmpty ||
        ownerNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all required fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.signUp(
        businessName: businessNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        address: addressController.text.trim().isNotEmpty
            ? addressController.text.trim()
            : null,
        businessType: businessTypeController.text.trim().isNotEmpty
            ? businessTypeController.text.trim()
            : null,
      );

      if (response.success && response.data != null) {
        await StorageService.saveToken(response.data!.token);
        await StorageService.saveUserId(response.data!.business.id ?? '');
        await StorageService.saveUserEmail(response.data!.business.email ?? '');
        await StorageService.saveUserName(
          response.data!.business.businessName ?? '',
        );
        await StorageService.saveUserRole('business');
        await StorageService.saveBusinessId(response.data!.business.id ?? '');

        currentBusiness.value = response.data!.business;
        isLoggedIn.value = true;

        Get.snackbar(
          "Success",
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed(AppRoutes.businessHome);
      } else {
        Get.snackbar(
          "Error",
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Send OTP
  Future<void> sendOtp() async {
    if (forgotEmailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.sendOtp(
        email: forgotEmailController.text.trim(),
      );

      Get.snackbar(
        "Success",
        response['message'] ?? "Verification code sent to your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to verification screen
      Get.toNamed(AppRoutes.businessOtp);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP
  Future<void> verifyOtp() async {
    if (verificationCodeController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter verification code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.verifyOtp(
        email: forgotEmailController.text.trim(),
        otp: verificationCodeController.text.trim(),
      );

      Get.snackbar(
        "Success",
        response['message'] ?? "Code verified successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // You can navigate to reset password screen here if needed
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset Password
  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter new password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.resetPassword(
        email: forgotEmailController.text.trim(),
        otp: verificationCodeController.text.trim(),
        newPassword: newPasswordController.text,
      );

      Get.snackbar(
        "Success",
        response['message'] ?? "Password reset successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to login
      Get.offNamed(AppRoutes.businessLogin);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get Business Info
  Future<void> getBusinessInfo() async {
    try {
      final businessData = await _authService.getBusinessInfo();
      currentBusiness.value = BusinessModel.fromJson(businessData);
      debugPrint(
        "✅ Loaded business info: ${currentBusiness.value?.businessName}",
      );
    } catch (e) {
      debugPrint("❌ Error loading business info: $e");
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await StorageService.clearAll();
      currentBusiness.value = null;
      isLoggedIn.value = false;

      Get.offAllNamed(AppRoutes.businessLogin);

      Get.snackbar(
        "Success",
        "Logged out successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("❌ Sign Out Error: $e");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    businessNameController.dispose();
    ownerNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    businessTypeController.dispose();
    forgotEmailController.dispose();
    verificationCodeController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
