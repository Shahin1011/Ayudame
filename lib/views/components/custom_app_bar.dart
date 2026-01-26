import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.showBackButton = true, // ✅ optional by default
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.13;
    return Container(
      width: double.infinity,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.mainAppColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Conditionally show back button
              showBackButton
                  ? InkWell(
                onTap: onBackTap ?? () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/backIcon.svg",
                  color: AppColors.white,
                ),
              )
                  : const SizedBox(width: 24),

              // Title in center
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Spacer for balance
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(MediaQueryData.fromView(WidgetsBinding.instance.window).size.height * 0.15);
}