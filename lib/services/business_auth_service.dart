import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/business_auth_response.dart';
import 'api_service.dart';

class BusinessAuthService {
  /// Business Login
  Future<BusinessAuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("🔐 Business Login - Email: $email");

      final response = await ApiService.post(
        endpoint: '/api/business-owners/login',
        body: {'email': email, 'password': password},
        requireAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          return BusinessAuthResponse.fromJson(jsonResponse);
        } catch (e) {
          debugPrint("❌ Invalid response format: $e");
          throw Exception('Invalid response format from server');
        }
      } else {
        try {
          final errorResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(errorResponse['message'] ?? 'Login failed');
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          }
          throw Exception('Login failed with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Login Error: $e");
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred during login: $e');
    }
  }

  /// Business Sign Up
  Future<BusinessAuthResponse> signUp({
    required String businessName,
    required String ownerName,
    required String email,
    required String phone,
    required String password,
    String? address,
    String? businessType,
    String? businessPhoto,
    String? idCardFront,
    String? idCardBack,
    String? occupation,
    String? referenceId,
  }) async {
    try {
      debugPrint("📝 Business Sign Up (Multipart) - Email: $email");

      final fields = {
        'business_name': businessName,
        'owner_name': ownerName,
        'email': email,
        'phone': phone,
        'password': password,
      };

      if (address != null) fields['address'] = address;
      if (businessType != null) fields['business_type'] = businessType;
      if (occupation != null) fields['occupation'] = occupation;
      if (referenceId != null) fields['reference_id'] = referenceId;

      final files = <String, dynamic>{};
      if (businessPhoto != null) files['businessPhoto'] = businessPhoto;
      if (idCardFront != null) files['idCardFront'] = idCardFront;
      if (idCardBack != null) files['IdCardBack'] = idCardBack;

      final streamedResponse = await ApiService.postMultipart(
        endpoint: '/api/business-owners/register',
        fields: fields,
        files: files,
        requireAuth: false,
      );

      final responseBody = await streamedResponse.stream.bytesToString();
      final statusCode = streamedResponse.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        try {
          final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
          return BusinessAuthResponse.fromJson(jsonResponse);
        } catch (e) {
          debugPrint("❌ Invalid response format: $e");
          throw Exception('Invalid response format from server');
        }
      } else {
        try {
          final errorResponse =
              jsonDecode(responseBody) as Map<String, dynamic>;
          throw Exception(errorResponse['message'] ?? 'Sign up failed');
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          }
          throw Exception('Sign up failed with status $statusCode');
        }
      }
    } catch (e) {
      debugPrint("❌ Sign Up Error: $e");
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred during sign up: $e');
    }
  }

  /// Get Current Business Info
  Future<Map<String, dynamic>> getBusinessInfo() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/me',
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Failed to get business info',
          );
        }
      } else {
        try {
          final errorResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(
            errorResponse['message'] ?? 'Failed to get business info',
          );
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          }
          throw Exception(
            'Failed to get business info with status ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Get Business Info Error: $e");
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred while getting business info: $e');
    }
  }

  /// Send OTP
  Future<Map<String, dynamic>> sendOtp({required String email}) async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/send-otp?email=$email',
        requireAuth: false,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      } else {
        try {
          final errorResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(
            errorResponse['message'] ?? 'Failed to send reset email',
          );
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          }
          throw Exception('Failed with status ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred: $e');
    }
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/verify-otp?email=$email&otp=$otp',
        requireAuth: false,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      } else {
        try {
          final errorResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(errorResponse['message'] ?? 'Verification failed');
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          }
          throw Exception(
            'Verification failed with status ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred: $e');
    }
  }

  /// Reset Password with OTP
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await ApiService.get(
        endpoint:
            '/api/business-owners/reset-password?email=$email&otp=$otp&newPassword=$newPassword',
        requireAuth: false,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      } else {
        try {
          final errorResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(errorResponse['message'] ?? 'Password reset failed');
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          }
          throw Exception(
            'Password reset failed with status ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred: $e');
    }
  }
}
