import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:middle_ware/utils/constants.dart';
import 'package:middle_ware/utils/token_service.dart';
import 'package:middle_ware/models/provider/provider_booking_model.dart';
import 'package:middle_ware/models/provider/provider_appointment_model.dart';

class OrderProviderController extends GetxController {
  var isLoading = false.obs;
  
  // Lists corresponding to tabs
  var appointmentList = <ProviderAppointment>[].obs;
  var pendingList = <ProviderBooking>[].obs;
  var confirmedList = <ProviderBooking>[].obs;
  var inProgressList = <ProviderBooking>[].obs;
  var completedList = <ProviderBooking>[].obs;
  var cancelledList = <ProviderBooking>[].obs;
  var rejectedList = <ProviderBooking>[].obs;
  
  var allBookings = <ProviderBooking>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    isLoading(true);
    await Future.wait([
      fetchAppointments(),
      fetchBookings(),
    ]);
    isLoading(false);
  }

  Future<void> fetchAppointments() async {
    try {
      String? token = await TokenService().getToken();
      
      var response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/api/providers/appointments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var model = ProviderAppointmentModel.fromJson(jsonResponse);
        if (model.data != null) {
          appointmentList.value = model.data!;
        }
      } else {
        print("Failed to fetch appointments: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching appointments: $e");
    }
  }

  Future<void> fetchBookings() async {
    try {
      String? token = await TokenService().getToken();
      
      var response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/api/providers/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var model = ProviderBookingModel.fromJson(jsonResponse);
        if (model.data != null) {
          allBookings.value = model.data!;
          filterBookings();
        }
      } else {
        print("Failed to fetch bookings: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }

  void filterBookings() {
    pendingList.value = allBookings.where((e) => (e.bookingStatus?.toLowerCase() ?? '') == 'pending').toList();
    confirmedList.value = allBookings.where((e) => (e.bookingStatus?.toLowerCase() ?? '') == 'confirmed').toList();
    
    // Check for 'in-progress' or similar variations. User tab says 'In Progress'.
    inProgressList.value = allBookings.where((e) {
        String s = e.bookingStatus?.toLowerCase() ?? '';
        return s == 'in-progress' || s == 'ongoing' || s == 'in progress';
    }).toList();
    
    completedList.value = allBookings.where((e) => (e.bookingStatus?.toLowerCase() ?? '') == 'completed').toList();
    cancelledList.value = allBookings.where((e) => (e.bookingStatus?.toLowerCase() ?? '') == 'cancelled').toList();
    rejectedList.value = allBookings.where((e) => (e.bookingStatus?.toLowerCase() ?? '') == 'rejected').toList();
  }
}
