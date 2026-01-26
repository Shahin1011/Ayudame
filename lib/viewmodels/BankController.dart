import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/bank_model.dart';

class BankController extends GetxController {
  final accountHolderCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final accountNumberCtrl = TextEditingController();
  final routingNumberCtrl = TextEditingController();

  final List<String> usBanks = [
    "JPMorgan Chase",
    "Bank of America",
    "Wells Fargo",
  ];

  var isLoading = false.obs;
  var bankInfo = Rxn<BankInfoModel>();

  // Form clear korar jonno
  void clearFields() {
    accountHolderCtrl.clear();
    bankNameCtrl.clear();
    accountNumberCtrl.clear();
    routingNumberCtrl.clear();
  }

  // Edit-er somoy data fill korar jonno
  void loadBankInfo() {
    if (bankInfo.value != null) {
      accountHolderCtrl.text = bankInfo.value!.accountHolderName;
      bankNameCtrl.text = bankInfo.value!.bankName;
      accountNumberCtrl.text = bankInfo.value!.accountNumber;
      routingNumberCtrl.text = bankInfo.value!.routingNumber;
    }
  }

  Future<void> addOrUpdateBank({bool isEdit = false}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // API call mimic

    bankInfo.value = BankInfoModel(
      accountHolderName: accountHolderCtrl.text,
      bankName: bankNameCtrl.text,
      accountNumber: accountNumberCtrl.text,
      routingNumber: routingNumberCtrl.text,
      accountHolderType: accountHolderCtrl.text,
    );

    isLoading.value = false;
    _showSuccessDialog(
      isEdit
          ? 'Your bank account information change has been successfully.'
          : 'The bank account you added has been successfully added.',
    );
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
                    Get.back(); // Go to Main Screen
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
