import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import '../../../viewmodels/BankController.dart';
import '../../../widgets/custom_appbar.dart';

class AddBankInfoScreen extends StatelessWidget {
  const AddBankInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BankController>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const CustomAppBar(title: "Bank Information"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fieldLabel("Account Holder Name"),
            _buildField(controller.accountHolderCtrl, "Jacob Meikle"),

            _fieldLabel("Account Type"),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.accountHolderType.value,
                    isExpanded: true,
                    items: ['personal', 'business']
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type.capitalizeFirst ?? type,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.accountHolderType.value = val;
                    },
                  ),
                ),
              ),
            ),

            _fieldLabel("Bank Name"),
            _buildField(controller.bankNameCtrl, "e.g. JPMorgan Chase"),

            _fieldLabel("Enter Your Bank Account Number"),
            _buildField(controller.accountNumberCtrl, "0123456789"),

            _fieldLabel("Routing Number"),
            _buildField(controller.routingNumberCtrl, "0123456789"),

            SizedBox(height: 25.h),
            _buildSecurityBox(),

            SizedBox(height: 40.h),
            Obx(
              () => _buildButton(
                "Confirm",
                isLoading: controller.isLoading.value,
                onPressed: () => controller.addOrUpdateBank(isEdit: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
    ),
  );

  Widget _buildField(
    TextEditingController ctrl,
    String hint, {
    bool isDropDown = false,
  }) {
    return TextField(
      controller: ctrl,
      readOnly: isDropDown,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isDropDown ? const Icon(Icons.keyboard_arrow_down) : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSecurityBox() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.mainAppColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.mainAppColor,
            size: 20,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your information is secure",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "We use bank-level encryption and Stripe to protect your payment information",
                  style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label, {
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainAppColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
