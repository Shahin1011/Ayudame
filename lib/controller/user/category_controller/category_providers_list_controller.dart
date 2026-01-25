import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';
import '../../../models/user/categories/category_providers_list_model.dart';

class CategoryProvidersListController extends GetxController {
  var isLoading = false.obs;
  var allCategoryServices = <({CategoryProvider provider, CategoryProviderService service})>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchProvidersByCategory(String categoryId) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    print("fetchProvidersByCategory called with ID: '$categoryId'");

    try {
      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "Authentication token not found";
        return;
      }

      if (categoryId.isEmpty) {
        errorMessage.value = "Internal Error: Received Empty Category ID";
        print("ERROR: fetchProvidersByCategory received an empty string!");
        return;
      }

      final url = Uri.parse("${AppConstants.BASE_URL}/api/home/providers/category/$categoryId");
      print("Fetching providers by category from: $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Category Providers status: ${response.statusCode}");
      print("Category Providers body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final categoryResponse = CategoryProvidersResponse.fromJson(decodedData);
        
        if (categoryResponse.success == true) {
          final providers = categoryResponse.data?.providers ?? [];
          
          // Flatten into individual services
          final List<({CategoryProvider provider, CategoryProviderService service})> flattened = [];
          for (var provider in providers) {
            if (provider.services != null) {
              for (var service in provider.services!) {
                flattened.add((provider: provider, service: service));
              }
            }
          }
          allCategoryServices.value = flattened;
        } else {
          errorMessage.value = categoryResponse.message ?? "Failed to load providers";
        }
      } else {
        errorMessage.value = "Failed to load providers: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      print("Error fetching category providers: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
