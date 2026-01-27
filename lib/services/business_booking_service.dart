import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:middle_ware/models/business_booking_model.dart';
import 'package:middle_ware/services/api_service.dart';

class BusinessBookingService {
  Future<List<BusinessBookingModel>> getBookings() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/bookings',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> bookingsJson =
            data['data'] ?? data['bookings'] ?? [];
        return bookingsJson
            .map((json) => BusinessBookingModel.fromJson(json))
            .toList();
      } else {
        debugPrint('❌ Failed to fetch bookings: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error in getBookings: $e');
      return [];
    }
  }

  Future<BusinessBookingModel?> getBookingById(String bookingId) async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/business-owners/bookings/$bookingId',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final bookingJson = data['data'] ?? data['booking'] ?? data;
        return BusinessBookingModel.fromJson(bookingJson);
      } else {
        debugPrint('❌ Failed to fetch booking detail: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error in getBookingById: $e');
      return null;
    }
  }

  Future<String?> acceptBooking(String bookingId) async {
    try {
      debugPrint('🔄 Accepting booking: $bookingId');

      final response = await ApiService.patch(
        endpoint: '/api/business-owners/bookings/$bookingId/accept',
        body: {},
        requireAuth: true,
      );

      debugPrint('📥 Accept Booking Response Status: ${response.statusCode}');
      debugPrint('📥 Accept Booking Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('✅ Booking accepted successfully');
        return null; // Success
      } else {
        String errorMessage = 'Failed to accept booking';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}
        debugPrint('❌ Failed to accept booking: $errorMessage');
        return errorMessage; // Error
      }
    } catch (e) {
      debugPrint('❌ Error in acceptBooking: $e');
      return 'Network error: $e';
    }
  }

  Future<String?> rejectBooking(String bookingId) async {
    try {
      debugPrint('🔄 Rejecting booking: $bookingId');

      final response = await ApiService.patch(
        endpoint: '/api/business-owners/bookings/$bookingId/reject',
        body: {},
        requireAuth: true,
      );

      debugPrint('📥 Reject Booking Response Status: ${response.statusCode}');
      debugPrint('📥 Reject Booking Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('✅ Booking rejected successfully');
        return null; // Success
      } else {
        String errorMessage = 'Failed to reject booking';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}
        debugPrint('❌ Failed to reject booking: $errorMessage');
        return errorMessage; // Error
      }
    } catch (e) {
      debugPrint('❌ Error in rejectBooking: $e');
      return 'Network error: $e';
    }
  }
}
