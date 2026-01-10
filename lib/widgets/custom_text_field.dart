import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:middle_ware/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? fieldBorderRadius;
  final Color? fieldBorderColor;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool readOnly;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.fieldBorderRadius,
    this.fieldBorderColor,
    this.fillColor,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      style: TextStyle(fontSize: 14.sp, fontFamily: "Inter"),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.grey, fontSize: 14.sp, fontFamily: "Inter"),
        fillColor: fillColor ?? const Color(0xFFF9FAFB),
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldBorderRadius ?? 10.r),
          borderSide: BorderSide(color: fieldBorderColor ?? const Color(0xFF525252)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldBorderRadius ?? 10.r),
          borderSide: const BorderSide(color: AppColors.mainAppColor, width: 1.5),
        ),
      ),
    );
  }
}