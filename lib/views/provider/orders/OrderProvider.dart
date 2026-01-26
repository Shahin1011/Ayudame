import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:middle_ware/core/app_icons.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/provider/inbox/chat_screen.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../../controller/provider/order/order_provider_controller.dart';
import '../../../../models/provider/provider_booking_model.dart';
import '../../../../models/provider/provider_appointment_model.dart';

class OrderHistoryProviderScreen extends StatefulWidget {
  const OrderHistoryProviderScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryProviderScreen> createState() =>
      _OrderHistoryProviderScreenState();
}

class _OrderHistoryProviderScreenState
    extends State<OrderHistoryProviderScreen> {
  final OrderProviderController controller = Get.put(OrderProviderController());
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Order History"),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(child: _buildCurrentTabContent()),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final tabs = ['Appointment', 'Pending', 'Confirmed', 'In Progress', "Completed", "Cancelled", "Rejected"];
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2C5F4F) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      switch (_selectedTab) {
        case 0: return _buildAppointmentList(controller.appointmentList);
        case 1: return _buildBookingList(controller.pendingList, "Pending");
        case 2: return _buildBookingList(controller.confirmedList, "Confirmed");
        case 3: return _buildBookingList(controller.inProgressList, "In Progress");
        case 4: return _buildBookingList(controller.completedList, "Completed");
        case 5: return _buildBookingList(controller.cancelledList, "Cancelled");
        case 6: return _buildBookingList(controller.rejectedList, "Rejected");
        default: return const Center(child: Text("No Data Found"));
      }
    });
  }

  Widget _emptyState(String label) {
    return Center(
      child: Text(
        "No $label found",
        style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
      ),
    );
  }

  Widget _buildAppointmentList(List<ProviderAppointment> list) {
    if (list.isEmpty) return _emptyState("appointments");
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildAppointmentCard(item: list[index]);
      },
    );
  }

  Widget _buildBookingList(List<ProviderBooking> list, String label) {
    if (list.isEmpty) return _emptyState("$label bookings");
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(item: list[index]);
      },
    );
  }

  void _navigateToDetails(dynamic item, String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(item: item, initialStatus: status),
      ),
    );
  }

  Widget _buildAppointmentCard({required ProviderAppointment item}) {
    String status = item.appointmentStatus?.toLowerCase() ?? 'pending';
    String dateStr = item.appointmentDate ?? '';
    try {
      if (dateStr.isNotEmpty) {
        dateStr = DateFormat('dd MMMM, yyyy').format(DateTime.parse(dateStr));
      }
    } catch (_) {}

    String timeStr = item.timeSlot?.startTime ?? '';
    if (timeStr.isEmpty) {
        try {
            if (item.appointmentDate != null) {
                // handle if time in date
            }
        } catch (_) {}
    }

    if (timeStr.isNotEmpty) {
      try {
         final dt = DateFormat('HH:mm').parse(timeStr);
         timeStr = DateFormat('h:mm a').format(dt);
      } catch (_) {}
    }

    return GestureDetector(
      onTap: () => _navigateToDetails(item, status),
      child: _cardContainer(
        userImage: item.user?.profilePicture,
        userName: item.user?.fullName,
        dateStr: dateStr,
        timeStr: timeStr,
        note: item.userNotes,
        content: Column(
          children: [
            Row(
              children: [
                Text(
                  "Appointment Price: \$${item.totalAmount ?? 0}",
                  style: const TextStyle(
                    color: Color(0xFF2C5F4F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCardButtons(status, appointmentEnabled: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard({required ProviderBooking item}) {
    String status = item.bookingStatus?.toLowerCase() ?? 'pending';
    String dateStr = item.bookingDate ?? '';
    try {
      if (dateStr.isNotEmpty) {
        dateStr = DateFormat('dd MMMM, yyyy').format(DateTime.parse(dateStr));
      }
    } catch (_) {}
    
    String timeStr = ""; 

    return GestureDetector(
      onTap: () => _navigateToDetails(item, status),
      child: _cardContainer(
        userImage: item.user?.profilePicture,
        userName: item.user?.fullName,
        dateStr: dateStr,
        timeStr: timeStr,
        note: item.userNotes,
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price: \$${item.totalAmount ?? 0}",
                  style: const TextStyle(
                    color: Color(0xFF2C5F4F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item.downPayment != null && item.downPayment! > 0)
                  Text(
                    "Down payment: \$${item.downPayment}",
                    style: const TextStyle(
                      color: Color(0xFF2C5F4F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCardButtons(status, appointmentEnabled: false),
          ],
        ),
      ),
    );
  }

  Widget _cardContainer({
    String? userImage,
    String? userName,
    String? dateStr,
    String? timeStr,
    String? note,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: (userImage != null && userImage.isNotEmpty)
                    ? NetworkImage(userImage)
                    : const AssetImage('assets/images/emptyUser.png') as ImageProvider,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName ?? "User",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    // Removed static rating as per "real data" request
                  ],
                ),
              ),
              if (timeStr != null && timeStr.isNotEmpty)
                Text(
                  timeStr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Address: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: "Inter",
                  ),
                ),
                TextSpan(
                  text: 'Address not available',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Date: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: "Inter",
                  ),
                ),
                TextSpan(
                  text: dateStr ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Problem Note:',
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note ?? "No notes provided",
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 12,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildCardButtons(String status, {bool appointmentEnabled = false}) {
    status = status.toLowerCase();

    if (appointmentEnabled) {
      if (status == "confirmed") {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C5F4F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Confirmed",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
          ),
        );
      }

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.mainAppColor),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Reschedule",
                    style: TextStyle(
                      color: AppColors.mainAppColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5F4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Accept",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () =>
                _showConfirmationDialog(context, "cancel the appointment"),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      );
    } else if (status == "pending") {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.mainAppColor),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Reschedule",
                    style: TextStyle(
                      color: AppColors.mainAppColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5F4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Accept",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => _showConfirmationDialog(context, "cancel the Order"),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      );
    } else if (status == "cancelled" || status == "rejected") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            status.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
          ),
        ),
      );
    } else {
      // Completed, In Progress, etc.
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C5F4F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            status.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
          ),
        ),
      );
    }
  }
  }


class OrderDetailsScreen extends StatefulWidget {
  final dynamic item;
  final String initialStatus;
  const OrderDetailsScreen({super.key, this.item, required this.initialStatus});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isRescheduling = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.mainAppColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.mainAppColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Order Details"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),

                    const Text(
                      "Title:",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Color(0xFF2C5F4F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getServiceTitle(),
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Note",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Color(0xFF2C5F4F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildNoteBox(),
                    const SizedBox(height: 24),
                    _buildInfoDisplay(),

                    const SizedBox(height: 32),
                    _buildBottomActions(),
                  ],
                ),
              ),
            ),
            _buildChatButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoDisplay() {
    if (isRescheduling) return _buildRescheduleForm();
    return _buildInfoSection();
  }

  Widget _buildChatButton() {
    if (widget.item is ProviderAppointment) return const SizedBox.shrink();

    String status = widget.initialStatus.toLowerCase();
    if (status == "accepted" ||
        status == "on going" ||
        status == "confirmed" ||
        status == "in progress") {
      return Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                String name = "User";
                String image = "";
                if (widget.item is ProviderBooking) {
                  name = (widget.item as ProviderBooking).user?.fullName ?? name;
                  image = (widget.item as ProviderBooking).user?.profilePicture ?? "";
                } else if (widget.item is ProviderAppointment) {
                  name = (widget.item as ProviderAppointment).user?.fullName ?? name;
                  image = (widget.item as ProviderAppointment).user?.profilePicture ?? "";
                }
                Get.to(() => providerChatScreen(contactName: name, contactImage: image));
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C5F4F),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.message,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _getServiceTitle() {
    if (widget.item is ProviderBooking) {
      return (widget.item as ProviderBooking).serviceSnapshot?.serviceName ??
          "Service";
    }
    if (widget.item is ProviderAppointment) {
      return (widget.item as ProviderAppointment)
              .serviceSnapshot
              ?.serviceName ??
          "Appointment";
    }
    return "Service Details";
  }

  String _getDateStr() {
    String d = "";
    if (widget.item is ProviderBooking) {
      d = (widget.item as ProviderBooking).bookingDate ?? "";
    }
    if (widget.item is ProviderAppointment) {
      d = (widget.item as ProviderAppointment).appointmentDate ?? "";
    }
    try {
      if (d.isNotEmpty) {
        return DateFormat('dd/MM/yyyy').format(DateTime.parse(d));
      }
    } catch (_) {}
    return d;
  }

  int _getDueAmount() {
    if (widget.item is ProviderBooking) {
      final b = widget.item as ProviderBooking;
      return (b.totalAmount ?? 0) - (b.downPayment ?? 0);
    }
    return 0;
  }

  Widget _buildProfileHeader() {
    String name = "User";
    String image = "";
    String subtitle = "";

    if (widget.item is ProviderBooking) {
      final b = widget.item as ProviderBooking;
      name = b.user?.fullName ?? "User";
      image = b.user?.profilePicture ?? "";
      subtitle = b.user?.address ?? "";
    } else if (widget.item is ProviderAppointment) {
      final a = widget.item as ProviderAppointment;
      name = a.user?.fullName ?? "User";
      image = a.user?.profilePicture ?? "";
      subtitle = a.user?.address ?? "";
    }

    String dateVal = _getDateStr();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: image.isNotEmpty
              ? NetworkImage(image)
              : const AssetImage('assets/images/emptyUser.png') as ImageProvider,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold, 
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle.isEmpty ? "No Address Provided" : subtitle,
                style: const TextStyle(
                  fontFamily: "Inter",
                  color: Color(0xFF666666), 
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Text(
          dateVal.isNotEmpty ? "Date: $dateVal" : "",
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 11, 
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteBox() {
    String note = "";
    if (widget.item is ProviderBooking) {
      note = (widget.item as ProviderBooking).userNotes ?? "";
    }
    if (widget.item is ProviderAppointment) {
      note = (widget.item as ProviderAppointment).userNotes ?? "";
    }
    if (note.isEmpty) note = "No notes provided";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(note),
    );
  }

  Widget _buildInfoSection() {
    String field1Label = "Time";
    String field1Value = "N/A";
    String field2Label = "Price";
    String field2Value = "\$0";

    if (widget.item is ProviderBooking) {
      final b = widget.item as ProviderBooking;
      field1Label = "Price";
      field1Value = "\$${b.totalAmount ?? 0}";
      field2Label = "Due";
      field2Value = "\$${(b.totalAmount ?? 0) - (b.downPayment ?? 0)}";
    } else if (widget.item is ProviderAppointment) {
      final a = widget.item as ProviderAppointment;
      field1Label = "Time";
      field1Value =
          "${a.selectedSlot?.duration ?? ''} ${a.selectedSlot?.durationUnit ?? ''}";
      field2Label = "Price";
      field2Value = "\$${a.totalAmount ?? 0}";
    }

    return Row(
      children: [
        Expanded(child: _buildStaticField(field1Label, field1Value)),
        const SizedBox(width: 16),
        Expanded(child: _buildStaticField(field2Label, field2Value)),
      ],
    );
  }

  Widget _buildStaticField(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8)),
          child: Text(val),
        ),
      ],
    );
  }

  Widget _buildRescheduleForm() {
    String duration = "N/A";
    String price = "0";
    if (widget.item is ProviderAppointment) {
      final a = widget.item as ProviderAppointment;
      duration =
          "${a.selectedSlot?.duration ?? ''} ${a.selectedSlot?.durationUnit ?? ''}";
      price = "${a.totalAmount ?? 0}";
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _buildInputField(
                    "Date",
                    selectedDate != null
                        ? DateFormat('MM/dd/yy').format(selectedDate!)
                        : "mm/dd/yy",
                    Icons.calendar_month,
                    onTap: () => _selectDate(context))),
            const SizedBox(width: 16),
            Expanded(
                child: _buildInputField(
                    "Time",
                    selectedTime != null ? selectedTime!.format(context) : "12:25pm",
                    Icons.access_time,
                    onTap: () => _selectTime(context))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Duration: $duration",
                style: const TextStyle(
                    color: Color(0xFF2C5F4F), fontWeight: FontWeight.bold)),
            Text("Price: \$$price",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon,
      {VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    color: (label == "Date" && selectedDate != null) ||
                            (label == "Time" && selectedTime != null)
                        ? Colors.black
                        : Colors.grey),
                suffixIcon: Icon(icon, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    if (isRescheduling) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => setState(() => isRescheduling = false),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C5F4F),
              padding: const EdgeInsets.all(16)),
          child: const Text("Send", style: TextStyle(color: Colors.white)),
        ),
      );
    }
    String status = widget.initialStatus.toLowerCase();

    if (widget.item is ProviderAppointment && status == "confirmed") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C5F4F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
          ),
          child: const Text(
            "Confirmed",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
          ),
        ),
      );
    }

    if (status == "pending") {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => isRescheduling = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.mainAppColor),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    "Reschedule",
                    style: TextStyle(
                      color: AppColors.mainAppColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5F4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    "Accept",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () =>
                _showConfirmationDialog(context, "cancel the order/appointment"),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      );
    }

    if (status == "accepted" ||
        status == "confirmed" ||
        status == "on going" ||
        status == "in progress") {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showConfirmationDialog(
                      context, "completed the work properly?",
                      isSuccess: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.mainAppColor),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: AppColors.mainAppColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showConfirmationDialog(
                      context, "ask for the remaining money?",
                      isMoney: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5F4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    "Ask for due payment",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () =>
                _showConfirmationDialog(context, "cancel the appointment"),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      );
    }

    if (status == "cancelled") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Cancelled",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => isRescheduling = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.mainAppColor),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  "Reschedule",
                  style: TextStyle(
                    color: AppColors.mainAppColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C5F4F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  "Accept",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () =>
              _showConfirmationDialog(context, "cancel the appointment"),
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Color(0xFFE74C3C),
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
          ),
        ),
      ],
    );
  }
}

void _showConfirmationDialog(
  BuildContext context,
  String message, {
  bool isSuccess = false,
  bool isMoney = false,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMoney ? Icons.monetization_on : Icons.check,
            color: isSuccess || isMoney ? const Color(0xFF2C5F4F) : Colors.red,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            "Are you sure you want to $message?",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isSuccess || isMoney
                          ? const Color(0xFF2C5F4F)
                          : Colors.red,
                    ),
                  ),
                  child: Text(
                    "No",
                    style: TextStyle(
                      color: isSuccess || isMoney
                          ? const Color(0xFF2C5F4F)
                          : Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess || isMoney
                        ? const Color(0xFF2C5F4F)
                        : Colors.red,
                  ),
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
