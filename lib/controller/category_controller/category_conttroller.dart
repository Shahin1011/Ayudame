import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/user/categories/category_model.dart';
import '../../utils/constants.dart';
import '../../utils/token_service.dart';



class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  var errorMessage = ''.obs;

  final String categoryUrl = "${AppConstants.BASE_URL}/api/user/categories";

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      errorMessage('');


      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }
      final response = await http.get(Uri.parse(categoryUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


      print("Category API Status: ${response.statusCode}");
      print("Category API Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true) {
          final List list = jsonData["data"]["categories"];
          categories.value = list.map((e) => CategoryModel.fromJson(e)).toList();
        } else {
          errorMessage.value = "Failed to load categories";
        }
      } else {
        errorMessage.value = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}
