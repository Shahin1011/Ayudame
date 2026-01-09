import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';


class providerSearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;

  const providerSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey)
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: AppColors.mainAppColor,
          fontSize: 14.sp,
          fontFamily: 'SegeoUi_regular',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xFF878787),
            fontSize: 14.sp,
            fontFamily: 'SegeoUi_regular',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF878787),
            size: 28.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
