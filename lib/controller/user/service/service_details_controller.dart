import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/service/service_details_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';

class ServiceDetailsController extends GetxController {
  var isLoading = false.obs;
  var serviceDetails = Rxn<ServiceDetailsData>();
  var errorMessage = ''.obs;

  Future<void> fetchServiceDetails(String serviceId) async {
    try {
      isLoading(true);
      errorMessage('');
      serviceDetails.value = null;

      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final String url = "${AppConstants.BASE_URL}/api/user/services/$serviceId";
      
      print("Fetching service details: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Service Details status: ${response.statusCode}");
      print("Service Details body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final serviceResponse = ServiceDetailsResponse.fromJson(body);
        
        if (serviceResponse.data != null) {
          serviceDetails.value = serviceResponse.data;
        } else {
             errorMessage.value = "No data found";
        }
      } else {
        errorMessage.value = "Failed to load service details";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error fetching service details: $e");
    } finally {
      isLoading(false);
    }
  }
}
