import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/routes/app_routes.dart';
import '../../../models/user/profile/profile_model.dart';
import '../../../utils/token_service.dart';
import '../../../utils/constants.dart';



class ProfileController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var user = Rxn<UserModel>();
  final String profileUrl = "${AppConstants.BASE_URL}/api/auth/me";

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }


  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> getProfile() async {
    if (!await hasInternetConnection()) {
      errorMessage.value = "No internet connection";
      return;
    }

    final token = await TokenService().getToken();
    print("Loaded token in ProfileController: $token");
    if (token == null || token.isEmpty) {
      errorMessage.value = "No authentication token";
      return;
    }

    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse(profileUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // ✅ FIXED: Access the nested 'user' object
        user.value = UserModel.fromJson(data['data']['user']);
      } else {
        Get.snackbar("Error", "Failed to load profile: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchProfile() async {
    print('ProfileController: fetchProfile() called');

    if (!await hasInternetConnection()) {
      print('ProfileController: No internet connection');
      errorMessage.value = "No internet connection";
      return;
    }

    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      print('ProfileController: No authentication token available');
      errorMessage.value = "No authentication token";
      return;
    }

    print('ProfileController: Fetching profile from: $profileUrl');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse(profileUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print('ProfileController: Response status: ${response.statusCode}');
      print('ProfileController: Response body: ${response.body}');

      if (response.statusCode != 200) {
        final errorBody = response.body;
        print('ProfileController: API Error - Status: ${response.statusCode}, Body: $errorBody');
        errorMessage.value = "Failed to load profile: ${response.statusCode}";
        return;
      }

      final jsonData = json.decode(response.body);
      print('ProfileController: Parsed JSON: $jsonData');

      if (jsonData["success"] == false) {
        final errorMsg = jsonData["message"] ?? "Failed to load profile";
        print('ProfileController: API returned success=false: $errorMsg');
        errorMessage.value = errorMsg;
        return;
      }

      final data = jsonData["data"];
      if (data == null) {
        print('ProfileController: No data field in response');
        errorMessage.value = "No profile data received";
        return;
      }

      // ✅ FIXED: Access the nested 'user' object
      final userData = data["user"];
      if (userData == null) {
        print('ProfileController: No user data in response');
        errorMessage.value = "No user data received";
        return;
      }

      print('ProfileController: Creating UserModel from data: $userData');
      user.value = UserModel.fromJson(userData); // ✅ Now passing correct data
      print('ProfileController: Profile loaded successfully: ${user.value?.fullName}');
      errorMessage.value = ''; // Clear any previous errors

    } catch (e, stackTrace) {
      print('ProfileController: Exception occurred: $e');
      print('ProfileController: Stack trace: $stackTrace');
      errorMessage.value = "Failed to load profile: $e";
    } finally {
      isLoading.value = false;
      print('ProfileController: fetchProfile() completed. isLoading: ${isLoading.value}, profile: ${user.value != null ? "loaded" : "null"}');
    }
  }

  Future<void> logout() async {
    await TokenService().clearToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("password");
    await prefs.remove("isLoggedIn");

    Get.offAllNamed(AppRoutes.userlogin);
  }


}
