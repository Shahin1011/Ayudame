import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/models/business_appointment_model.dart';
import 'package:middle_ware/services/business_appointment_service.dart';

class BusinessAppointmentViewModel extends GetxController {
  final BusinessAppointmentService _service = BusinessAppointmentService();

  final RxList<BusinessAppointmentModel> appointmentList =
      <BusinessAppointmentModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    isLoading.value = true;
    try {
      final appointments = await _service.getAppointments();
      appointmentList.assignAll(appointments);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> acceptAppointment(String id) async {
    try {
      isLoading.value = true;

      final error = await _service.acceptAppointment(id);

      if (error == null) {
        Get.snackbar(
          "Success",
          "Appointment accepted successfully",
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Refresh list to sync with backend
        await fetchAppointments();
        return true;
      } else {
        Get.snackbar(
          "Error",
          error,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while accepting the appointment",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> rejectAppointment(String id) async {
    try {
      isLoading.value = true;

      final error = await _service.rejectAppointment(id);

      if (error == null) {
        Get.snackbar(
          "Success",
          "Appointment declined successfully",
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Remove the appointment from local list immediately for better UX
        appointmentList.removeWhere((appointment) => appointment.id == id);

        // Refresh list to sync with backend
        await fetchAppointments();
        return true;
      } else {
        Get.snackbar(
          "Error",
          error,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while declining the appointment",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> rescheduleAppointment(
    String id,
    String date,
    String time,
  ) async {
    try {
      isLoading.value = true;

      final error = await _service.rescheduleAppointment(id, date, time);

      if (error == null) {
        Get.snackbar(
          "Success",
          "Appointment rescheduled successfully",
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        await fetchAppointments();
        return true;
      } else {
        Get.snackbar(
          "Error",
          error,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while rescheduling",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
