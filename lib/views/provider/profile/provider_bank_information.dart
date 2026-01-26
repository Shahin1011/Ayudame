// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:middle_ware/core/theme/app_colors.dart';
// import 'package:middle_ware/views/provider/profile/provider_edit_bank_information.dart';
// import 'package:middle_ware/widgets/CustomDashedBorder.dart';
// import 'package:middle_ware/widgets/custom_appbar.dart';
//
// import '../../../viewmodels/BankController.dart';
// import 'Business_bank_information.dart';
//
// class BankInformationScreen extends StatelessWidget {
//   const BankInformationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(BankController());
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F9F9),
//       appBar: CustomAppBar(title: "Bank Information"),
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Obx(() {
//           // EMPTY STATE
//           if (controller.bankInfo.value == null) {
//             return GestureDetector(
//               onTap: () {
//                 controller.clearFields();
//                 Get.to(() => const AddBankInfoScreen());
//               },
//
//               child: CustomPaint(
//                 painter: DashedBorderPainter(
//                   color: AppColors.mainAppColor,
//                   strokeWidth: 1.5,
//                   dashWidth: 6,
//                   dashSpace: 4,
//                   borderRadius: 12.r,
//                 ),
//                 child: Container(
//                   width: double.infinity,
//                   height: 60.h,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Text(
//                     'Add Bank Account',
//                     style: TextStyle(
//                       color: AppColors.mainAppColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//
//           // FILLED STATE
//           final data = controller.bankInfo.value!;
//           return Container(
//             padding: EdgeInsets.all(20.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Payout Information',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15.sp,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         controller.loadBankInfo();
//                         Get.to(() => const providerEditBankInfoScreen());
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16.w,
//                           vertical: 6.h,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         child: Text(
//                           'Edit',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 12.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10.h),
//                 const Divider(),
//                 _infoRow('Account Name', data.accountHolderName),
//                 _infoRow(
//                   'Bank Account Number',
//                   '********${data.accountNumber.length > 4 ? data.accountNumber.substring(data.accountNumber.length - 4) : data.accountNumber}',
//                 ),
//                 _infoRow('Bank Name', data.bankName),
//                 _infoRow('Routing Number', data.routingNumber),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _infoRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
//           ),
//           Text(
//             value,
//             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
//           ),
//         ],
//       ),
//     );
//   }
// }