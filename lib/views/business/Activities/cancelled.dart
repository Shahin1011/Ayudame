import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/viewmodels/business_booking_viewmodel.dart';

class CancelledScreen extends StatefulWidget {
  final String? bookingId;
  const CancelledScreen({super.key, this.bookingId});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
  final Color primaryGreen = const Color(0xFF1D4D3F);
  final Color greyButtonColor = const Color(0xFFC4C4C4);
  final Color noteBorderColor = const Color(0xFFD1E2DD);

  final BusinessBookingViewModel _viewModel = Get.find<BusinessBookingViewModel>();

  @override
  void initState() {
    super.initState();
    if (widget.bookingId != null) {
      _viewModel.fetchBookingDetails(widget.bookingId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F3),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Cancelled",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final booking = _viewModel.currentBooking.value;

        if (booking == null) {
          return Center(
            child: Text(
              widget.bookingId == null ? "No booking ID provided" : "Booking details not found",
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // প্রোফাইল হেডার
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: (booking.customerProfilePhoto != null && booking.customerProfilePhoto!.isNotEmpty)
                          ? NetworkImage(booking.customerProfilePhoto!)
                          : const AssetImage('assets/images/profile.png') as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.customerName ?? "Unknown Customer",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            booking.address ?? "No address",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      booking.time ?? "", 
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // টাইটেল
                Text(
                  "Titel:",
                  style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.serviceName ?? "Service Name",
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 20),

                // নোট সেকশন
                Text(
                  "Note",
                  style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: noteBorderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    booking.problemNote ?? "No notes provided.",
                    style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                  ),
                ),
                const SizedBox(height: 25),

                // তারিখ এবং প্রাইস
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month_outlined, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          "Date: ${booking.date ?? 'N/A'}",
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      "Price:\$${booking.totalPrice?.toStringAsFixed(0) ?? '0'}", 
                      style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // নিচের স্ট্যাটাস বাটন
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: null, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greyButtonColor,
                      disabledBackgroundColor: greyButtonColor, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      booking.status?.capitalizeFirst ?? "Cancelled", 
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}