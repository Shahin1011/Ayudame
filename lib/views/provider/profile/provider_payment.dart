import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class provider_PaymentHistoryScreen extends StatelessWidget {
  const provider_PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const CustomAppBar(title: 'Payment History'),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: _paymentCard(context),
      ),
    );
  }

  Widget _paymentCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _infoRow('Date', '24 May, 2020'),
          SizedBox(height: 5.h),
          _infoRow('Amount', '\$ 281'),
          SizedBox(height: 5.h),
          _infoRow('Bank Account Number', '********6789'),
          SizedBox(height: 5.h),
          _infoRow(
            'Status',
            'Completed',
            valueColor: AppColors.dark,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      String label,
      String value, {
        Color valueColor = Colors.black,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
