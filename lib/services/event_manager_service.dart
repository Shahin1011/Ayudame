import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/event_manager_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class EventManagerService {
  static const String _registerEndpoint = '/api/event-managers/register';
  static const String _loginEndpoint = '/api/event-managers/login';
  static const String _logoutEndpoint = '/api/event-managers/logout';
  static const String _forgotPasswordEndpoint =
      '/api/event-managers/forgot-password';
  static const String _verifyOtpEndpoint = '/api/event-managers/verify-otp';
  static const String _resetPasswordEndpoint =
      '/api/event-managers/reset-password';
  static const String _meEndpoint = '/api/event-managers/me';

  /// Register a new event manager
  Future<Map<String, dynamic>> register({
    required EventManagerModel manager,
    required String password,
    required String confirmPassword,
    required String idCardFrontPath,
    required String idCardBackPath,
  }) async {
    try {
      final fields = manager.toRegistrationFields();
      fields['password'] = password;
      fields['confirmPassword'] = confirmPassword;

      debugPrint('📤 Registration Fields:');
      fields.forEach((key, value) {
        debugPrint('  $key: $value');
      });

      final files = {
        'idCardFront': idCardFrontPath,
        'idCardBack': idCardBackPath,
      };

      debugPrint('📎 Files:');
      files.forEach((key, value) {
        debugPrint('  $key: $value');
      });

      final response = await ApiService.postMultipart(
        endpoint: _registerEndpoint,
        fields: fields,
        files: files,
        requireAuth: false,
      );

      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decodedResponse;
      } else {
        throw Exception(decodedResponse['message'] ?? 'Registration failed');
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.register: $e');
      rethrow;
    }
  }

  /// Login as an event manager
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: _loginEndpoint,
        body: {'email': email, 'password': password},
        requireAuth: false,
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Store token and user data if needed
        // Check for token in data object (standard for this API)
        if (decodedResponse['data'] != null &&
            decodedResponse['data']['accessToken'] != null) {
          await StorageService.saveToken(
            decodedResponse['data']['accessToken'],
          );
        }
        // Fallback for flat structure
        else if (decodedResponse['token'] != null) {
          await StorageService.saveToken(decodedResponse['token']);
        }
        return decodedResponse;
      } else {
        throw Exception(decodedResponse['message'] ?? 'Login failed');
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.login: $e');
      rethrow;
    }
  }

  /// Logout event manager
  Future<void> logout() async {
    try {
      final response = await ApiService.post(
        endpoint: _logoutEndpoint,
        body: {},
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        await StorageService.clearAll();
      } else {
        final decodedResponse = jsonDecode(response.body);
        throw Exception(decodedResponse['message'] ?? 'Logout failed');
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.logout: $e');
      rethrow;
    }
  }

  /// Send OTP for forgot password
  Future<Map<String, dynamic>> sendOtp(String email) async {
    try {
      final response = await ApiService.post(
        endpoint: _forgotPasswordEndpoint,
        body: {'email': email},
        requireAuth: false,
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(decodedResponse['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.sendOtp: $e');
      rethrow;
    }
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await ApiService.post(
        endpoint: _verifyOtpEndpoint,
        body: {'email': email, 'otp': otp},
        requireAuth: false,
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(decodedResponse['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.verifyOtp: $e');
      rethrow;
    }
  }

  /// Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: _resetPasswordEndpoint,
        body: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
        requireAuth: false,
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(decodedResponse['message'] ?? 'Password reset failed');
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.resetPassword: $e');
      rethrow;
    }
  }

  /// Get Profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService.get(
        endpoint: _meEndpoint,
        requireAuth: true,
      );
      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(
          decodedResponse['message'] ?? 'Failed to fetch profile',
        );
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.getProfile: $e');
      rethrow;
    }
  }

  /// Update Profile
  Future<Map<String, dynamic>> updateProfile({
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
    try {
      Map<String, String> fields = {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
      };

      if (category != null && category.isNotEmpty)
        fields['category'] = category;
      if (address != null && address.isNotEmpty) fields['address'] = address;
      if (dateOfBirth != null) fields['dateOfBirth'] = dateOfBirth;
      if (currentPassword != null && currentPassword.isNotEmpty)
        fields['currentPassword'] = currentPassword;
      if (newPassword != null && newPassword.isNotEmpty)
        fields['newPassword'] = newPassword;
      if (confirmPassword != null && confirmPassword.isNotEmpty)
        fields['confirmPassword'] = confirmPassword;

      http.Response response;
      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        // Use Multipart if uploading image
        final streamedResponse = await ApiService.postMultipart(
          endpoint: _meEndpoint,
          fields: fields,
          files: {'profilePicture': profilePicturePath},
          requireAuth: true,
          method: 'PUT',
        );
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // Use standard JSON PUT if no image
        // Need to add dynamic map support to fields or convert manually
        // Since ApiService.put expects Map<String, dynamic> body
        response = await ApiService.put(
          endpoint: _meEndpoint,
          body: fields,
          requireAuth: true,
        );
      }

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(
          decodedResponse['message'] ?? 'Failed to update profile',
        );
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.updateProfile: $e');
      rethrow;
    }
  }
}
