import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user/orders/order_model.dart';
import '../../../controller/user/orders/booking_details_controller.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final BookingDetailsController controller = Get.put(BookingDetailsController());

  @override
  void initState() {
    super.initState();
    final dynamic args = Get.arguments;
    if (args is OrderModel && args.id != null) {
      controller.fetchBookingDetails(args.id!);
    } else if (args is String) {
      controller.fetchBookingDetails(args);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1E523F)));
        }

        final order = controller.booking.value;
        if (order == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Booking details not found"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Go Back"),
                )
              ],
            ),
          );
        }

        final String status = (order.bookingStatus ?? 'pending').toLowerCase();

        return Column(
          children: [
            // Custom Curved Header
            Container(
              height: 120,
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E523F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                  ),
                  const Expanded(
                    child: Text(
                      "Booking details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                      // Provider Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: (order.provider?.user?.profilePicture != null && order.provider!.user!.profilePicture!.isNotEmpty)
                                ? NetworkImage(order.provider!.user!.profilePicture!)
                                : null,
                            child: (order.provider?.user?.profilePicture == null || order.provider!.user!.profilePicture!.isEmpty)
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.provider?.user?.fullName ?? 'No Provider Name',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  order.provider?.user?.address ?? order.provider?.occupation ?? '',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Date: ${order.bookingDate?.split('T')[0] ?? ''}",
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                              // Placeholder for time if available
                              Text(
                                "Time: 12:00pm", 
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        "Titel:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D6E5C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.serviceSnapshot?.serviceName ?? "Expert House Cleaning Services",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Note
                      const Text(
                        "Note",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D6E5C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF2D6E5C).withOpacity(0.3)),
                        ),
                        child: Text(
                          order.userNotes ?? "No notes provided",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Payment Info
                      if (status == 'pending' || status == 'confirmed' || status == 'ongoing' || status == 'in progress')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Down Payment:\$${order.downPayment ?? 0}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              "Due:\$${order.remainingAmount ?? 0}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E4F),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          "Price : \$${order.totalAmount ?? 0}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      const SizedBox(height: 32),

                      // Buttons Logic
                      _buildActionButtons(status, order),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionButtons(String status, OrderModel order) {
    final String bookingId = order.id ?? "";
    if (status == 'pending' || status == 'confirmed' || status == 'ongoing' || status == 'in progress') {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Confirmation"),
                        content: const Text("Are you sure you want to complete this task?"),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("No", style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back(); // Close confirmation
                              controller.showRatingDialog(
                                bookingId, 
                                order.provider?.user?.fullName ?? 'No Provider Name'
                              );
                            },
                            child: const Text("Yes", style: TextStyle(color: Color(0xFF1E523F))),
                          ),
                        ],
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(color: Color(0xFF1B5E4F), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.payDue(bookingId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E523F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Pay Due Payment",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.cancelBooking(bookingId),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7D7D), // Light red as per image
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Cancel Booking",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    } else {
      // Completed, Rejected, Cancelled
      Color btnColor = Colors.grey.shade400;
      if (status == 'rejected' || status == 'cancelled') btnColor = Colors.grey.shade400;
      if (status == 'completed') btnColor = const Color(0xFF1E523F);

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null, // Disabled as status indicator
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            disabledBackgroundColor: btnColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            status.capitalizeFirst!,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
