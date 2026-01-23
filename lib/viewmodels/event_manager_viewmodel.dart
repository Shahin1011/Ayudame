import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event_manager_model.dart';
import '../services/event_manager_service.dart';
import '../services/storage_service.dart';
import '../core/routes/app_routes.dart';

class EventManagerViewModel extends GetxController {
  final EventManagerService _authService = EventManagerService();

  // Observable states
  var isLoading = false.obs;
  var currentManager = Rxn<EventManagerModel>();
  var isLoggedIn = false.obs;

  // For forgot password flow
  var forgotPasswordEmail = ''.obs;
  var recoveryOtp = ''.obs;
  var privacyPolicyContent = ''.obs;
  var termsContent = ''.obs;
  var aboutUsContent = ''.obs;
  var faqList = <Map<String, String>>[].obs;

  /// Send OTP for password recovery
  Future<void> sendOtp(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.sendOtp(email);
      forgotPasswordEmail.value = email;

      Get.snackbar(
        "Success",
        response['message'] ?? "OTP sent successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.toNamed(AppRoutes.eventOtp);
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

  /// Verify OTP
  Future<void> verifyOtp(String otp) async {
    if (otp.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter a valid 6-digit OTP",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.verifyOtp(
        forgotPasswordEmail.value,
        otp,
      );
      recoveryOtp.value = otp;

      Get.snackbar(
        "Success",
        response['message'] ?? "OTP verified successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to Reset Password Screen (Assuming we create this route)
      // We will need to create this route and screen
      Get.toNamed(AppRoutes.eventResetPassword);
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

  /// Reset Password
  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter new password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.resetPassword(
        email: forgotPasswordEmail.value,
        otp: recoveryOtp.value,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      Get.snackbar(
        "Success",
        response['message'] ?? "Password reset successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(AppRoutes.eventLogin);
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

  /// Register a new event manager
  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required String dateOfBirth,
    required String idType,
    required String identificationNumber,
    required String idCardFrontPath,
    required String idCardBackPath,
  }) async {
    isLoading.value = true;
    try {
      debugPrint('🔍 Registration Data:');
      debugPrint('  fullName: $fullName');
      debugPrint('  email: $email');
      debugPrint('  phoneNumber: $phoneNumber');
      debugPrint('  dateOfBirth: $dateOfBirth');
      debugPrint('  idType: $idType');
      debugPrint('  identificationNumber: $identificationNumber');
      debugPrint('  idCardFrontPath: $idCardFrontPath');
      debugPrint('  idCardBackPath: $idCardBackPath');

      final manager = EventManagerModel(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        idType: idType,
        identificationNumber: identificationNumber,
      );

      final response = await _authService.register(
        manager: manager,
        password: password,
        confirmPassword: confirmPassword,
        idCardFrontPath: idCardFrontPath,
        idCardBackPath: idCardBackPath,
      );

      Get.snackbar(
        "Success",
        response['message'] ?? "Registration successful!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login or home depending on backend behavior
      // Usually after registration, we might need to verify OTP or just login
      Get.offNamed(AppRoutes.eventLogin);
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

  /// Login as an event manager
  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      final data = response['data'];
      final token = data?['accessToken'] ?? response['token'];

      if (token != null) {
        // Token is already saved by service, but we can verify or save again if needed
        // await StorageService.saveToken(token);
        await StorageService.saveUserRole('event_manager');

        if (data != null) {
          // Construct the model from the nested response
          var userData = data['user'] ?? {};
          var managerData = data['eventManager'] ?? {};

          // Merge data for the model
          Map<String, dynamic> mergedData = {
            ...userData,
            ...managerData,
            // Map fields that might have different names or need strictly lowercase/capital handling
            'id': userData['id'],
            'fullName': userData['fullName'],
            'email': userData['email'],
            'phoneNumber': userData['phoneNumber'],
            'userType': userData['userType'],
            'dateOfBirth': managerData['dateOfBirth'],
            'IdType':
                managerData['idType'], // Map lowercase idType from API to Capital IdType in Model
            'identificationNumber': managerData['identificationNumber'],
          };

          currentManager.value = EventManagerModel.fromJson(mergedData);

          await StorageService.saveUserName(
            currentManager.value?.fullName ?? '',
          );
          await StorageService.saveUserEmail(currentManager.value?.email ?? '');
          await StorageService.saveUserId(currentManager.value?.id ?? '');
        }

        isLoggedIn.value = true;

        Get.snackbar(
          "Success",
          response['message'] ?? "Login successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to event manager home
        Get.offNamed(AppRoutes.eventHome);
      }
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

  /// Logout event manager
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authService.logout();
      Get.snackbar(
        "Success",
        "Logged out successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Logged out locally. Server error: ${e.toString().replaceAll('Exception: ', '')}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      // ALWAYS clear local data and navigate out
      await StorageService.clearAll();
      currentManager.value = null;
      isLoggedIn.value = false;
      isLoading.value = false;

      Get.offAllNamed(AppRoutes.eventLogin);
    }
  }

  /// Fetch Profile
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _authService.getProfile();
      debugPrint("🔍 Profile API Response: $response");

      var data = response['data'];
      // Handle double nested data structure if possibly exists
      if (data != null && data is Map && data['data'] != null) {
        data = data['data'];
      }

      if (data != null) {
        // Based on new response structure: data.eventManager contains nested userId object
        // So we can just parse the eventManager object directly
        var managerData = data['eventManager'] ?? data;

        currentManager.value = EventManagerModel.fromJson(managerData);
        currentManager.refresh(); // Force Obx update

        // Update local storage too
        await StorageService.saveUserName(currentManager.value?.fullName ?? '');
        await StorageService.saveUserEmail(currentManager.value?.email ?? '');
        debugPrint(
          "✅ Profile state updated for: ${currentManager.value?.fullName}",
        );
      }
    } catch (e) {
      debugPrint("❌ Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update Profile
  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    String? dateOfBirth,
    String? profilePicturePath,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? newConfirmPassword,
    String? category,
    String? address,
    String? businessAddress,
    String? birthdate,
    String? idType,
    String? identificationNumber,
  }) async {
    // Validation
    if (newPassword != null &&
        newPassword.isNotEmpty &&
        newPassword != confirmPassword) {
      Get.snackbar(
        "Error",
        "New passwords do not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.updateProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        profilePicturePath: profilePicturePath,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        newConfirmPassword: newConfirmPassword,
        category: category,
        address: address,
        businessAddress: businessAddress,
        birthdate: birthdate,
        idType: idType,
        identificationNumber: identificationNumber,
      );

      Get.snackbar(
        "Success",
        response['message'] ?? "Profile updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh profile
      await fetchProfile();

      Get.back(); // Go back to profile info screen
    } catch (e) {
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      if (errorMsg.toLowerCase().contains("token") &&
          (errorMsg.toLowerCase().contains("expired") ||
              errorMsg.toLowerCase().contains("expaired"))) {
        Get.snackbar(
          "Session Expired",
          "Please login again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        await StorageService.clearAll();
        Get.offAllNamed(AppRoutes.eventLogin);
      } else {
        Get.snackbar(
          "Error",
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Account
  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      final response = await _authService.deleteAccount();

      Get.snackbar(
        "Success",
        response['message'] ?? "Account deleted successfully",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Clear local data and redirect
      await StorageService.clearAll();
      currentManager.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed(AppRoutes.eventLogin);
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

  /// Fetch Privacy Policy
  Future<void> fetchPrivacyPolicy() async {
    isLoading.value = true;
    try {
      final response = await _authService.getPrivacyPolicy();

      // Handle different possible response structures
      if (response['data'] != null && response['data']['content'] != null) {
        privacyPolicyContent.value = response['data']['content'];
      } else if (response['content'] != null) {
        privacyPolicyContent.value = response['content'];
      } else if (response['data'] is String) {
        privacyPolicyContent.value = response['data'];
      } else {
        privacyPolicyContent.value = "No privacy policy content available.";
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load privacy policy: ${e.toString().replaceAll('Exception: ', '')}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch Terms and Conditions
  Future<void> fetchTermsAndConditions() async {
    isLoading.value = true;
    try {
      final response = await _authService.getTermsAndConditions();
      if (response['data'] != null && response['data']['content'] != null) {
        termsContent.value = response['data']['content'];
      } else if (response['content'] != null) {
        termsContent.value = response['content'];
      } else if (response['data'] is String) {
        termsContent.value = response['data'];
      } else {
        termsContent.value = "No terms and conditions available.";
      }
    } catch (e) {
      debugPrint("Error fetching terms: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch FAQ
  Future<void> fetchFaq() async {
    isLoading.value = true;
    try {
      final response = await _authService.getFaq();
      var data = response['data'];

      if (data != null && data is List) {
        faqList.value = data.map((item) {
          return {
            'question': item['question']?.toString() ?? '',
            'answer': item['answer']?.toString() ?? '',
          };
        }).toList();
      }
    } catch (e) {
      debugPrint("Error fetching FAQ: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch About Us
  Future<void> fetchAboutUs() async {
    isLoading.value = true;
    try {
      final response = await _authService.getAboutUs();
      if (response['data'] != null && response['data']['content'] != null) {
        aboutUsContent.value = response['data']['content'];
      } else if (response['content'] != null) {
        aboutUsContent.value = response['content'];
      } else if (response['data'] is String) {
        aboutUsContent.value = response['data'];
      } else {
        aboutUsContent.value = "No about us content available.";
      }
    } catch (e) {
      debugPrint("Error fetching About Us: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
