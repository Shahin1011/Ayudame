import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../viewmodels/BankController.dart';
import '../../../widgets/custom_appbar.dart';


class EditBankInfoScreen extends StatelessWidget {
  const EditBankInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BankController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Bank Information"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Account Holder Name"),
            _field(controller.accountHolderCtrl, "Jacob Meikle"),

            _label("Bank Name"),
            _field(controller.bankNameCtrl, "Choose your bank", isDropDown: true),

            _label("Enter Your Bank Account Number"),
            _field(controller.accountNumberCtrl, "0123456789"),

            _label("Routing Number"),
            _field(controller.routingNumberCtrl, "0123456789"),

            SizedBox(height: 25.h),
            _securityBox(),

            SizedBox(height: 100.h),
            Obx(() => _btn(
              "Save Changes",
              isLoading: controller.isLoading.value,
              onPressed: () => controller.addOrUpdateBank(isEdit: true),
            )),
          ],
        ),
      ),
    );
  }

  // Reusing helper methods (tumi egulo k common widget file e nite paro)
  Widget _label(String t) => Padding(padding: EdgeInsets.only(bottom: 8.h, top: 16.h), child: Text(t, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)));
  Widget _field(TextEditingController c, String h, {bool isDropDown = false}) => TextField(
    controller: c, readOnly: isDropDown,
    decoration: InputDecoration(hintText: h, filled: true, fillColor: const Color(0xFFF9F9F9), suffixIcon: isDropDown ? const Icon(Icons.keyboard_arrow_down) : null, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none)),
  );
  Widget _securityBox() => Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: const Color(0xFFE8F3ED), borderRadius: BorderRadius.circular(8.r)), child: const Row(children: [Icon(Icons.verified_user_outlined, color: Color(0xFF1E5631)), SizedBox(width: 10), Expanded(child: Text("Your information is secure\nWe use bank-level encryption to protect you", style: TextStyle(fontSize: 11)))]));
  Widget _btn(String l, {required bool isLoading, required VoidCallback onPressed}) => SizedBox(width: double.infinity, height: 50.h, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E5631), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))), onPressed: isLoading ? null : onPressed, child: isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(l, style: const TextStyle(color: Colors.white))));
}