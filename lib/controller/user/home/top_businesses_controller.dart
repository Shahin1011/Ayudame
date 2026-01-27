import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/home/top_businesses_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';
import 'package:middle_ware/services/api_service.dart';

class TopBusinessesController extends GetxController {
  var isLoading = false.obs;
  var businesses = <TopBusiness>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopBusinesses();
  }

  Future<void> fetchTopBusinesses({int limit = 10}) async {
    try {
      isLoading(true);
      errorMessage('');
      
      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final String url = "${ApiService.BASE_URL}/api/user/top-businesses?limit=$limit";
      
      print("Fetching top businesses: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Top Businesses status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final topBusinessesResponse = TopBusinessesResponse.fromJson(body);
        
        if (topBusinessesResponse.data?.businesses != null) {
          businesses.value = topBusinessesResponse.data!.businesses!;
        }
      } else {
        errorMessage.value = "Failed to load top businesses";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error fetching top businesses: $e");
    } finally {
      isLoading(false);
    }
  }
}
