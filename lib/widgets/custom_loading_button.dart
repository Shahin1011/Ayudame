import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLoadingButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const CustomLoadingButton({
    super.key,
    required this.title,
    required this.isLoading,
    required this.onTap,
    this.backgroundColor = const Color(0xFF1C5941),
    this.textColor = const Color(0xFFE6E6E6),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isLoading ? backgroundColor.withOpacity(0.7) : backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Center(
          child: Text(
            isLoading ? "Loading..." : title,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
