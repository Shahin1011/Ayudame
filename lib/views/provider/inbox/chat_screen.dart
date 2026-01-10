import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

// --- Model Class ---
class providerChatMessage {
  final String id;
  final String senderName;
  final String? senderImage;
  final String message;
  final String time;
  final bool isUserMessage;

  providerChatMessage({
    required this.id,
    required this.senderName,
    this.senderImage,
    required this.message,
    required this.time,
    required this.isUserMessage,
  });
}

// --- Controller Class ---
class providerChatScreenController extends GetxController {
  final RxList<providerChatMessage> messages = <providerChatMessage>[
    providerChatMessage(
      id: '1',
      senderName: 'Tamim Sarkar',
      senderImage: 'assets/images/mursalin.jpg',
      message: 'Hey! How was the new design project coming along?',
      time: '10:30 AM',
      isUserMessage: false,
    ),
    providerChatMessage(
      id: '2',
      senderName: 'You',
      message: 'Hey! How was the new design project coming along?',
      time: '10:30 AM',
      isUserMessage: true,
    ),
    providerChatMessage(
      id: '3',
      senderName: 'Tamim Sarkar',
      senderImage: 'assets/images/mursalin.jpg',
      message: 'Hey! How was the new design project coming along?',
      time: '10:30 AM',
      isUserMessage: false,
    ),
    providerChatMessage(
      id: '4',
      senderName: 'You',
      message: 'Hey! How was the new design project coming along?',
      time: '10:30 AM',
      isUserMessage: true,
    ),
    providerChatMessage(
      id: '5',
      senderName: 'Tamim Sarkar',
      senderImage: 'assets/images/mursalin.jpg',
      message: 'Hey! How was the new design project coming along?',
      time: '10:30 AM',
      isUserMessage: false,
    ),
  ].obs;

  final messageController = TextEditingController();

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add(
      providerChatMessage(
        id: DateTime.now().toString(),
        senderName: 'You',
        message: text,
        time: TimeOfDay.now().format(Get.context!),
        isUserMessage: true,
      ),
    );

    messageController.clear();
    update();
  }
}

// --- View Class ---
class providerChatScreen extends StatefulWidget {
  final String contactName;
  final String contactImage;

  const providerChatScreen({
    super.key,
    required this.contactName,
    required this.contactImage,
  });

  @override
  State<providerChatScreen> createState() => _providerChatScreenState();
}

class _providerChatScreenState extends State<providerChatScreen> {
  late providerChatScreenController controller;
  late ScrollController _scrollController;

  bool _showAttachmentPanel = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(providerChatScreenController());
    _scrollController = ScrollController();
  }

  void _scrollToTopAnimated() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller
                      .messages[controller.messages.length - 1 - index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.mainAppColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: AssetImage(widget.contactImage),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 13.w,
                  height: 13.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF20C853),
                    border: Border.all(color: Colors.white, width: 2.w),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.contactName,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                "Online",
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (String result) {},
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete conversation'),
            ),
            const PopupMenuItem<String>(value: 'block', child: Text('Block')),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar(String? imagePath) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.grey[300],
          backgroundImage: imagePath != null && imagePath.isNotEmpty
              ? AssetImage(imagePath)
              : null,
          child: imagePath == null || imagePath.isEmpty
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 13.w,
            height: 13.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF20C853),
              border: Border.all(color: Colors.white, width: 2.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(providerChatMessage message) {
    final double horizontalPadding = 16.w;
    final EdgeInsets rowPadding = message.isUserMessage
        ? EdgeInsets.only(left: 50.w, right: 0, top: 8.h, bottom: 8.h)
        : EdgeInsets.only(right: 50.w, left: 0, top: 8.h, bottom: 8.h);

    return Padding(
      padding: rowPadding,
      child: Row(
        mainAxisAlignment: message.isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUserMessage) ...[
            _buildAvatar(message.senderImage),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUserMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: message.isUserMessage
                        ? const Color(0xFF8FBBB8)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: message.isUserMessage
                        ? null
                        : Border.all(
                            color: const Color(0xFFDDD9D9),
                            width: 1.w,
                          ),
                  ),
                  child: Text(
                    message.message,
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      color: message.isUserMessage
                          ? Colors.white
                          : const Color(0xFF222222),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  message.time,
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            if (_showAttachmentPanel) _buildAttachmentPanel(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showAttachmentPanel = !_showAttachmentPanel;
                      });
                    },
                    child: Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _showAttachmentPanel
                            ? Colors.white
                            : AppColors.mainAppColor,
                        border: _showAttachmentPanel
                            ? Border.all(
                                color: AppColors.mainAppColor,
                                width: 1.w,
                              )
                            : null,
                      ),
                      child: Icon(
                        _showAttachmentPanel ? Icons.close : Icons.add,
                        color: _showAttachmentPanel
                            ? AppColors.mainAppColor
                            : AppColors.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: GoogleFonts.montserrat(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: "Message",
                        hintStyle: GoogleFonts.montserrat(
                          color: Colors.grey.shade500,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 10.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                      ),
                      onSubmitted: (v) {
                        controller.sendMessage(v);
                        _scrollToTopAnimated();
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),

                  GestureDetector(
                    onTap: () {
                      controller.sendMessage(controller.messageController.text);
                      _scrollToTopAnimated();
                    },
                    child: CircleAvatar(
                      radius: 24.r,
                      backgroundColor: AppColors.mainAppColor,
                      child: Icon(Icons.send, color: Colors.white, size: 22.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentPanel() {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 4.h,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Row(
            children: [
              _buildAttachmentIcon(
                iconData: Icons.image_outlined,
                onTap: () {
                  /* Handle image selection */
                },
              ),
              SizedBox(width: 20.w),

              _buildAttachmentIcon(
                iconData: Icons.location_on_outlined,
                onTap: () {
                  /* Handle location sharing */
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentIcon({
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 30.w,
        backgroundColor: AppColors.mainAppColor.withOpacity(0.1),
        child: Icon(iconData, color: AppColors.mainAppColor, size: 30.sp),
      ),
    );
  }

  @override
  void dispose() {
    controller.messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
