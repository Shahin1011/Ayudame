import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:middle_ware/utils/constants.dart';
import 'package:middle_ware/utils/token_service.dart';

import '../../models/provider/provider_booking_model.dart';
import '../../models/provider/provider_appointment_model.dart'; // Optional if we want appointments too

class HomeProviderController extends GetxController {
  var isLoading = false.obs;
  
  // Stats
  var totalBookings = 0.obs;
  var completedBookings = 0.obs;
  var cancelledBookings = 0.obs;
  
  var allBookings = <ProviderBooking>[].obs;
  var allAppointments = <ProviderAppointment>[].obs;
  var pendingItems = <dynamic>[].obs;

  var myOrdersTotal = 0.obs;
  var myOrdersThisMonth = 0.obs;
  var incomeTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingStats();
    fetchRecentBookings();
  }
  
  Future<void> fetchRecentBookings() async {
    try {
      String? token = await TokenService().getToken();
      
      final responses = await Future.wait([
        http.get(
          Uri.parse('${AppConstants.BASE_URL}/api/providers/bookings'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        http.get(
          Uri.parse('${AppConstants.BASE_URL}/api/providers/appointments'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      ]);

      if (responses[0].statusCode == 200) {
        var jsonResponse = json.decode(responses[0].body);
        var model = ProviderBookingModel.fromJson(jsonResponse);
        if (model.data != null) {
          allBookings.value = model.data!;
        }
      }

      if (responses[1].statusCode == 200) {
        var jsonResponse = json.decode(responses[1].body);
        var model = ProviderAppointmentModel.fromJson(jsonResponse);
        if (model.data != null) {
          allAppointments.value = model.data!;
        }
      }

      _updatePendingItems();
    } catch (e) {
      print("Error fetching recent data: $e");
    }
  }

  void _updatePendingItems() {
    List<dynamic> combined = [];
    
    combined.addAll(allBookings.where((e) => e.bookingStatus?.toLowerCase() == 'pending'));
    combined.addAll(allAppointments.where((e) => e.appointmentStatus?.toLowerCase() == 'pending'));
    
    // Sort by createdAt if available, otherwise just use them as is
    pendingItems.value = combined;
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
