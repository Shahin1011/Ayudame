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
  final confirmNewPasswordController = TextEditingController();

  final BusinessAuthService _authService = BusinessAuthService();

  // Observable states
  var isLoading = false.obs;
  var currentBusiness = Rxn<BusinessModel>();
  var businessProfile = Rxn<BusinessModel>();
  var isLoggedIn = false.obs;
  var rememberMe = false.obs;
  var faqs = <dynamic>[].obs;
  var privacyPolicy = Rxn<Map<String, dynamic>>();
  var termsConditions = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
    getBusinessInfo();
    getBusinessProfile();
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
        final ownerName = await StorageService.getUserName();

        if (businessId != null) {
          currentBusiness.value = BusinessModel(
            id: businessId,
            email: email,
            ownerName: ownerName,
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
      String? email;
      String? phone;

      if (contact.contains('@')) {
        email = contact;
      } else {
        phone = contact;
      }

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
        dob: dob,
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
        "Please enter your email or phone",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      String input = forgotEmailController.text.trim();
      String? email;
      String? phone;

      if (input.contains('@')) {
        email = input;
      } else {
        phone = input;
      }

      final response = await _authService.sendOtp(email: email, phone: phone);

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
      String input = forgotEmailController.text.trim();
      String? email;
      String? phone;

      if (input.contains('@')) {
        email = input;
      } else {
        phone = input;
      }

      final response = await _authService.verifyOtp(
        email: email,
        phone: phone,
        otp: verificationCodeController.text.trim(),
      );

      Get.snackbar(
        "Success",
        response['message'] ?? "Code verified successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.toNamed(AppRoutes.businessResetPassword);
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
    if (newPasswordController.text.isEmpty ||
        confirmNewPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      String input = forgotEmailController.text.trim();
      String? email;
      String? phone;

      if (input.contains('@')) {
        email = input;
      } else {
        phone = input;
      }

      final response = await _authService.resetPassword(
        email: email,
        phone: phone,
        otp: verificationCodeController.text.trim(),
        newPassword: newPasswordController.text,
        confirmPassword: confirmNewPasswordController.text,
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

  /// Update Business Profile
  Future<void> updateProfile({
    required String fullName,
    required String email,
    String? phoneNumber,
    String? occupation,
    String? dateOfBirth,
    String? profilePicturePath,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.updateProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        occupation: occupation,
        dateOfBirth: dateOfBirth,
        profilePicturePath: profilePicturePath,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      // Refresh business info
      await getBusinessInfo();

      // Update Local Storage with new data
      final business = currentBusiness.value;
      if (business != null) {
        if (business.email != null) {
          await StorageService.saveUserEmail(business.email!);
        }
        if (business.ownerName != null) {
          await StorageService.saveUserName(business.ownerName!);
        }
      }

      Get.snackbar(
        "Success",
        response['message'] ?? "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back(); // Go back from edit screen
    } catch (e) {
      debugPrint("❌ Profile Update Viewmodel Error: $e");
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

  /// Get Business Profile (Entity specifics)
  Future<void> getBusinessProfile() async {
    isLoading.value = true;
    try {
      final profileData = await _authService.getBusinessProfile();
      businessProfile.value = BusinessModel.fromJson(profileData);
      debugPrint(
        "✅ Loaded business profile: ${businessProfile.value?.businessName}",
      );
    } catch (e) {
      debugPrint("❌ Error loading business profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update Business Profile (Entity specifics)
  Future<void> updateBusinessProfile({
    required String businessName,
    required String businessCategory,
    required String businessAddress,
    required String description,
    String? businessLogoPath,
    String? businessCoverPath,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.updateBusinessProfile(
        businessName: businessName,
        businessCategory: businessCategory,
        businessAddress: businessAddress,
        description: description,
        businessLogoPath: businessLogoPath,
        businessCoverPath: businessCoverPath,
      );

      // Refresh both
      await getBusinessProfile();
      await getBusinessInfo();

      Get.snackbar(
        "Success",
        response['message'] ?? "Business profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back(); // Go back from edit screen
    } catch (e) {
      debugPrint("❌ Business Profile Update ViewModel Error: $e");
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

  /// Get FAQs
  Future<void> getFaqs() async {
    isLoading.value = true;
    try {
      final data = await _authService.getFaqs();
      faqs.assignAll(data);
      debugPrint("✅ Loaded ${faqs.length} FAQs");
    } catch (e) {
      debugPrint("❌ Error loading FAQs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Get Privacy Policy
  Future<void> getPrivacyPolicy() async {
    isLoading.value = true;
    try {
      final data = await _authService.getPrivacyPolicy();
      privacyPolicy.value = data;
      debugPrint("✅ Loaded privacy policy");
    } catch (e) {
      debugPrint("❌ Error loading privacy policy: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Get Terms and Conditions
  Future<void> getTermsConditions() async {
    isLoading.value = true;
    try {
      final data = await _authService.getTermsConditions();
      termsConditions.value = data;
      debugPrint("✅ Loaded terms and conditions");
    } catch (e) {
      debugPrint("❌ Error loading terms and conditions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  var stats = Rxn<Map<String, dynamic>>();

  /// Get Stats
  Future<void> getStats() async {
    // Don't set full page loading for stats as it's part of dashboard
    try {
      final data = await _authService.getStats();
      stats.value = data;
      debugPrint("✅ Loaded stats: $data");
    } catch (e) {
      debugPrint("❌ Error loading stats: $e");
    }
  }

  var activities = Rxn<List<dynamic>>();

  /// Get Activities
  Future<void> getActivities() async {
    try {
      final data = await _authService.getActivities();
      activities.value = data;
      debugPrint("✅ Loaded activities: ${data.length} items");
    } catch (e) {
      debugPrint("❌ Error loading activities: $e");
    }
  }

  /// Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      Get.snackbar(
        "Success",
        response['message'] ?? "Password changed successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear password fields logic could be here but controllers are local to edit screen usually
    } catch (e) {
      debugPrint("❌ Change Password ViewModel Error: $e");
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

  /// Delete Account
  Future<void> deleteAccount() async {
    final businessId = currentBusiness.value?.id;
    if (businessId == null) {
      Get.snackbar(
        "Error",
        "Business ID not found",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.deleteAccount(businessId);

      // Clear data and storage
      await StorageService.clearAll();
      currentBusiness.value = null;
      isLoggedIn.value = false;

      // Navigate to login
      Get.offAllNamed(AppRoutes.businessLogin);

      Get.snackbar(
        "Success",
        response['message'] ?? "Account deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("❌ Delete Account ViewModel Error: $e");
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
    confirmNewPasswordController.dispose();
    super.onClose();
  }
}
