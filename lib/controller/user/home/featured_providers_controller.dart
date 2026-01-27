import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';
import 'package:middle_ware/services/api_service.dart';
import '../../../models/user/home/featured_providers_model.dart';

class FeaturedProvidersController extends GetxController {
  var isLoading = false.obs;
  var featuredProviders = <FeaturedProvider>[].obs;
  var allFeaturedServices = <({FeaturedProvider provider, FeaturedService service})>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedProviders();
  }

  Future<void> fetchFeaturedProviders({double lat = 40.7128, double lng = -74.0060}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "Authentication token not found";
        return;
      }

      final url = Uri.parse(
          "${ApiService.BASE_URL}/api/home/featured-providers?latitude=$lat&longitude=$lng");
      
      print("Fetching featured providers from: $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final featuredResponse = FeaturedProvidersResponse.fromJson(decodedData);
        if (featuredResponse.success == true) {
          featuredProviders.value = featuredResponse.data?.providers ?? [];
          
          // Flatten providers and their services into a single list
          final List<({FeaturedProvider provider, FeaturedService service})> flattened = [];
          for (var provider in featuredProviders) {
            if (provider.services != null) {
              for (var service in provider.services!) {
                flattened.add((provider: provider, service: service));
              }
            }
          }
          allFeaturedServices.value = flattened;
        } else {
          errorMessage.value = featuredResponse.message ?? "Failed to load featured providers";
        }
      } else {
        errorMessage.value = "Failed to load featured providers: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      print("Error fetching featured providers: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
