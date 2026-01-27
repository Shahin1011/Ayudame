import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';
import 'package:middle_ware/services/api_service.dart';

class AppointmentController extends GetxController {
  var isLoading = false.obs;

  Future<dynamic> createAppointment({
    required String serviceId,
    required String appointmentDate,
    required Map<String, String> timeSlot,
    required String slotId,
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

      final uri = Uri.parse("${ApiService.BASE_URL}/api/appointments");

      final body = {
        "serviceId": serviceId,
        "appointmentDate": appointmentDate,
        "timeSlot": timeSlot,
        "slotId": slotId,
        "userNotes": userNotes,
      };

      print("Creating Appointment Request Body: ${jsonEncode(body)}");

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("Appointment API Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Get.snackbar(
          'Success',
          'Appointment created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return responseData;
      } else {
        final errorBody = jsonDecode(response.body);
        String message = errorBody['message'] ?? 'Failed to create appointment';
        Get.snackbar(
          'Error',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print("Error creating appointment: $e");
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
