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

      String status = 'pending';
      if (currentTab.value == 'On going') status = 'accepted'; // or 'ongoing' depending on backend
      if (currentTab.value == 'Completed') status = 'completed';
      if (currentTab.value == 'Rejected') status = 'cancelled';

      final token = await TokenService().getToken();
      if (token == null) {
        return;
      }

      // Construct URL
      final uri = Uri.parse("${AppConstants.BASE_URL}/api/bookings/my-bookings?status=$status&page=1&limit=50");

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Orders API [$status]: ${response.statusCode}");

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
