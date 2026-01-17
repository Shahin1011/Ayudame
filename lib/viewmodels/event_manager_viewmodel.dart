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
      // Inspect response structure - assuming standard API response
      final data = response['data'];

      if (data != null) {
        // If 'eventManager' key exists use it (nested), otherwise try data directly
        var managerData = data['eventManager'] ?? data;

        // Ideally merge with user data if separate, like in login
        if (data['user'] != null) {
          var userData = data['user'];
          managerData = {
            ...userData,
            ...managerData, // Event manager data overwrites if conflict
            'id': userData['id'], // Ensure ID logic
          };
        }

        currentManager.value = EventManagerModel.fromJson(managerData);

        await StorageService.saveUserName(currentManager.value?.fullName ?? '');
        await StorageService.saveUserEmail(currentManager.value?.email ?? '');
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
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
    String? category,
    String? address,
  }) async {
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
        category: category,
        address: address,
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
}
