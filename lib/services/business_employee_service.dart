import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/business_employee_model.dart';
import 'api_service.dart';

class BusinessEmployeeService {
  /// Create Employee
  Future<BusinessEmployeeModel> createEmployee({
    required BusinessEmployeeModel employee,
    String? idCardFront,
    String? idCardBack,
  }) async {
    try {
      final fields = <String, String>{
        'fullName': employee.name ?? '',
        'mobileNumber': employee.phone ?? '',
        'email': employee.email ?? '',
        'categories': employee.serviceCategory ?? '',
        'headline': employee.headline ?? '',
        'description': employee.about ?? '',
        'appointmentEnabled': employee.isAppointmentBased.toString(),
      };

      // Send whyChooseService as JSON array
      if (employee.whyChooseUs != null && employee.whyChooseUs!.isNotEmpty) {
        fields['whyChooseService'] = jsonEncode(employee.whyChooseUs);
      }

      // Send appointmentSlots as JSON array
      if (employee.appointmentOptions != null &&
          employee.appointmentOptions!.isNotEmpty) {
        fields['appointmentSlots'] = jsonEncode(
          employee.appointmentOptions?.map((e) => e.toJson()).toList(),
        );
      }

      final files = <String, dynamic>{};
      // Backend only has servicePhoto field, not photo
      if (idCardBack != null && idCardBack.isNotEmpty) {
        files['servicePhoto'] = idCardBack;
      }

      // 🔍 DEBUG: Print what we're sending
      debugPrint("📤 Creating Employee - Fields: $fields");
      debugPrint("📤 Creating Employee - Files: ${files.keys.toList()}");
      debugPrint("📤 servicePhoto path: $idCardBack");

      final streamedResponse = await ApiService.postMultipart(
        endpoint: '/api/business-owners/employees',
        fields: fields,
        files: files,
        requireAuth: true,
      );

      final responseBody = await streamedResponse.stream.bytesToString();
      final statusCode = streamedResponse.statusCode;

      // 🔍 DEBUG: Print response
      debugPrint("📥 Response Status: $statusCode");
      debugPrint("📥 Response Body: $responseBody");

      if (statusCode == 200 || statusCode == 201) {
        final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          debugPrint("✅ Employee Created: ${jsonResponse['data']}");
          return BusinessEmployeeModel.fromJson(jsonResponse['data']);
        }
        return BusinessEmployeeModel.fromJson(jsonResponse); // Fallback
      } else {
        final errorResponse = jsonDecode(responseBody) as Map<String, dynamic>;
        throw Exception(
          errorResponse['message'] ?? 'Failed to create employee',
        );
      }
    } catch (e) {
      debugPrint("❌ Create Employee Error: $e");
      rethrow;
    }
  }

  /// Get All Employees
  Future<List<BusinessEmployeeModel>> getAllEmployees() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/employees',
        requireAuth: true,
      );

      debugPrint("📥 Get All Employees Status: ${response.statusCode}");
      debugPrint("📥 Get All Employees Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Assuming standard response structure { success: true, data: [...] }
        final List<dynamic> data = jsonResponse['data'] ?? [];
        debugPrint("📋 Total Employees: ${data.length}");
        if (data.isNotEmpty) {
          debugPrint("📋 First Employee Data: ${data[0]}");
        }
        return data.map((e) => BusinessEmployeeModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Get All Employees Error: $e");
      rethrow;
    }
  }

  /// Get Employee Detail
  Future<BusinessEmployeeModel> getEmployeeDetail(String id) async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/employees/$id',
        requireAuth: true,
      );

      debugPrint("📥 Get Employee Detail Status: ${response.statusCode}");
      debugPrint("📥 Get Employee Detail Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        debugPrint("📋 Employee Detail Data: ${jsonResponse['data']}");
        return BusinessEmployeeModel.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load employee details');
      }
    } catch (e) {
      debugPrint("❌ Get Employee Detail Error: $e");
      rethrow;
    }
  }

  /// Update Employee
  Future<BusinessEmployeeModel> updateEmployee({
    required String id,
    required BusinessEmployeeModel employee,
    String? idCardFront,
    String? idCardBack,
  }) async {
    // NOTE: PUT requests with Multipart are sometimes tricky depending on the Http client and backend.
    // ApiService.put usually sends JSON. If update requires image, we might need a custom multipart PUT or PATCH.
    // Based on ApiService, postMultipart sends POST.
    // I will assume for now update might be JSON only if no image, or I need to check ApiService capabilities.
    // The user request says "Update Employee Information -> PUT".
    // If image is updated, usually it's better to use POST with method override or special endpoint,
    // but let's try standard JSON PUT first if no image change, or if ApiService supports it.
    // Scanning ApiService... it has `put` (JSON). It does NOT have `putMultipart`.
    // If the user wants to update the image, I might need to use `postMultipart` to a specific update endpoint or add `putMultipart` to ApiService.
    // For now, I will implement JSON update.

    try {
      // Check if we need to use Multipart (if images are provided)
      if ((idCardFront != null && idCardFront.isNotEmpty) ||
          (idCardBack != null && idCardBack.isNotEmpty)) {
        final fields = <String, String>{
          'fullName': employee.name ?? '',
          'mobileNumber': employee.phone ?? '',
          'email': employee.email ?? '',
          'categories': employee.serviceCategory ?? '',
          'headline': employee.headline ?? '',
          'description': employee.about ?? '',
          'appointmentEnabled': employee.isAppointmentBased.toString(),
          '_method': 'PUT', // Method override for backends that need it
        };

        // Send whyChooseService as JSON array
        if (employee.whyChooseUs != null && employee.whyChooseUs!.isNotEmpty) {
          fields['whyChooseService'] = jsonEncode(employee.whyChooseUs);
        }

        // Send appointmentSlots as JSON array
        if (employee.appointmentOptions != null &&
            employee.appointmentOptions!.isNotEmpty) {
          fields['appointmentSlots'] = jsonEncode(
            employee.appointmentOptions?.map((e) => e.toJson()).toList(),
          );
        }

        final files = <String, dynamic>{};
        // Backend only has servicePhoto field
        if (idCardBack != null && idCardBack.isNotEmpty) {
          files['servicePhoto'] = idCardBack;
        }

        debugPrint("📤 Updating Employee - Fields: $fields");
        debugPrint("📤 Updating Employee - Files: ${files.keys.toList()}");

        // We use POST with _method=PUT for multipart updates usually
        final streamedResponse = await ApiService.postMultipart(
          endpoint: '/api/business-owners/employees/$id',
          fields: fields,
          files: files,
          requireAuth: true,
        );

        final responseBody = await streamedResponse.stream.bytesToString();
        debugPrint("📥 Update Response: $responseBody");

        if (streamedResponse.statusCode == 200) {
          final jsonResponse = jsonDecode(responseBody);
          return BusinessEmployeeModel.fromJson(jsonResponse['data']);
        }
        throw Exception('Failed to update employee with images');
      }

      // Standard JSON update if no images
      final body = employee.toJson();
      body.removeWhere((key, value) => value == null);

      final response = await ApiService.put(
        endpoint: '/api/business-owners/employees/$id',
        body: body,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return BusinessEmployeeModel.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to update employee');
      }
    } catch (e) {
      debugPrint("❌ Update Employee Error: $e");
      rethrow;
    }
  }

  /// Delete Employee
  Future<void> deleteEmployee(String id) async {
    try {
      final response = await ApiService.delete(
        endpoint: '/api/business-owners/employees/$id',
        requireAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      debugPrint("❌ Delete Employee Error: $e");
      rethrow;
    }
  }
}
