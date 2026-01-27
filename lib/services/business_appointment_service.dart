import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:middle_ware/models/business_appointment_model.dart';
import 'package:middle_ware/services/api_service.dart';

class BusinessAppointmentService {
  Future<List<BusinessAppointmentModel>> getAppointments() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/appointments',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['data'] ?? data['appointments'] ?? [];
        return list
            .map((json) => BusinessAppointmentModel.fromJson(json))
            .toList();
      } else {
        debugPrint('❌ Failed to fetch appointments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error in getAppointments: $e');
      return [];
    }
  }

  Future<String?> acceptAppointment(String id) async {
    try {
      debugPrint('🔄 Accepting appointment: $id');

      final response = await ApiService.patch(
        endpoint: '/api/business-owners/appointments/$id/accept',
        body: {},
        requireAuth: true,
      );

      debugPrint(
        '📥 Accept Appointment Response Status: ${response.statusCode}',
      );
      debugPrint('📥 Accept Appointment Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('✅ Appointment accepted successfully');
        return null; // Success
      } else {
        String errorMessage = 'Failed to accept appointment';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}
        debugPrint('❌ Failed to accept appointment: $errorMessage');
        return errorMessage; // Error
      }
    } catch (e) {
      debugPrint('❌ Error in acceptAppointment: $e');
      return 'Network error: $e';
    }
  }

  Future<String?> rejectAppointment(String id) async {
    try {
      debugPrint('🔄 Rejecting appointment: $id');

      final response = await ApiService.patch(
        endpoint: '/api/business-owners/appointments/$id/reject',
        body: {},
        requireAuth: true,
      );

      debugPrint(
        '📥 Reject Appointment Response Status: ${response.statusCode}',
      );
      debugPrint('📥 Reject Appointment Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('✅ Appointment rejected successfully');
        return null; // Success
      } else {
        String errorMessage = 'Failed to reject appointment';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}
        debugPrint('❌ Failed to reject appointment: $errorMessage');
        return errorMessage; // Error
      }
    } catch (e) {
      debugPrint('❌ Error in rejectAppointment: $e');
      return 'Network error: $e';
    }
  }

  Future<String?> rescheduleAppointment(
    String id,
    String newDate,
    String newTime,
  ) async {
    try {
      debugPrint('🔄 Rescheduling appointment: $id to $newDate at $newTime');

      final response = await ApiService.patch(
        endpoint: '/api/business-owners/appointments/$id/reschedule',
        body: {
          'appointmentDate': newDate,
          'timeSlot': {
            'startTime': newTime,
            'endTime': _calculateEndTime(newTime), // Helper to add 1 hour
          },
        },
        requireAuth: true,
      );

      debugPrint('📥 Reschedule Response Status: ${response.statusCode}');
      debugPrint('📥 Reschedule Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('✅ Appointment rescheduled successfully');
        return null; // Success
      } else {
        String errorMessage = 'Failed to reschedule';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}
        debugPrint('❌ Failed to reschedule: $errorMessage');
        return errorMessage;
      }
    } catch (e) {
      debugPrint('❌ Error in rescheduleAppointment: $e');
      return 'Network error: $e';
    }
  }

  String _calculateEndTime(String startTime) {
    try {
      final parts = startTime.split(':');
      if (parts.length != 2) return startTime;

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // Add 1 hour
      hour = (hour + 1) % 24;

      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return startTime; // Fallback
    }
  }
}
