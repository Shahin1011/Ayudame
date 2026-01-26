import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:middle_ware/utils/constants.dart';
import 'package:middle_ware/utils/token_service.dart';

class HomeProviderController extends GetxController {
  var isLoading = false.obs;
  
  // Stats
  var totalBookings = 0.obs;
  var completedBookings = 0.obs;
  var cancelledBookings = 0.obs;
  
  var myOrdersTotal = 0.obs;
  var myOrdersThisMonth = 0.obs;
  var incomeTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingStats();
  }

  Future<void> fetchBookingStats() async {
    try {
      isLoading(true);
      String? token = await TokenService().getToken();
      
      var response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/api/providers/bookings/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          var homeStats = jsonResponse['data']['homeStats'];
          if (homeStats != null) {
            totalBookings.value = homeStats['totalServiceAndAppointmentBooking'] ?? 0;
            completedBookings.value = homeStats['completedServiceAndAppointmentBooking'] ?? 0;
            cancelledBookings.value = homeStats['cancelledServiceAndAppointmentBooking'] ?? 0;
          }

          var profileStats = jsonResponse['data']['profileStats'];
          if (profileStats != null) {
            var myOrders = profileStats['myOrders'];
            if (myOrders != null) {
                myOrdersTotal.value = myOrders['total'] ?? 0;
                myOrdersThisMonth.value = myOrders['thisMonth'] ?? 0;
            }
            var income = profileStats['totalIncome'];
            if (income != null) {
                incomeTotal.value = income['total'] ?? 0;
            }
          }
        }
      } else {
        print("Failed to fetch stats: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching stats: $e");
    } finally {
      isLoading(false);
    }
  }
}
