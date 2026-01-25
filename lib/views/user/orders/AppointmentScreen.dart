import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../controller/user/orders/appointment_controller.dart';
import '../../../core/routes/app_routes.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String selectedService = 'Select Service';
  String selectedDate = '';
  int? selectedHourIndex;
  int? selectedTimeSlotIndex;
  DateTime? selectedDateTime; // For API
  final TextEditingController notesController = TextEditingController();
  final AppointmentController appointmentController = Get.put(AppointmentController());

  Map<String, dynamic>? args;
  List<Map<String, dynamic>> hourOptions = [];
  String? providerName;
  String? providerImage;
  String? providerAddress;
  String? availableTime;
  List<String> services = [];

  @override
  void initState() {
    super.initState();
    args = Get.arguments;
    if (args != null) {
      providerName = args!['providerName'];
      providerImage = args!['providerImage'];
      providerAddress = args!['providerAddress'];
      selectedService = args!['serviceTitle'] ?? 'Select Service';
      services = [selectedService]; // Initialize with the passed service
      availableTime = args!['availableTime'];
      
      final slots = args!['appointmentSlots'] as List?;
      if (slots != null && slots.isNotEmpty) {
        hourOptions = slots.map((e) => {
          'id': e['id'],
          'value': e['duration'],
          'label': "${e['duration']}\n${e['durationUnit']}",
          'price': e['price'],
        }).toList();

        // Auto-select the slot with the lowest price
        int minPriceIndex = 0;
        num minPrice = hourOptions[0]['price'];
        for (int i = 1; i < hourOptions.length; i++) {
          if (hourOptions[i]['price'] < minPrice) {
            minPrice = hourOptions[i]['price'];
            minPriceIndex = i;
          }
        }
        selectedHourIndex = minPriceIndex;
      }
      
      // Auto-select first time slot if availableTime is present
      if (availableTime != null && availableTime!.isNotEmpty) {
        selectedTimeSlotIndex = 0;
      }
    }
    selectedDateTime = DateTime.now();
    selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Widget _buildTimeSlot(String time, int index) {
    final isSelected = selectedTimeSlotIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeSlotIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2D6F5C) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF2D6F5C) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Appointment"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                       CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (providerImage != null && providerImage!.isNotEmpty)
                            ? NetworkImage(providerImage!)
                            : null,
                        child: (providerImage == null || providerImage!.isEmpty)
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerName ?? 'Provider Name',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        providerAddress ?? 'Address not available',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedService,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Date Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF2D6F5C),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedDateTime = pickedDate;
                          selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black
                            ),
                          ),
                          Icon(Icons.calendar_today, color: Colors.grey.shade400, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Provider available time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (availableTime != null && availableTime!.isNotEmpty)
                        _buildTimeSlot(availableTime!, 0)
                      else
                         const Text("No specific time available", style: TextStyle(color: Colors.black, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 70,
                child: hourOptions.isEmpty 
                  ? const Center(child: Text("No duration options available"))
                  : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hourOptions.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedHourIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedHourIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: isSelected ? 70 : 60,
                        height: isSelected ? 70 : 60,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2D6F5C) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2D6F5C) : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            hourOptions[index]['label'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSelected ? 12 : 11,
                              color: isSelected ? Colors.white : Colors.grey.shade700,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedHourIndex != null 
                        ? "${hourOptions[selectedHourIndex!]['value']} ${hourOptions[selectedHourIndex!]['label'].split('\n').last}" 
                        : 'Select duration',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    selectedHourIndex != null 
                        ? '\$${hourOptions[selectedHourIndex!]['price']}'
                        : '\$0',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes for User',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Please write your note...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: appointmentController.isLoading.value 
                      ? null 
                      : () async {
                    if (selectedDateTime == null) {
                      Get.snackbar("Validation Error", "Please select a date");
                      return;
                    }
                    if (selectedHourIndex == null) {
                      Get.snackbar("Validation Error", "Please select a duration slot");
                      return;
                    }
                    if (availableTime == null || availableTime!.isEmpty) {
                      Get.snackbar("Validation Error", "Provider available time not found");
                      return;
                    }

                    // Parse available time "09:00 - 17:00" or "9:00 AM - 5:00 PM"
                    String start = "09:00";
                    String end = "17:00";
                    
                    try {
                      List<String> parts = availableTime!.split(RegExp(r'[\-\–\—]'));
                      if (parts.length >= 2) {
                        String rawStart = parts[0].trim();
                        String rawEnd = parts[1].trim();

                        // Helper to convert "9:00 AM" or "09:00" to "09:00"
                        String formatToHHMM(String time) {
                          time = time.toUpperCase();
                          bool isPM = time.contains('PM');
                          bool isAM = time.contains('AM');
                          
                          // Remove AM/PM and extra spaces
                          String cleanTime = time.replaceAll(RegExp(r'[AP]M'), '').trim();
                          List<String> timeParts = cleanTime.split(':');
                          
                          int hour = int.parse(timeParts[0]);
                          int minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;

                          if (isPM && hour < 12) hour += 12;
                          if (isAM && hour == 12) hour = 0;

                          return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
                        }

                        start = formatToHHMM(rawStart);
                        end = formatToHHMM(rawEnd);
                      }
                    } catch (e) {
                      print("Error parsing available time: $e");
                    }

                    final String? serviceId = args?['serviceId'];
                    if (serviceId == null) {
                      Get.snackbar("Error", "Service ID not found");
                      return;
                    }

                    final String? slotId = hourOptions[selectedHourIndex!]['id'];
                    if (slotId == null) {
                      Get.snackbar("Error", "Slot ID not found");
                      return;
                    }

                    final dynamic result = await appointmentController.createAppointment(
                      serviceId: serviceId,
                      appointmentDate: DateFormat('yyyy-MM-dd').format(selectedDateTime!),
                      timeSlot: {
                        "startTime": start,
                        "endTime": end,
                      },
                      slotId: slotId,
                      userNotes: notesController.text,
                    );

                    if (result != null) {
                      // Navigate to payment screen
                      Get.toNamed(AppRoutes.userPayment, arguments: {
                        'bookingId': result['data']?['_id'] ?? result['_id'],
                        'amount': (hourOptions[selectedHourIndex!]['price'] as num).toDouble(),
                        'serviceName': providerName ?? "Appointment",
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6F5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: appointmentController.isLoading.value 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Create Appointment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}