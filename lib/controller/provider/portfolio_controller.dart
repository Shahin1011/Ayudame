import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:middle_ware/utils/constants.dart';
import 'package:middle_ware/utils/token_service.dart';
import '../../models/provider/portfolio_model.dart';
import 'package:mime/mime.dart';

class PortfolioController extends GetxController {
  var isLoading = false.obs;
  var portfolioList = <PortfolioModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllPortfolios();
  }

  Future<void> getAllPortfolios() async {
    try {
      isLoading(true);
      String? token = await TokenService().getToken();
      
      var response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/api/providers/portfolio'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
       
          
          List<dynamic> list = [];
          if (jsonResponse['data'] != null && jsonResponse['data']['portfolio'] != null) {
             list = jsonResponse['data']['portfolio'];
          }

          portfolioList.value = list.map((e) => PortfolioModel.fromJson(e)).toList();
        }
      } else {
        Get.snackbar("Error", "Failed to fetch portfolios");
      }
    } catch (e) {
      print("Error fetching portfolios: $e");
      Get.snackbar("Error", "An error occurred while fetching portfolios");
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addPortfolio({
    required String title,
    required String about,
    required String serviceType,
    required File beforeImage,
    required File afterImage,
  }) async {
    try {
      isLoading(true);
      String? token = await TokenService().getToken();
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.BASE_URL}/api/providers/portfolio'),
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['title'] = title;
      request.fields['about'] = about;
      request.fields['serviceType'] = serviceType;

      // Add Before Image
      var mimeTypeBefore = lookupMimeType(beforeImage.path);
      request.files.add(await http.MultipartFile.fromPath(
        'beforeImage',
        beforeImage.path,
        contentType: MediaType.parse(mimeTypeBefore ?? 'image/jpeg'),
      ));

      // Add After Image
      var mimeTypeAfter = lookupMimeType(afterImage.path);
      request.files.add(await http.MultipartFile.fromPath(
        'afterImage',
        afterImage.path,
        contentType: MediaType.parse(mimeTypeAfter ?? 'image/jpeg'),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
           getAllPortfolios(); // Refresh list
           return true;
        }
      }
      
      var errorMsg = "Failed to add portfolio";
      try {
        var jsonResponse = json.decode(response.body);
        errorMsg = jsonResponse['message'] ?? errorMsg;
      } catch (_) {}
      
      Get.snackbar("Error", errorMsg);
      return false;
      
    } catch (e) {
      print("Error adding portfolio: $e");
      Get.snackbar("Error", "An error occurred");
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> editPortfolio({
    required String id,
    required String title,
    required String about,
    required String serviceType,
    File? beforeImage,
    File? afterImage,
  }) async {
    try {
      isLoading(true);
      String? token = await TokenService().getToken();
      
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${AppConstants.BASE_URL}/api/providers/portfolio/$id'),
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['title'] = title;
      request.fields['about'] = about;
      request.fields['serviceType'] = serviceType;

      if (beforeImage != null) {
        var mimeType = lookupMimeType(beforeImage.path);
        request.files.add(await http.MultipartFile.fromPath(
          'beforeImage',
          beforeImage.path,
          contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
        ));
      }

      if (afterImage != null) {
        var mimeType = lookupMimeType(afterImage.path);
        request.files.add(await http.MultipartFile.fromPath(
          'afterImage',
          afterImage.path,
          contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
           getAllPortfolios();
           return true;
        }
      }
      
      var errorMsg = "Failed to update portfolio";
      try {
        var jsonResponse = json.decode(response.body);
        errorMsg = jsonResponse['message'] ?? errorMsg;
      } catch (_) {}
      
      Get.snackbar("Error", errorMsg);
      return false;

    } catch (e) {
      print("Error updating portfolio: $e");
      Get.snackbar("Error", "An error occurred");
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> deletePortfolio(String id) async {
    try {
      isLoading(true);
      String? token = await TokenService().getToken();
      
      var response = await http.delete(
        Uri.parse('${AppConstants.BASE_URL}/api/providers/portfolio/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          getAllPortfolios();
          return true;
        }
      }
      
      Get.snackbar("Error", "Failed to delete portfolio");
      return false;

    } catch (e) {
      print("Error deleting portfolio: $e");
      Get.snackbar("Error", "An error occurred");
      return false;
    } finally {
      isLoading(false);
    }
  }
}
