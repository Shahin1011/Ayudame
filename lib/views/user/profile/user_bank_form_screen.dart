import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/card_model.dart';
import '../../../viewmodels/bank_controller.dart';
import '../../components/custom_app_bar.dart';
import 'package:get/get.dart';
import '../../components/custom_text_field.dart';



class UserAddBankInformation extends StatelessWidget{
  UserAddBankInformation({super.key});


  final TextEditingController cardNameCtrl = TextEditingController();
  final TextEditingController cardNumCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController cvvCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController();
  final TextEditingController streetCtrl = TextEditingController();
  final TextEditingController additionalCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController postcodeCtrl = TextEditingController();

  final BankController bankController = Get.put(BankController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: "Card Details",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.030),
              Text(
                "Please enter payment information",
                style: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainAppColor,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 16.h),

              customTitleTile(title: "Name of Card"),
              SizedBox(height: 8.h),
              CustomTextField(
                textEditingController: cardNameCtrl,
                hintText: 'Name of card',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColors.mainAppColor,
                ),
              ),
              SizedBox(height: 16.h),

              customTitleTile(title: "Card Number"),
              SizedBox(height: 8.h),
              CustomTextField(
                textEditingController: cardNumCtrl,
                hintText: '1234  5678  9101  1121',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColors.mainAppColor,
                ),
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTitleTile(title: "Expiration Date"),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          textEditingController: dateCtrl,
                          hintText: 'DD/MM/YY',
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat-Regular',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Color(0xFF5E5E5E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTitleTile(title: "CVV"),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          textEditingController: cvvCtrl,
                          hintText: '123',
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat-Regular',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Color(0xFF5E5E5E),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.h),

              customTitleTile(title: "Country"),
              SizedBox(height: 8.h),
              CustomTextField(
                textEditingController: countryCtrl,
                hintText: 'Bangladesh',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color(0xFF5E5E5E),
                ),
              ),
              SizedBox(height: 16.h),

              customTitleTile(title: "Street Name And Number"),
              SizedBox(height: 8.h),
              CustomTextField(
                textEditingController: streetCtrl,
                hintText: 'Street Name And Number',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color(0xFF5E5E5E),
                ),
              ),
              SizedBox(height: 16.h),

              customTitleTile(title: "Additional Address Details (optional)"),
              SizedBox(height: 8.h),
              CustomTextField(
                textEditingController: additionalCtrl,
                hintText: 'Additional Address Details (optional)',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color(0xFF5E5E5E),
                ),
              ),
              SizedBox(height: 16.h),

              customTitleTile(title: "City/Town"),
              SizedBox(height: 8.h),
              CustomTextField(
                textEditingController: cityCtrl,
                hintText: 'City/Town',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color(0xFF5E5E5E),
                ),
              ),
              SizedBox(height: 16.h),

              customTitleTile(title: "Postcode"),
              SizedBox(height: 8.h),
              CustomTextField(
                textEditingController: postcodeCtrl,
                hintText: '89739',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color(0xFF5E5E5E),
                ),
              ),
              SizedBox(height: 16.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Color(0xFFE7F4F6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/secureIcon.svg"),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your information is secure",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "We use bank-level encryption and Stripe to\nprotect your payment information",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              GestureDetector(
                onTap: () {
                  if (cardNameCtrl.text.isEmpty || cardNumCtrl.text.isEmpty) return;

                  final card = CardModel(
                    cardName: cardNameCtrl.text.trim(),
                    cardNumber: cardNumCtrl.text.trim(),
                    expiryDate: dateCtrl.text.trim(),
                    cvv: cvvCtrl.text.trim(),
                    country: countryCtrl.text.trim(),
                    street: streetCtrl.text.trim(),
                    city: cityCtrl.text.trim(),
                    postcode: postcodeCtrl.text.trim(),
                  );

                  bankController.saveCard(card);

                  Get.back();
                },

                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.mainAppColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "Save",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE6E6E6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.070),

            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Title Text
  Widget customTitleTile({required String title}) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.mainAppColor,),
    );
  }

}