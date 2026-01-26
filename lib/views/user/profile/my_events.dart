import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';
import '../home/widgets/custom_events_card.dart';

class MyEvents extends StatelessWidget{
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "My Events"),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.w),
              child: SizedBox(
                width: 320.w,
                child: CustomEventCard(
                  title: "Party",
                  eventName: "Creazy musical event 2025",
                  date: "December 10, 2025",
                  timeRange: "2:00 PM - 8:00 PM",
                  location: "Convention Center Hall A",
                  attendingCount: 555,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
}