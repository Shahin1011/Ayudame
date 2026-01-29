import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:middle_ware/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/user/home/ticket_purchase_model.dart';
import '../../../utils/token_service.dart';

class BuyTicketController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> purchaseTicket(String eventId, int quantity, List<TicketOwner> owners) async {
    if (eventId.isEmpty) {
      Get.snackbar("Error", "Event ID is missing");
      return;
    }

    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "No authentication token";
      return;
    }

    try {
      isLoading(true);

      final purchaseRequest = TicketPurchaseRequest(
        quantity: quantity,
        ticketOwners: owners,
      );

      
      final response = await http.post(
        Uri.parse("${ApiService.BASE_URL}/api/events/$eventId/buy-tickets"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(purchaseRequest.toJson()),
      );

      print("Purchase Response Status: ${response.statusCode}");
      print("Purchase Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final model = TicketPurchaseResponse.fromJson(body);

        if (model.success && model.data != null) {
          final url = model.data!.checkout.sessionUrl;
          final uri = Uri.parse(url);
          
          try {
            if (await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
            } else {
               // Fallback or retry?
               print("Could not launch $url");
               Get.snackbar("Error", "Could not open payment page");
            }
          } catch (e) {
             print("Launch URL invalid: $e");
             Get.snackbar("Error", "Invalid payment URL");
          }
        } else {
           Get.snackbar("Error", model.message);
        }
      } else {
        Get.snackbar("Error", "Purchase failed: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in purchaseTicket: $e");
      print(stackTrace);
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }
}
