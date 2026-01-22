import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/home/category_providers_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';

class CategoryProvidersController extends GetxController {
  var isLoading = false.obs;
  var providers = <CategoryProvider>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchCategoryProviders(String categoryId, {
    double latitude = 40.7128,
    double longitude = -74.0060,
    int maxDistance = 10000,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      providers.clear();

      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final String url = "${AppConstants.BASE_URL}/api/home/nearby-providers/category/$categoryId?latitude=$latitude&longitude=$longitude&maxDistance=$maxDistance";
      
      print("Fetching category providers: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Category Providers status: ${response.statusCode}");
      print("Category Providers body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final categoryResponse = CategoryProvidersResponse.fromJson(body);
        
        if (categoryResponse.data?.providers != null) {
          providers.value = categoryResponse.data!.providers!;
        }
      } else {
        errorMessage.value = "Failed to load providers";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error fetching category providers: $e");
    } finally {
      isLoading(false);
    }
  }
}
