import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import '../../../controller/user/home/event_details_controller.dart';

class EventDetails extends StatelessWidget {
  final String eventId;
   EventDetails({super.key, required this.eventId});

  final EventDetailsController controller = Get.put(EventDetailsController());


  @override
  Widget build(BuildContext context) {
    // Fetch event details
    controller.fetchEventDetails(eventId);


    return Scaffold(
      appBar: CustomAppBar(title: "Event Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.eventDetails.value == null) {
          return const Center(child: Text("No Event Data Found"));
        }

        final event = controller.eventDetails.value!;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE3E6F0), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Event Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            event.eventImage,
                            height: 180.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Event Title
                        Text(
                          event.eventName,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        _buildDetailRow(
                          icon: Icons.person_outline,
                          title: "Event manager name",
                          value: event.eventManagerName,
                        ),

                        _buildDetailRow(
                          icon: Icons.calendar_today_outlined,
                          title: "Date & Time",
                          value: "${event.formattedDate} • ${event.formattedTime}",
                        ),

                        _buildDetailRow(
                          icon: Icons.location_on_outlined,
                          title: "Location",
                          value: event.eventLocation,
                        ),

                        _buildDetailRow(
                          icon: Icons.confirmation_number_outlined,
                          title: "Ticket Price",
                          value: "\$${event.ticketPrice}",
                        ),

                        _buildDetailRow(
                          icon: Icons.people_outline,
                          title: "Tickets Available",
                          value: event.ticketsAvailable.toString(),
                        ),

                        SizedBox(height: 24.h),

                        Divider(color: Colors.grey[300]),

                        SizedBox(height: 12.h),

                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Text(
                          event.eventDescription,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),

                        SizedBox(height: 30.h),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: event.isSoldOut
                                ? null
                                : () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: event.isSoldOut
                                  ? Colors.grey
                                  : AppColors.mainAppColor,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              event.isSoldOut ? "Sold Out" : "Buy Ticket",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h)
              ],
            ),
          ),
        );
      }),
    );
  }

  // Detail row widget
  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20.w,
          color: Colors.grey[600],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
