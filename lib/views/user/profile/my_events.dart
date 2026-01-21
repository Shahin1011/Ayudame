import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';
import '../../../controller/user/home/event_controller.dart';
import '../home/widgets/custom_events_card.dart';
import 'package:get/get.dart';


class MyEvents extends StatelessWidget{

  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor1,
      appBar: CustomAppBar(title: "My Events"),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),

        child: Obx(() {
          if(eventController.isLoading.value){
            return Center(child: CircularProgressIndicator());
          }

          if(eventController.errorMessage.isNotEmpty){
            return Center(
              child: Text(
                eventController.errorMessage.value,
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (eventController.eventList.isEmpty) {
            return  Center(child: Text("No events available"));
          }

          return ListView.builder(
            padding: EdgeInsets.only(top: 10.h,),
            itemCount: eventController.eventList.length,
            itemBuilder: (context, index) {
              final event = eventController.eventList[index];

              return Padding(
                padding: EdgeInsets.only(bottom: 16.w),
                child: SizedBox(
                  width: 300.w,
                  child: CustomEventCard(
                    title: event.eventType,
                    eventName: event.eventName,
                    eventImage: event.eventImage,
                    date: event.formattedDate,
                    timeRange: event.formattedTime,
                    location: event.eventLocation,
                    attendingCount: event.ticketsSold,
                    eventId: event.eventId,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
  
}