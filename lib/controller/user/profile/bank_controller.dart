import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../utils/constants.dart';
import '../../../utils/token_service.dart';
import '../../../models/user/profile/bank_information_model.dart';
import '../../../models/card_model.dart';

class BankController extends GetxController {
  Rxn<CardModel> defaultCard = Rxn<CardModel>();
  Rxn<BankInformation> bankInfo = Rxn<BankInformation>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBankInfo();
  }

  Future<void> fetchBankInfo() async {
    isLoading.value = true;
    try {
      final token = await TokenService().getToken();
      if (token == null) {
        // Handle no token case
        return;
      }

      final url = Uri.parse('${AppConstants.BASE_URL}/api/auth/bank-information');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
           final bankData = responseData['data']['bankInformation'];
           if (bankData != null) {
             bankInfo.value = BankInformation.fromJson(bankData);
           }
        }
      } else {
        // Handle error
        print('Failed to fetch bank info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bank info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void saveCard(CardModel card) {
    defaultCard.value = card;
  }

  void saveBankInfo(BankInformation info) {
    bankInfo.value = info;
  }

  void removeCard() {
    defaultCard.value = null;
  }
}
