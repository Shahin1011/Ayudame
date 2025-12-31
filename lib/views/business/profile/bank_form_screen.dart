import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import '../../../viewmodels/BankController.dart';
import '../../../widgets/custom_appbar.dart';

class BankFormScreen extends StatelessWidget {
  final String title;
  final String buttonText;
  final bool isEdit;

  const BankFormScreen({
    required this.title,
    required this.buttonText,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BankController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Bank Information"),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Account Holder Name"),
            _buildField(controller.accountHolderCtrl, "Jacob Meikle"),

            _label("Bank Name"),
            _buildField(
              controller.bankNameCtrl,
              "Choose your bank",
              isDropDown: true,
              items: controller.usBanks,
            ),

            _label("Enter Your Bank Account Number"),
            _buildField(controller.accountNumberCtrl, "0123456789"),

            _label("Routing Number"),
            _buildField(controller.routingNumberCtrl, "0123456789"),

            SizedBox(height: 25.h),

            // Security Info Box
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3ED),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: AppColors.mainAppColor,
                    size: 18,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(
                            text: "Your information is secure\n",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "We use bank-level encryption and Stripe to protect your payment information",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainAppColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.addOrUpdateBank(isEdit: isEdit),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          buttonText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13.sp,
        color: Colors.black,
      ),
    ),
  );

  Widget _buildField(
    TextEditingController ctrl,
    String hint, {
    bool isDropDown = false,
    List<String>? items,
  }) {
    if (isDropDown && items != null) {
      return DropdownButtonFormField<String>(
        value: ctrl.text.isEmpty ? null : ctrl.text,
        items: items
            .map(
              (bank) => DropdownMenuItem(
                value: bank,
                child: Text(bank, style: TextStyle(fontSize: 14.sp)),
              ),
            )
            .toList(),
        onChanged: (val) {
          if (val != null) ctrl.text = val;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        dropdownColor: Colors.white,
      );
    }

    return TextField(
      controller: ctrl,
      readOnly: isDropDown,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        suffixIcon: isDropDown
            ? const Icon(Icons.keyboard_arrow_down, color: Colors.grey)
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
