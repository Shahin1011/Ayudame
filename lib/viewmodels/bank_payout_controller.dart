import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/bank_model.dart';
import '../services/business_auth_service.dart';

class BankPayoutController extends GetxController {
  final BusinessAuthService _authService = BusinessAuthService();

  final accountHolderCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final accountNumberCtrl = TextEditingController();
  final routingNumberCtrl = TextEditingController();
  // Default to personal if not specified/available in UI
  final accountHolderType = 'personal'.obs;

  final List<String> usBanks = [
    "JPMorgan Chase",
    "Bank of America",
    "Wells Fargo",
    "Citi",
    "U.S. Bank",
    "PNC Bank",
    "Capital One",
    "TD Bank",
    "Truist",
    "Goldman Sachs",
  ];

  var isLoading = false.obs;
  var bankInfo = Rxn<BankInfoModel>();

  @override
  void onInit() {
    super.onInit();
    fetchBankInfo();
  }

  // Form clear korar jonno
  void clearFields() {
    accountHolderCtrl.clear();
    bankNameCtrl.clear();
    accountNumberCtrl.clear();
    routingNumberCtrl.clear();
    accountHolderType.value = 'personal';
  }

  // Edit-er somoy data fill korar jonno
  void loadBankInfo() {
    if (bankInfo.value != null) {
      accountHolderCtrl.text = bankInfo.value!.accountHolderName;
      bankNameCtrl.text = bankInfo.value!.bankName;
      accountNumberCtrl.text = bankInfo.value!.accountNumber;
      routingNumberCtrl.text = bankInfo.value!.routingNumber;
      accountHolderType.value = bankInfo.value!.accountHolderType;
    }
  }

  Future<void> fetchBankInfo() async {
    try {
      isLoading.value = true;
      final data = await _authService.getBankInfo();
      if (data.isNotEmpty && data['bankInformation'] != null) {
        bankInfo.value = BankInfoModel.fromJson(data['bankInformation']);
        loadBankInfo();
      }
    } catch (e) {
      debugPrint("❌ Error fetching bank info: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrUpdateBank({bool isEdit = false}) async {
    if (accountHolderCtrl.text.isEmpty ||
        bankNameCtrl.text.isEmpty ||
        accountNumberCtrl.text.isEmpty ||
        routingNumberCtrl.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final bankData = BankInfoModel(
        accountHolderName: accountHolderCtrl.text.trim(),
        bankName: bankNameCtrl.text.trim(),
        accountNumber: accountNumberCtrl.text.trim(),
        routingNumber: routingNumberCtrl.text.trim(),
        accountHolderType: accountHolderType.value,
      ).toJson();

      if (isEdit) {
        await _authService.updateBankInfo(bankData);
      } else {
        await _authService.createBankInfo(bankData);
      }

      // Refresh local data
      await fetchBankInfo();

      _showSuccessDialog(
        isEdit
            ? 'Your bank account information change has been successfully.'
            : 'The bank account you added has been successfully added.',
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog(String message) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 60,
                color: Color(0xFF1E5631),
              ),
              SizedBox(height: 16.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5631),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Go to previous screen
                  },
                  child: Text(
                    'Go Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
