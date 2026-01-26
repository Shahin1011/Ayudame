import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/viewmodels/business_booking_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingsScreen extends StatefulWidget {
  final String? bookingId;
  const BookingsScreen({super.key, this.bookingId});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final Color primaryGreen = const Color(0xFF1D4D3F);
  final BusinessBookingViewModel _viewModel = Get.put(BusinessBookingViewModel()); // Use Get.put or Get.find depending on if it's already in memory

  @override
  void initState() {
    super.initState();
    if (widget.bookingId != null) {
      _viewModel.fetchBookingDetails(widget.bookingId!);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text("Bookings", style: TextStyle(color: Colors.white)),
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

        return Stack(
          children: [
            SingleChildScrollView(
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
                    // Profile Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: booking.customerProfilePhoto != null && booking.customerProfilePhoto!.isNotEmpty
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

                    // Title Section
                    Text("Title:", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      booking.serviceName ?? "Service Name",
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),

                    const SizedBox(height: 20),

                    // Note Section
                    Text("Note", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD1E2DD)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        booking.problemNote ?? "No notes provided.",
                        style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Date and Due Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_outlined, size: 20, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text("Date: ${booking.date ?? 'N/A'}", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                Text(
                                    "Total: \$${booking.totalPrice?.toStringAsFixed(0) ?? '0'}",
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                Text(
                                    "Due: \$${((booking.totalPrice ?? 0) - (booking.downPayment ?? 0)).toStringAsFixed(0)}",
                                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                            ]
                        )
                      ],
                    ),
                    
                    if (booking.status?.toLowerCase() == 'cancelled') ...[
                        const SizedBox(height: 30),
                         Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red[200]!)
                            ),
                            child: const Center(
                                child: Text("This booking is cancelled", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                            ),
                         )
                    ] else ...[
                        const SizedBox(height: 30),
                        // Bottom Buttons
                        Row(
                        children: [
                            Expanded(
                            child: OutlinedButton(
                                onPressed: () => _showCustomDialog(context, isSuccess: true),
                                style: OutlinedButton.styleFrom(
                                side: BorderSide(color: primaryGreen),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text("Done", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                            ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                            child: ElevatedButton(
                                onPressed: () => _showCustomDialog(context, isSuccess: false),
                                style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Ask for due payment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            ),
                        ],
                        ),
                    ],
                  ],
                ),
              ),
            ),

          ],
        );
      }),
    );
  }

  // একদম ছবির মতো ডায়ালগ ডিজাইন
  void _showCustomDialog(BuildContext context, {required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryGreen.withOpacity(0.2)),
              ),
              child: Icon(
                isSuccess ? Icons.check : Icons.monetization_on_outlined,
                color: primaryGreen,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            // Message
            Text(
              isSuccess
                  ? "Are you sure you have completed the work properly?"
                  : "Ask for the remaining money?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 25),
            // Dialog Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF8A8A)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("No", style: TextStyle(color: Color(0xFFFF8A8A))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Yes", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}