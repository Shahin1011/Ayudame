import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/user/home/recent_providers_model.dart';
import '../../utils/constants.dart';
import '../../utils/token_service.dart';



class RecentProviderController extends GetxController {
  var isLoading = false.obs;
  var providerList = <ProviderModel>[].obs;
  var errorMessage = ''.obs;

  final String recentUrl = "${AppConstants.BASE_URL}/api/auth/recent-providers";

  @override
  void onInit() {
    super.onInit();
    fetchRecentProviders();
  }

  Future<void> fetchRecentProviders() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final response = await http.get(
        Uri.parse(recentUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Recent Providers Status: ${response.statusCode}");
      print("Recent Providers Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final model = RecentProviderResponse.fromJson(body);

        // Assign list to GetX observable
        providerList.assignAll(model.data.providers);
      } else {
        errorMessage.value = "Failed to load recent providers";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}
