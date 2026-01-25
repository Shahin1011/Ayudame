import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/orders/order_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';
import 'package:flutter/material.dart';


class BookingDetailsController extends GetxController {
  var isLoading = false.obs;
  var booking = Rxn<OrderModel>();

  Future<void> fetchBookingDetails(String id) async {
    try {
      isLoading(true);
      
      final token = await TokenService().getToken();
      if (token == null) return;

      final uri = Uri.parse("${AppConstants.BASE_URL}/api/bookings/$id");
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Booking Details API [$id]: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          booking.value = OrderModel.fromJson(body['data']);
        }
      } else {
        Get.snackbar('Error', 'Failed to load booking details');
      }
    } catch (e) {
      print("Error fetching booking details: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      isLoading(true);
      
      final token = await TokenService().getToken();
      if (token == null) return;

      final uri = Uri.parse("${AppConstants.BASE_URL}/api/bookings/$id/cancel");
      
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Cancel Booking API [$id]: ${response.statusCode}");
      print("Cancel Booking Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Booking cancelled successfully',
          backgroundColor: const Color(0xFF1E523F),
          colorText: Colors.white,
        );
        // Refresh details to update UI status
        fetchBookingDetails(id);
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          body['message'] ?? 'Failed to cancel booking',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      print("Error cancelling booking: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }

  Future<void> payDue(String id) async {
    // Implement pay due payment API call here if needed
    Get.snackbar('Action', 'Pay Due Payment functionality to be implemented');
  }

  Future<void> submitReview(String id, int rating, String comment) async {
    try {
      isLoading(true);
      final token = await TokenService().getToken();
      if (token == null) return;

      final uri = Uri.parse("${AppConstants.BASE_URL}/api/bookings/$id/review");
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "rating": rating,
          "comment": comment,
        }),
      );

      print("Submit Review API [$id]: ${response.statusCode}");
      print("Submit Review Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close dialog
        Get.snackbar(
          'Success', 
          'Review submitted successfully',
          backgroundColor: const Color(0xFF1E523F),
          colorText: Colors.white,
        );
        fetchBookingDetails(id); // Refresh
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar(
          'Error', 
          body['message'] ?? 'Failed to submit review',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error submitting review: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }

  void showRatingDialog(String bookingId, String providerName) {
    int selectedRating = 5;
    final TextEditingController commentController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, color: Colors.black54),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFE8F5EE),
                    child: Icon(Icons.check, color: Color(0xFF2D6E5C), size: 30),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Task Completed",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Average Rating and Feedback\n$providerName",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Avg. Rating",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRatingItem(1, "Bad", selectedRating, (val) => setState(() => selectedRating = val)),
                      _buildRatingItem(2, "Average", selectedRating, (val) => setState(() => selectedRating = val)),
                      _buildRatingItem(3, "Good", selectedRating, (val) => setState(() => selectedRating = val)),
                      _buildRatingItem(4, "Great", selectedRating, (val) => setState(() => selectedRating = val)),
                      _buildRatingItem(5, "Amazing", selectedRating, (val) => setState(() => selectedRating = val)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Feedback Note",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Type here...",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1E523F)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => submitReview(bookingId, selectedRating, commentController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E523F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildRatingItem(int value, String label, int currentRating, Function(int) onTap) {
    bool isSelected = currentRating == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Column(
        children: [
           Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.star,
                size: 40,
                color: isSelected ? const Color(0xFFFF9D5C) : Colors.grey.shade200,
              ),
              Text(
                "$value",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
