import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/models/business_booking_model.dart';
import 'package:middle_ware/services/business_booking_service.dart';

class BusinessBookingViewModel extends GetxController {
  final BusinessBookingService _service = BusinessBookingService();

  final RxList<BusinessBookingModel> bookingList = <BusinessBookingModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    isLoading.value = true;
    try {
      final bookings = await _service.getBookings();
      bookingList.assignAll(bookings);
    } finally {
      isLoading.value = false;
    }
  }

  final Rxn<BusinessBookingModel> currentBooking = Rxn<BusinessBookingModel>();

  Future<void> fetchBookingDetails(String id) async {
    isLoading.value = true;
    try {
      final booking = await _service.getBookingById(id);
      currentBooking.value = booking;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> acceptBooking(String id) async {
    try {
      isLoading.value = true;

      final error = await _service.acceptBooking(id);

      if (error == null) {
        Get.snackbar(
          "Success",
          "Booking accepted successfully",
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Refresh list to sync with backend
        await fetchBookings();
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
        "An error occurred occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> rejectBooking(String id) async {
    try {
      isLoading.value = true;

      final error = await _service.rejectBooking(id);

      if (error == null) {
        Get.snackbar(
          "Success",
          "Booking declined successfully",
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Remove the booking from local list immediately for better UX
        bookingList.removeWhere((booking) => booking.id == id);

        // Refresh list to sync with backend
        await fetchBookings();
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
        "An error occurred occurred: $e",
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
