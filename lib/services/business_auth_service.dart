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
    String? email,
    String? phone,
    required String password,
    String? address,
    String? businessType,
    String? businessPhoto,
    String? idCardFront,
    String? idCardBack,
    String? occupation,
    String? referenceId,
    String? dob,
  }) async {
    try {
      debugPrint(
        "📝 Business Sign Up - Email: $email, Phone: $phone, DOB: $dob",
      );

      final fields = <String, String>{
        'businessName': businessName,
        'fullName': ownerName,
        'password': password,
        'confirmPassword': password,
        'password_confirmation': password,
      };

      if (email != null && email.isNotEmpty) {
        fields['email'] = email;
      } else if (phone != null && phone.isNotEmpty) {
        fields['email'] = "${phone}@tempmail.com";
      }

      if (phone != null && phone.isNotEmpty) {
        fields['phoneNumber'] = phone;
      } else if (email != null && email.isNotEmpty) {
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        fields['phoneNumber'] =
            "01" + timestamp.substring(timestamp.length - 9);
      }

      if (address != null) fields['businessAddress'] = address;
      if (businessType != null) fields['businessCategory'] = businessType;
      if (occupation != null) fields['occupation'] = occupation;
      if (referenceId != null) fields['referenceId'] = referenceId;

      if (dob != null && dob.contains('/')) {
        try {
          final parts = dob.split('/');
          if (parts.length == 3) {
            fields['dateOfBirth'] =
                "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
          } else {
            fields['dateOfBirth'] = dob;
          }
        } catch (_) {
          fields['dateOfBirth'] = dob;
        }
      } else {
        fields['dateOfBirth'] = dob ?? '';
      }

      final files = <String, dynamic>{};
      if (idCardFront != null) files['idCardFront'] = idCardFront;
      if (idCardBack != null) files['idCardBack'] = idCardBack;
      if (businessPhoto != null) files['logo'] = businessPhoto;

      final streamedResponse = await ApiService.postMultipart(
        endpoint: '/api/business-owners/register',
        fields: fields,
        files: files,
        requireAuth: false,
      );

      final responseBody = await streamedResponse.stream.bytesToString();
      final statusCode = streamedResponse.statusCode;
      debugPrint("📥 Sign Up Response ($statusCode): $responseBody");

      if (statusCode == 200 || statusCode == 201) {
        final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
        return BusinessAuthResponse.fromJson(jsonResponse);
      } else {
        String errorMessage = 'Sign up failed';
        try {
          final errorResponse =
              jsonDecode(responseBody) as Map<String, dynamic>;
          errorMessage =
              errorResponse['message'] ??
              errorResponse['error'] ??
              errorMessage;
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint("❌ Sign Up Error: $e");
      rethrow;
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
  Future<Map<String, dynamic>> sendOtp({String? email, String? phone}) async {
    try {
      final body = <String, String>{};
      if (email != null && email.isNotEmpty) body['email'] = email;
      // Reverting to phoneNumber to match registration schema
      if (phone != null && phone.isNotEmpty) body['phoneNumber'] = phone;

      final response = await ApiService.post(
        endpoint: '/api/business-owners/forgot-password',
        body: body,
        requireAuth: false,
        baseUrl: ApiService.baseURL,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      } else {
        try {
          final errorResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(
            errorResponse['message'] ??
                'Failed: ${response.statusCode} - ${response.body}',
          );
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          }
          throw Exception(
            'Failed with status ${response.statusCode}: ${response.body}',
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

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    String? email,
    String? phone,
    required String otp,
  }) async {
    try {
      final body = <String, String>{'otp': otp};
      if (email != null && email.isNotEmpty) body['email'] = email;
      if (phone != null && phone.isNotEmpty) body['phoneNumber'] = phone;

      final response = await ApiService.post(
        endpoint: '/api/business-owners/verify-otp',
        body: body,
        requireAuth: false,
        baseUrl: ApiService.baseURL,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
    String? email,
    String? phone,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final body = <String, String>{
        'otp': otp,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
      if (email != null && email.isNotEmpty) body['email'] = email;
      if (phone != null && phone.isNotEmpty) body['phoneNumber'] = phone;

      final response = await ApiService.post(
        endpoint: '/api/business-owners/reset-password',
        body: body,
        requireAuth: false,
        baseUrl: ApiService.baseURL,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
