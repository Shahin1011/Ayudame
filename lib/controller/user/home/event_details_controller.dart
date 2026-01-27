import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/home/event_detail_model.dart';
import '../../../utils/token_service.dart';
import '../../../utils/constants.dart';
import 'package:middle_ware/services/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class EventDetailsController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var eventDetails = Rxn<EventModel>();

  // Example endpoint: GET /api/orders/:id
  Future<void> fetchEventDetails(String eventId) async {

    if (!await _hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }

    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "No authentication token";
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("${ApiService.BASE_URL}/api/home/event/$eventId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("My Event Details RESPONSE =====================: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final responseModel = EventDetailsResponse.fromJson(jsonData);
        eventDetails.value = responseModel.data.event;
      } else {
        errorMessage.value =
        "Failed to fetch event details: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

}