import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/home/nearby_providers_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';

class NearbyProvidersController extends GetxController {
  var isLoading = false.obs;
  // var nearbyProviders = <NearbyProvider>[].obs; // Deprecated
  var categories = <CategoryWithProviders>[].obs;
  var errorMessage = ''.obs;
  var searchRadiusKm = '10.0'.obs; // Default value

  final String nearbyProvidersUrl =
      "${AppConstants.BASE_URL}/api/home/nearby-providers";

  @override
  void onInit() {
    fetchNearbyProviders();
    super.onInit();
  }

  Future<void> fetchNearbyProviders({
    double latitude = 40.7128,
    double longitude = -74.0060,
    int maxDistance = 10000,
  }) async {
    try {
      isLoading(true);
      errorMessage('');

      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final uri = Uri.parse(
          "$nearbyProvidersUrl?latitude=$latitude&longitude=$longitude&maxDistance=$maxDistance");

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Nearby Providers API Status: ${response.statusCode}");
      print("Nearby Providers API Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final nearbyResponse = NearbyProvidersResponse.fromJson(body);

        if (nearbyResponse.data != null) {
          categories.value = nearbyResponse.data!.categories ?? [];
          
          // Store search radius
          if (nearbyResponse.data!.searchRadius != null) {
            searchRadiusKm.value = nearbyResponse.data!.searchRadius!.kilometers ?? '10.0';
          }
          
          // No need to flatten providers as they are not returned anymore
          // nearbyProviders.clear(); 
          // logic removed
        }
      } else {
        errorMessage.value = "Failed to load nearby providers";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error fetching nearby providers: $e");
    } finally {
      isLoading(false);
    }
  }
}
