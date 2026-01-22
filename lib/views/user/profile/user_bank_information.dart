import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:middle_ware/controller/user/profile/bank_controller.dart';
import 'package:middle_ware/views/user/profile/user_bank_form_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/custom_app_bar.dart';

class userBankInformation extends StatelessWidget{
  userBankInformation({super.key});

  final BankController bankController = Get.put(BankController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CustomAppBar(
          title: "Bank Information",
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.055),

                /// Payment button
                GestureDetector(
                  onTap: () {
                    Get.to(() => UserAddBankInformation());
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.mainAppColor),
                    ),
                    child: Text(
                      "Add Bank Account",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainAppColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.035),

                /// Here will show default payment Method
                /// Here will show default payment Method
                Obx(() {
                  if (bankController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final card = bankController.defaultCard.value;
                  final bankInfo = bankController.bankInfo.value;

                  // Prioritize displaying Bank Information if available, or modify based on requirement (showing both or one). 
                  // The prompt shows Payout Information card.
                  
                  if (bankInfo != null) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Payout Information",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                     Get.to(() => UserAddBankInformation(existingBankInfo: bankInfo));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      "Edit",
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 24.h),
                            
                            _buildInfoRow("Account Name", bankInfo.accountHolderName),
                            SizedBox(height: 16.h),
                            _buildInfoRow("Bank Account Number", "**********${bankInfo.last4Digits}"),
                            SizedBox(height: 16.h),
                            _buildInfoRow("Bank name", bankInfo.bankName),
                            SizedBox(height: 16.h),
                            _buildInfoRow("Routing Number", bankInfo.routingNumber),
                          ],
                        ),
                      ),
                    );
                  }

                  if (card == null) return const SizedBox.shrink();

                  return Container(
                    margin: EdgeInsets.only(bottom: 24.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.credit_card, color: AppColors.mainAppColor),
                        SizedBox(width: 12.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.cardName,
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "**** **** **** ${card.last4Digits}",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.mainAppColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Default",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.mainAppColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),

              ],
            ),
          ),
        )

    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}