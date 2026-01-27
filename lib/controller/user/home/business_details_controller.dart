import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/user/home/business_details_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';

class BusinessDetailsController extends GetxController {
  var isLoading = false.obs;
  var businessData = Rxn<BusinessDetailsData>();
  var errorMessage = ''.obs;
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;

  Future<void> fetchBusinessDetails(String ownerId) async {
    try {
      isLoading(true);
      errorMessage('');
      
      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }

      final String url = "${ApiService.BASE_URL}/api/user/businesses/$ownerId/details";
      
      print("Fetching business details: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Business Details status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final detailsResponse = BusinessDetailsResponse.fromJson(body);
        businessData.value = detailsResponse.data;
      } else {
        errorMessage.value = "Failed to load business details";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error fetching business details: $e");
    } finally {
      isLoading(false);
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  List<TeamMember> get filteredTeam {
    if (businessData.value?.team == null) return [];
    if (searchQuery.isEmpty) return businessData.value!.team!;
    return businessData.value!.team!.where((tm) => 
      (tm.employeeName?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
      (tm.serviceHeadline?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false)
    ).toList();
  }
}
