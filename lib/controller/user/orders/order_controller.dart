import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/orders/order_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  var orderList = <OrderModel>[].obs;
  var currentTab = 'Appointment'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // Initial fetch
  }

  void changeTab(String tab) {
    currentTab.value = tab;
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      orderList.clear();

      final token = await TokenService().getToken();
      if (token == null) {
        isLoading(false);
        return;
      }

      Uri uri;
      if (currentTab.value == 'Appointment') {
        uri = Uri.parse("${AppConstants.BASE_URL}/api/appointments/my-appointments");
      } else {
        String status = 'pending';
        // Mapping tabs to API status
        switch (currentTab.value) {
          case 'Pending':
            status = 'pending';
            break;
          case 'Confirmed':
            status = 'confirmed';
            break;
          case 'In Progress':
            status = 'ongoing'; // Assuming ongoing for In Progress
            break;
          case 'Completed':
            status = 'completed';
            break;
          case 'Cancelled':
            status = 'cancelled';
            break;
          case 'Rejected':
            status = 'rejected';
            break;
          default:
            status = 'pending';
        }
        uri = Uri.parse("${AppConstants.BASE_URL}/api/bookings/my-bookings?status=$status&page=1&limit=50");
      }

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Orders API [${currentTab.value}]: ${response.statusCode}");
      print("Orders API Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final orderResponse = OrderResponse.fromJson(body);
        if (orderResponse.data != null) {
          orderList.value = orderResponse.data!;
        }
      } else {
        Get.snackbar('Error', 'Failed to load orders');
      }
    } catch (e) {
      print("Error fetching orders: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }
}
