import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller; // Added this to fix your error
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
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        fillColor: fillColor ?? const Color(0xFFF9FAFB),
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldBorderRadius ?? 10.r),
          borderSide: BorderSide(color: fieldBorderColor ?? const Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldBorderRadius ?? 10.r),
          borderSide: const BorderSide(color: Color(0xFF1B4D3E), width: 1.5),
        ),
      ),
    );
  }
}