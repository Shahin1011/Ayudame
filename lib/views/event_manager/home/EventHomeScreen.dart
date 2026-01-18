import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/app_icons.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/event_manager/home/EventNotificationPage.dart';
import 'package:middle_ware/viewmodels/event_viewmodel.dart';
import 'package:middle_ware/viewmodels/event_manager_viewmodel.dart';
import 'EditEventPage.dart';
import 'EventDetailPage.dart';
import 'cancel.dart';

class EventHomeScreen extends StatefulWidget {
  const EventHomeScreen({super.key});

  @override
  State<EventHomeScreen> createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {
  final EventViewModel _eventViewModel = Get.put(EventViewModel());
  final EventManagerViewModel _managerViewModel = Get.put(
    EventManagerViewModel(),
  );

  @override
  void initState() {
    super.initState();
    _eventViewModel.fetchEvents(refresh: true);
    _managerViewModel.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Obx(
          () => AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: AppColors.mainAppColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFD4B896),
                    backgroundImage:
                        _managerViewModel
                                    .currentManager
                                    .value
                                    ?.profilePicture !=
                                null &&
                            _managerViewModel
                                .currentManager
                                .value!
                                .profilePicture!
                                .isNotEmpty
                        ? NetworkImage(
                                _managerViewModel
                                    .currentManager
                                    .value!
                                    .profilePicture!,
                              )
                              as ImageProvider
                        : const AssetImage('assets/images/men.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _managerViewModel.currentManager.value?.fullName ??
                              'Seam Rahman',
                          style: const TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventNotificationPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        AppIcons.notification,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2D6A4F),
                          BlendMode.srcIn,
                        ),
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _eventViewModel.fetchEvents(refresh: true),
        child: Obx(() {
          if (_eventViewModel.isLoading.value &&
              _eventViewModel.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_eventViewModel.events.isEmpty) {
            return const Center(
              child: Text("No events found. Start by creating one!"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _eventViewModel.events.length,
            itemBuilder: (context, index) {
              final event = _eventViewModel.events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildEventCard(context, event: event),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, {required dynamic event}) {
    return GestureDetector(
      onTap: () {
        Get.to(() => EventDetailPage(event: event));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  if (event.eventImage != null &&
                      event.eventImage.startsWith('http'))
                    Image.network(
                      event.eventImage,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  else
                    _buildPlaceholderImage(),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (event.status ?? 'draft').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      event.eventType ?? 'Event Category',
                      style: const TextStyle(
                        color: Color(0xFF1C5941),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.eventName ?? 'Untitled Event',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date & Time
                  Row(
                    children: [
                      _buildInfoCol(
                        'Date',
                        event.eventStartDateTime?.split(' ')[0] ?? 'N/A',
                      ),
                      _buildInfoCol(
                        'Time',
                        event.eventStartDateTime?.contains(' ') == true
                            ? event.eventStartDateTime.split(' ')[1]
                            : 'N/A',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Guests & Price
                  Row(
                    children: [
                      _buildInfoCol(
                        'Guest Limit',
                        event.maximumNumberOfTickets?.toString() ?? 'No Limit',
                      ),
                      _buildInfoCol(
                        'Ticket price',
                        '\$${event.ticketPrice?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppIcons.location,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          Colors.grey[600]!,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.eventLocation ?? 'No location provided',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.to(() => EditEventPage(event: event));
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F8F4),
                            foregroundColor: const Color(0xFF1C5941),
                            side: const BorderSide(color: Color(0xFF1C5941)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Edit Event',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => showCancelEventDialog(
                            context: context,
                            event: event,
                            eventViewModel: _eventViewModel,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C5941),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Cancel Event',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 160,
      color: Colors.grey[200],
      child: Center(
        child: SvgPicture.asset(
          AppIcons.create,
          width: 50,
          height: 50,
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        ),
      ),
    );
  }
}
