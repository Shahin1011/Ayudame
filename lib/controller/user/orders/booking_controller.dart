import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';

class BookingController extends GetxController {
  var isLoading = false.obs;

  Future<dynamic> createBooking({
    required String serviceId,
    required String bookingDate,
    required double downPayment,
    required String userNotes,
  }) async {
    try {
      isLoading(true);

      final token = await TokenService().getToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Authorization token not found. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }

      final uri = Uri.parse("${AppConstants.BASE_URL}/api/bookings");

      final body = {
        "serviceId": serviceId,
        "bookingDate": bookingDate,
        "downPayment": downPayment,
        "userNotes": userNotes,
      };

      print("Creating Booking Request Body: ${jsonEncode(body)}");

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("Booking API Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Get.snackbar(
          'Success',
          'Booking created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return responseData;
      } else {
        final errorBody = jsonDecode(response.body);
        String message = errorBody['message'] ?? 'Failed to create booking';
        Get.snackbar(
          'Error',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print("Error creating booking: $e");
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading(false);
    }
  }
}
