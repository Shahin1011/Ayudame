import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
      }
      if (phone != null && phone.isNotEmpty) {
        fields['phoneNumber'] = phone;
      }

      // If one is missing, only then apply workarounds if the backend requires both
      if (fields['email'] == null && phone != null) {
        fields['email'] = "${phone}@tempmail.com";
      }
      if (fields['phoneNumber'] == null && email != null) {
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        fields['phoneNumber'] =
            "01${timestamp.substring(timestamp.length - 9)}";
      }

      if (address != null) fields['businessAddress'] = address;
      if (businessType != null) fields['businessCategory'] = businessType;
      if (occupation != null) fields['occupation'] = occupation;
      if (referenceId != null) fields['referenceId'] = referenceId;

      if (dob != null && dob.contains('/')) {
        try {
          final parts = dob.split('/');
          if (parts.length == 3) {
            // Convert dd/mm/yyyy to yyyy-mm-dd
            fields['dateOfBirth'] =
                "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
          } else {
            fields['dateOfBirth'] = dob;
          }
        } catch (_) {
          fields['dateOfBirth'] = dob;
        }
      } else if (dob != null) {
        fields['dateOfBirth'] = dob;
      }

      final files = <String, dynamic>{};
      if (idCardFront != null) files['idCardFront'] = idCardFront;
      if (idCardBack != null) files['idCardBack'] = idCardBack;
      if (businessPhoto != null) {
        files['businessPhoto'] = businessPhoto;
      }

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

  /// Update Business Owner Profile
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String email,
    String? phoneNumber,
    String? occupation,
    String? dateOfBirth,
    String? profilePicturePath,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? businessName,
    String? businessCategory,
    String? businessAddress,
    String? description,
    String? businessLogoPath,
  }) async {
    try {
      final fields = <String, String>{'fullName': fullName, 'email': email};
      if (phoneNumber != null) fields['phoneNumber'] = phoneNumber;
      if (occupation != null) fields['occupation'] = occupation;
      if (dateOfBirth != null) fields['dateOfBirth'] = dateOfBirth;
      if (currentPassword != null) fields['currentPassword'] = currentPassword;
      if (newPassword != null) fields['newPassword'] = newPassword;
      if (confirmPassword != null) fields['confirmPassword'] = confirmPassword;
      if (businessName != null) fields['businessName'] = businessName;
      if (businessCategory != null)
        fields['businessCategory'] = businessCategory;
      if (businessAddress != null) fields['businessAddress'] = businessAddress;
      if (description != null) fields['description'] = description;

      http.Response response;

      final files = <String, String>{};
      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        files['profilePicture'] = profilePicturePath;
      }
      if (businessLogoPath != null && businessLogoPath.isNotEmpty) {
        files['logo'] = businessLogoPath;
      }

      if (files.isNotEmpty) {
        // Matching the pattern that worked for Event Managers
        final streamedResponse = await ApiService.postMultipart(
          endpoint: '/api/business-owners/me?_method=PUT',
          fields: fields,
          files: files,
          requireAuth: true,
          method: 'PUT',
        );
        response = await http.Response.fromStream(streamedResponse);
      } else {
        response = await ApiService.put(
          endpoint: '/api/business-owners/me',
          body: fields,
          requireAuth: true,
        );
      }

      final responseBody = response.body;
      final statusCode = response.statusCode;
      debugPrint("📥 Profile Update Response ($statusCode): $responseBody");

      final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;

      if (statusCode == 200 || statusCode == 201) {
        return jsonResponse;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      debugPrint("❌ Profile Update Error: $e");
      rethrow;
    }
  }

  /// Get Current Business Profile (Entity specifics)
  Future<Map<String, dynamic>> getBusinessProfile() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/business-profile',
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Failed to get business profile',
          );
        }
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to get business profile',
        );
      }
    } catch (e) {
      debugPrint("❌ Get Business Profile Error: $e");
      rethrow;
    }
  }

  /// Create/Update Business Profile (Entity specifics)
  Future<Map<String, dynamic>> updateBusinessProfile({
    required String businessName,
    required String businessCategory,
    required String businessAddress,
    required String description,
    String? businessLogoPath,
    String? businessCoverPath,
  }) async {
    try {
      final fields = <String, String>{
        'name': businessName,
        'categories': businessCategory,
        'location': businessAddress,
        'about': description,
      };

      final files = <String, String>{};
      if (businessLogoPath != null && businessLogoPath.isNotEmpty) {
        files['businessPhotos'] = businessLogoPath;
      }
      if (businessCoverPath != null && businessCoverPath.isNotEmpty) {
        files['coverPhoto'] = businessCoverPath;
      }

      // Use hybrid approach to ensure maximum compatibility
      // For files + text: Multipart POST with _method=PUT (Standard Laravel spoofing)
      // For text only: JSON PUT with _method=PUT (Safety net)

      http.Response response;

      if (files.isNotEmpty) {
        final streamedResponse = await ApiService.postMultipart(
          endpoint: '/api/business-owners/business-profile?_method=PUT',
          fields: fields,
          files: files,
          requireAuth: true,
          method: 'PUT',
        );
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // Remove _method from body for JSON request to avoid pollution,
        // relying on query param or native PUT
        fields.remove('_method');

        response = await ApiService.put(
          endpoint: '/api/business-owners/business-profile?_method=PUT',
          body: fields,
          requireAuth: true,
        );
      }

      final responseBody = response.body;
      final statusCode = response.statusCode;
      debugPrint(
        "📥 Business Profile Update Response ($statusCode): $responseBody",
      );

      final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;

      if (statusCode == 200 || statusCode == 201) {
        return jsonResponse;
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to update business profile',
        );
      }
    } catch (e) {
      debugPrint("❌ Business Profile Update Error: $e");
      rethrow;
    }
  }

  /// Get Business FAQs
  Future<List<dynamic>> getFaqs() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/faqs',
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as List<dynamic>;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to get FAQs');
        }
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to get FAQs');
      }
    } catch (e) {
      debugPrint("❌ Get FAQs Error: $e");
      rethrow;
    }
  }

  /// Get Privacy Policy
  Future<Map<String, dynamic>> getPrivacyPolicy() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/privacy-policy',
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Failed to get privacy policy',
          );
        }
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to get privacy policy',
        );
      }
    } catch (e) {
      debugPrint("❌ Get Privacy Policy Error: $e");
      rethrow;
    }
  }

  /// Get Terms and Conditions
  Future<Map<String, dynamic>> getTermsConditions() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/terms-and-conditions',
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Failed to get terms and conditions',
          );
        }
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to get terms and conditions',
        );
      }
    } catch (e) {
      debugPrint("❌ Get Terms Conditions Error: $e");
      rethrow;
    }
  }

  /// Get Stats
  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/stats',
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to get stats');
        }
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to get stats');
      }
    } catch (e) {
      debugPrint("❌ Get Stats Error: $e");
      rethrow;
    }
  }

  /// Get Activities
  Future<List<dynamic>> getActivities() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/activities',
        requireAuth: true,
      );

      debugPrint("📥 Get Activities Response: ${response.body}");

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          if (data is Map<String, dynamic> && data['activities'] != null) {
            return data['activities'] as List<dynamic>;
          }
          return [];
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Failed to get activities',
          );
        }
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to get activities');
      }
    } catch (e) {
      debugPrint("❌ Get Activities Error: $e");
      rethrow;
    }
  }

  /// Change Password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: '/api/business-owners/change-password',
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResponse;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      debugPrint("❌ Change Password Error: $e");
      rethrow;
    }
  }

  /// Get Bank Information
  Future<Map<String, dynamic>> getBankInfo() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/bank-information',
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          return {}; // Return empty if no bank info found but success
        }
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to get bank info');
      }
    } catch (e) {
      debugPrint("❌ Get Bank Info Error: $e");
      rethrow;
    }
  }

  /// Create Bank Information
  Future<Map<String, dynamic>> createBankInfo(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post(
        endpoint: '/api/business-owners/bank-information',
        body: data,
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResponse;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to save bank info');
      }
    } catch (e) {
      debugPrint("❌ Create Bank Info Error: $e");
      rethrow;
    }
  }

  /// Update Bank Information
  Future<Map<String, dynamic>> updateBankInfo(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put(
        endpoint: '/api/business-owners/bank-information',
        body: data,
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResponse;
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to update bank info',
        );
      }
    } catch (e) {
      debugPrint("❌ Update Bank Info Error: $e");
      rethrow;
    }
  }

  /// Get Notifications
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
    bool isRead = false,
  }) async {
    try {
      final queryParams = 'isRead=$isRead&page=$page&limit=$limit';
      final response = await ApiService.get(
        endpoint: '/api/business-owners/notifications?$queryParams',
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (jsonResponse['success'] == true) {
          return jsonResponse;
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Failed to get notifications',
          );
        }
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to get notifications',
        );
      }
    } catch (e) {
      debugPrint("❌ Get Notifications Error: $e");
      rethrow;
    }
  }

  /// Delete Account
  Future<Map<String, dynamic>> deleteAccount(String id) async {
    try {
      final response = await ApiService.delete(
        endpoint: '/api/admin/business-owners/$id',
        requireAuth: true,
      );

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResponse;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to delete account');
      }
    } catch (e) {
      debugPrint("❌ Delete Account Error: $e");
      rethrow;
    }
  }
}
