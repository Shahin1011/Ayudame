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

      if (response.body.contains('<!DOCTYPE html>')) {
        throw Exception('Server returned HTML. Possible tunnel issue or 404.');
      }

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
    String? newConfirmPassword,
    String? category,
    String? address,
    String? businessAddress,
    String? birthdate,
    String? idType,
    String? identificationNumber,
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
      if (businessAddress != null && businessAddress.isNotEmpty)
        fields['businessAddress'] = businessAddress;
      if (idType != null && idType.isNotEmpty) fields['idType'] = idType;
      if (identificationNumber != null && identificationNumber.isNotEmpty)
        fields['identificationNumber'] = identificationNumber;
      if (dateOfBirth != null) fields['dateOfBirth'] = dateOfBirth;
      if (birthdate != null) fields['birthdate'] = birthdate;
      if (currentPassword != null && currentPassword.isNotEmpty)
        fields['currentPassword'] = currentPassword;
      if (newPassword != null && newPassword.isNotEmpty)
        fields['newPassword'] = newPassword;
      if (confirmPassword != null && confirmPassword.isNotEmpty)
        fields['confirmPassword'] = confirmPassword;
      if (newConfirmPassword != null && newConfirmPassword.isNotEmpty)
        fields['newConfirmPassword'] = newConfirmPassword;

      http.Response response;
      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        // Use Multipart if uploading image
        // IMPORTANT: Use POST method with _method: PUT field for Laravel/PHP backends
        fields['_method'] = 'PUT';

        final streamedResponse = await ApiService.postMultipart(
          endpoint: _meEndpoint, // endpoint is /api/event-managers/me
          fields: fields,
          files: {'profilePicture': profilePicturePath},
          requireAuth: true,
          method: 'POST', // Actually sending POST
        );
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // Use standard JSON PUT if no image
        // Need to add dynamic map support to fields or convert manually
        // Since ApiService.put expects Map<String, dynamic> body

        // Convert Map<String, String> to Map<String, dynamic>
        final Map<String, dynamic> jsonBody = Map<String, dynamic>.from(fields);

        response = await ApiService.put(
          endpoint: _meEndpoint,
          body: jsonBody,
          requireAuth: true,
        );
      }

      if (response.body.contains('<!DOCTYPE html>')) {
        throw Exception('Server returned HTML. Possible tunnel issue or 404.');
      }

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        String errorMsg =
            decodedResponse['message'] ?? 'Failed to update profile';
        if (decodedResponse['errors'] != null) {
          final errors = decodedResponse['errors'];
          if (errors is Map) {
            errorMsg = errors.values.join(', ');
          } else if (errors is List) {
            errorMsg = errors.join(', ');
          }
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      debugPrint('Error in EventManagerService.updateProfile: $e');
      rethrow;
    }
  }

  // Event Endpoints
  static const String _eventsEndpoint = '/api/event-managers/events';

  /// Create Event (Draft)
  Future<Map<String, dynamic>> createEvent(
    Map<String, dynamic> fields,
    String? imagePath,
  ) async {
    try {
      http.Response response;
      if (imagePath != null && imagePath.isNotEmpty) {
        // Sanitize fields for multipart (trim strings, format numbers)
        final Map<String, String> sanitizedFields = fields.map((key, value) {
          String valStr = value.toString().trim();
          if (value is double && value == value.toInt().toDouble()) {
            valStr = value.toInt().toString();
          }
          return MapEntry(key, valStr);
        });

        final streamedResponse = await ApiService.postMultipart(
          endpoint: _eventsEndpoint,
          fields: sanitizedFields,
          files: {'eventImage': imagePath},
          requireAuth: true,
        );
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // Trim strings in JSON as well
        final Map<String, dynamic> sanitizedFields = fields.map((key, value) {
          return MapEntry(key, value is String ? value.trim() : value);
        });

        response = await ApiService.post(
          endpoint: _eventsEndpoint,
          body: sanitizedFields,
          requireAuth: true,
        );
      }

      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return decodedResponse;
      } else {
        // Handle detailed validation errors if present
        String errorMsg =
            decodedResponse['message'] ?? 'Failed to create event';
        if (decodedResponse['errors'] != null) {
          final errors = decodedResponse['errors'];
          if (errors is Map) {
            errorMsg = errors.values.join(', ');
          } else if (errors is List) {
            errorMsg = errors.join(', ');
          }
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      debugPrint('Error creating event: $e');
      rethrow;
    }
  }

  /// Get All Events with Pagination and Status
  Future<Map<String, dynamic>> getEvents({
    int page = 1,
    int limit = 10,
    String status = 'draft',
  }) async {
    try {
      final endpoint =
          '$_eventsEndpoint?page=$page&limit=$limit&status=$status';
      final response = await ApiService.get(
        endpoint: endpoint,
        requireAuth: true,
      );
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(decodedResponse['message'] ?? 'Failed to fetch events');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
      rethrow;
    }
  }

  /// Get Event by ID
  Future<Map<String, dynamic>> getEventById(String eventId) async {
    try {
      final endpoint = '$_eventsEndpoint/$eventId';
      final response = await ApiService.get(
        endpoint: endpoint,
        requireAuth: true,
      );
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(
          decodedResponse['message'] ?? 'Failed to fetch event details',
        );
      }
    } catch (e) {
      debugPrint('Error fetching event details: $e');
      rethrow;
    }
  }

  /// Update Event
  Future<Map<String, dynamic>> updateEvent(
    String eventId,
    Map<String, dynamic> fields,
    String? imagePath,
  ) async {
    try {
      final endpoint = '$_eventsEndpoint/$eventId';
      http.Response response;

      if (imagePath != null && imagePath.isNotEmpty) {
        final Map<String, String> sanitizedFields = fields.map((key, value) {
          String valStr = value.toString().trim();
          if (value is double && value == value.toInt().toDouble()) {
            valStr = value.toInt().toString();
          }
          return MapEntry(key, valStr);
        });

        final streamedResponse = await ApiService.postMultipart(
          endpoint: endpoint,
          fields: sanitizedFields,
          files: {'eventImage': imagePath},
          requireAuth: true,
          method: 'PUT',
        );
        response = await http.Response.fromStream(streamedResponse);
      } else {
        final Map<String, dynamic> sanitizedFields = fields.map((key, value) {
          return MapEntry(key, value is String ? value.trim() : value);
        });

        response = await ApiService.put(
          endpoint: endpoint,
          body: sanitizedFields,
          requireAuth: true,
        );
      }

      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        String errorMsg =
            decodedResponse['message'] ?? 'Failed to update event';
        if (decodedResponse['errors'] != null) {
          final errors = decodedResponse['errors'];
          if (errors is Map) {
            errorMsg = errors.values.join(', ');
          } else if (errors is List) {
            errorMsg = errors.join(', ');
          }
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      debugPrint('Error updating event: $e');
      rethrow;
    }
  }

  /// Publish Event
  Future<Map<String, dynamic>> publishEvent(String eventId) async {
    try {
      final endpoint = '$_eventsEndpoint/$eventId/publish';
      final response = await ApiService.put(
        endpoint: endpoint,
        body: {},
        requireAuth: true,
      );
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(
          decodedResponse['message'] ?? 'Failed to publish event',
        );
      }
    } catch (e) {
      debugPrint('Error publishing event: $e');
      rethrow;
    }
  }

  /// Cancel Event
  Future<Map<String, dynamic>> cancelEvent(
    String eventId,
    String reason,
  ) async {
    try {
      final endpoint = '$_eventsEndpoint/$eventId/cancel';
      final response = await ApiService.put(
        endpoint: endpoint,
        body: {'cancellationReason': reason},
        requireAuth: true,
      );
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        String errorMsg =
            decodedResponse['message'] ?? 'Failed to cancel event';
        if (decodedResponse['errors'] != null) {
          final errors = decodedResponse['errors'];
          if (errors is Map) {
            errorMsg = errors.values.join(', ');
          } else if (errors is List) {
            errorMsg = errors.join(', ');
          }
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      debugPrint('Error canceling event: $e');
      rethrow;
    }
  }

  /// Get Stats
  Future<Map<String, dynamic>> getStats() async {
    try {
      final endpoint = '$_eventsEndpoint/stats';
      final response = await ApiService.get(
        endpoint: endpoint,
        requireAuth: true,
      );
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(decodedResponse['message'] ?? 'Failed to fetch stats');
      }
    } catch (e) {
      debugPrint('Error fetching stats: $e');
      rethrow;
    }
  }

  /// Delete Account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await ApiService.delete(
        endpoint: _meEndpoint,
        requireAuth: true,
      );
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        throw Exception(
          decodedResponse['message'] ?? 'Failed to delete account',
        );
      }
    } catch (e) {
      debugPrint('Error deleting account: $e');
      rethrow;
    }
  }
}
