import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/provider/provider_profile_model.dart';
import '../../../utils/token_service.dart';
import '../../../utils/constants.dart';

class ProviderProfileController extends GetxController {
  var isLoading = false.obs;
  var providerProfile = Rxn<ProviderInfo>();
  var errorMessage = ''.obs;

  final String profileUrl = "${AppConstants.BASE_URL}/api/providers/me";

  @override
  void onInit() {
    super.onInit();
    fetchProviderProfile();
  }

  Future<void> fetchProviderProfile() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final response = await http.get(
        Uri.parse(profileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Provider Profile Status: ${response.statusCode}");
      print("Provider Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final model = ProviderProfileModel.fromJson(body);
        providerProfile.value = model.data.provider;
      } else {
        errorMessage.value = "Failed to load provider profile";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error fetching provider profile: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<bool> updateProviderProfile({
    required String fullName,
    required String phoneNumber,
    String? dateOfBirth,
    String? occupation,
  }) async {
    try {
      isLoading(true);
      errorMessage('');

      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return false;
      }

      final body = {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        if (dateOfBirth != null && dateOfBirth.isNotEmpty) 'dateOfBirth': dateOfBirth,
        if (occupation != null && occupation.isNotEmpty) 'occupation': occupation,
      };

      print("Update Provider Profile Request Body: ${jsonEncode(body)}");

      final response = await http.put(
        Uri.parse(profileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("Update Provider Profile Status: ${response.statusCode}");
      print("Update Provider Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final model = ProviderProfileModel.fromJson(responseBody);
        providerProfile.value = model.data.provider;
        return true;
      } else {
        // Try to parse error message from response
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage.value = errorBody['message'] ?? "Failed to update provider profile (${response.statusCode})";
        } catch (e) {
          errorMessage.value = "Failed to update provider profile (Status: ${response.statusCode})";
        }
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error updating provider profile: $e");
      return false;
    } finally {
      isLoading(false);
    }
  }
}
