import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';
import 'package:middle_ware/services/api_service.dart';
import '../../../models/user/home/provider_profile_model.dart';

class ProviderProfileController extends GetxController {
  var isLoading = false.obs;
  var providerProfile = Rxn<ProviderProfileData>();
  var errorMessage = ''.obs;
  var selectedTab = 0.obs; // 0: All Services, 1: Reviews, 2: Portfolio

  Future<void> fetchProviderProfile(String providerId) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final url = Uri.parse("${ApiService.BASE_URL}/api/user/providers/$providerId/profile");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final profileResponse = ProviderProfileResponse.fromJson(decodedData);
        providerProfile.value = profileResponse.data;
      } else {
        errorMessage.value = "Failed to load provider profile: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
