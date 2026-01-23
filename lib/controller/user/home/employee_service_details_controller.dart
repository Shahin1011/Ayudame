import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';
import '../../../models/user/home/employee_profile_model.dart';

class EmployeeServiceDetailsController extends GetxController {
  var isLoading = false.obs;
  var employeeProfile = Rxn<EmployeeProfileData>();
  var errorMessage = ''.obs;

  Future<void> fetchEmployeeProfile(String employeeId) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final url = Uri.parse("${AppConstants.BASE_URL}/api/user/employees/$employeeId/profile");
      print("Fetching employee profile: $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final profileResponse = EmployeeProfileResponse.fromJson(decodedData);
        employeeProfile.value = profileResponse.data;
      } else {
        errorMessage.value = "Failed to load employee profile: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
