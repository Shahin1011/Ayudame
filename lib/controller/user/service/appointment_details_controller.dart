import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/orders/order_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';

class AppointmentDetailsController extends GetxController {
  var isLoading = false.obs;
  var appointment = Rxn<OrderModel>();

  Future<void> fetchAppointmentDetails(String id) async {
    try {
      isLoading(true);
      
      final token = await TokenService().getToken();
      if (token == null) return;

      final uri = Uri.parse("${AppConstants.BASE_URL}/api/appointments/$id");
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Appointment Details API [$id]: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          // The API returns { data: { appointment: { ... } } }
          final appointmentData = body['data']['appointment'] ?? body['data'];
          appointment.value = OrderModel.fromJson(appointmentData);
        }
      } else {
        Get.snackbar('Error', 'Failed to load appointment details');
      }
    } catch (e) {
      print("Error fetching appointment details: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }
}
