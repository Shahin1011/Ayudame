// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:middle_ware/views/provider/inbox/search_field.dart';
// import 'package:middle_ware/views/user/home/ChatScreen.dart';
//
// import '../../../core/theme/app_colors.dart';
//
//
// /// =====================
// /// MODEL
// /// =====================
// class SiterChatListItem {
//   final String id;
//   final String userName;
//   final String userImage;
//   final String lastMessage;
//   final String time;
//   final bool isOnline;
//   final int unreadCount;
//
//   SiterChatListItem({
//     required this.id,
//     required this.userName,
//     required this.userImage,
//     required this.lastMessage,
//     required this.time,
//     required this.isOnline,
//     required this.unreadCount,
//   });
// }
//
// /// =====================
// /// CONTROLLER
// /// =====================
// class ChatListController extends GetxController {
//   final RxList<SiterChatListItem> chatList = <SiterChatListItem>[
//     SiterChatListItem(
//       id: '1',
//       userName: 'Nirob Hasan',
//       userImage: 'assets/images/mursalin.jpg',
//       lastMessage: 'Nice. I don\'t know why I ...',
//       time: '9:36 AM',
//       isOnline: true,
//       unreadCount: 0,
//     ),
//     SiterChatListItem(
//       id: '2',
//       userName: 'Nirob Hasan',
//       userImage: 'assets/images/mursalin.jpg',
//       lastMessage: 'Nice. I don\'t know why I ...',
//       time: '9:36 AM',
//       isOnline: false,
//       unreadCount: 2,
//     ),
//     SiterChatListItem(
//       id: '3',
//       userName: 'Nirob Hasan',
//       userImage: 'assets/images/mursalin.jpg',
//       lastMessage: 'Nice. I don\'t know why I ...',
//       time: '9:36 AM',
//       isOnline: false,
//       unreadCount: 0,
//     ),
//     SiterChatListItem(
//       id: '4',
//       userName: 'Nirob Hasan',
//       userImage: 'assets/images/mursalin.jpg',
//       lastMessage: 'Nice. I don\'t know why I ...',
//       time: '9:36 AM',
//       isOnline: false,
//       unreadCount: 1,
//     ),
//     SiterChatListItem(
//       id: '5',
//       userName: 'Nirob Hasan',
//       userImage: 'assets/images/mursalin.jpg',
//       lastMessage: 'Nice. I don\'t know why I ...',
//       time: '9:36 AM',
//       isOnline: false,
//       unreadCount: 0,
//     ),
//   ].obs;
//
//   final searchController = TextEditingController();
//   final RxString searchQuery = ''.obs;
//
//   void updateSearch(String query) {
//     searchQuery.value = query;
//   }
//
//   List<SiterChatListItem> getFilteredChats() {
//     if (searchQuery.isEmpty) {
//       return chatList;
//     }
//     return chatList
//         .where(
//           (chat) =>
//           chat.userName.toLowerCase().contains(searchQuery.toLowerCase()),
//     )
//         .toList();
//   }
// }
//
// /// =====================
// /// SCREEN
// /// =====================
// class providerInboxScreen extends StatefulWidget {
//   final String? userImage;
//   final String? userName;
//
//   const providerInboxScreen({super.key, this.userImage, this.userName});
//
//   @override
//   State<providerInboxScreen> createState() => _providerInboxScreenState();
// }
//
// class _providerInboxScreenState extends State<providerInboxScreen> {
//   late ChatListController controller;
//   final TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(ChatListController());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       body: Column(
//         children: [
//           _buildAppBar(),
//           Expanded(
//             child: Obx(() {
//               final filteredChats = controller.getFilteredChats();
//               if (filteredChats.isEmpty) {
//                 return Center(
//                   child: Text(
//                     'No chats found',
//                     style: GoogleFonts.montserrat(
//                       fontSize: 14.sp,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 );
//               }
//               return ListView.separated(
//                 padding: EdgeInsets.zero,
//                 itemCount: filteredChats.length,
//                 separatorBuilder: (_, __) => Divider(
//                   height: 1,
//                   color: Colors.grey.shade200,
//                   indent: 70.w,
//                 ),
//                 itemBuilder: (context, index) {
//                   return _buildChatListTile(filteredChats[index]);
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// =====================
//   /// CUSTOM APP BAR
//   /// =====================
//   Container _buildAppBar() {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppColors.mainAppColor,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(32.r),
//           bottomRight: Radius.circular(32.r),
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 1),
//                         ),
//                         child: CircleAvatar(
//                           radius: 25.r,
//                           backgroundImage: const AssetImage(
//                             'assets/images/profile.png',
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 15.w),
//                       Text(
//                         "Chat",
//                         style: GoogleFonts.montserrat(
//                           fontSize: 17.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Get.toNamed(AppRoutes.);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(8.r),
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/notification.svg",
//                         width: 22.w,
//                         height: 22.h,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//               providerSearchField(
//                 controller: searchController,
//                 onChanged: controller.updateSearch,
//                 hintText: 'Search here...',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// =====================
//   /// CHAT LIST TILE
//   /// =====================
//   Widget _buildChatListTile(SiterChatListItem chat) {
//     return InkWell(
//       onTap: () {
//         Get.to(
//               () => ChatScreen(
//
//           ),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         child: Row(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(right: 8.w),
//               child: Container(
//                 width: 8.w,
//                 height: 8.h,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color:
//                   chat.isOnline ? const Color(0xFF4CAF50) : Colors.transparent,
//                 ),
//               ),
//             ),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(25.r),
//               child: Image.asset(
//                 chat.userImage,
//                 width: 50.w,
//                 height: 50.h,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// ✅ USER NAME = mainAppColor
//                   Text(
//                     chat.userName,
//                     style: GoogleFonts.montserrat(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.mainAppColor,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     chat.lastMessage,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.montserrat(
//                       fontSize: 12.sp,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 8.w),
//             Text(
//               chat.time,
//               style: GoogleFonts.montserrat(
//                 fontSize: 11.sp,
//                 color: Colors.grey.shade500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.searchController.dispose();
//     super.dispose();
//   }
// }
