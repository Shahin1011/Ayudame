import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import 'package:intl/intl.dart';
import '../../../controller/user/orders/booking_controller.dart';
import '../../../core/routes/app_routes.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController downPaymentController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  Map<String, dynamic>? args;
  String? providerName;
  String? providerImage;
  String? providerAddress;
  num? servicePrice;
  String selectedDateDisplay = '';
  DateTime? selectedDateTime;

  final BookingController bookingController = Get.put(BookingController());

  @override
  void initState() {
    super.initState();
    args = Get.arguments;
    if (args != null) {
      providerName = args!['providerName'];
      providerImage = args!['providerImage'];
      providerAddress = args!['providerAddress'];
      // For standard booking, basePrice or first slot price
      // In ProviderServiceDetailsScreen we pass servicePrice if appointmentEnabled is false
      servicePrice = args!['servicePrice']; 
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    downPaymentController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Booking"),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: ClipOval(
                            child: (providerImage != null && providerImage!.isNotEmpty)
                                ? Image.network(
                                    providerImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 28),
                                  )
                                : const Icon(Icons.person, size: 28),
                          ),
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
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
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
                                    selectedDateDisplay = DateFormat('dd/MM/yyyy').format(pickedDate);
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
                                    selectedDateDisplay.isEmpty ? "Select Date" : selectedDateDisplay,
                                    style: const TextStyle(
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
                    SizedBox(height: 20),

                    const Text(
                      'Down Payment',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: downPaymentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Down payment',
                        prefixIcon: Icon(Icons.attach_money, size: 18, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF2D6F5C)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Down payment must be at least of 20 or 30% of the total payment.",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.red
                      ),
                    ),

                    const SizedBox(height: 20),


                    const Text(
                      'Notes for User',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Please write your note...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF2D6F5C)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),


                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ElevatedButton(
                        onPressed: bookingController.isLoading.value 
                          ? null 
                          : () async {
                              if (selectedDateTime == null) {
                                Get.snackbar("Validation Error", "Please select a booking date");
                                return;
                              }
                              if (downPaymentController.text.isEmpty) {
                                Get.snackbar("Validation Error", "Please enter down payment amount");
                                return;
                              }

                              final double downPayment = double.tryParse(downPaymentController.text) ?? 0.0;
                              if (servicePrice != null && downPayment > servicePrice!) {
                                Get.snackbar(
                                  "Validation Error", 
                                  "Down payment cannot exceed the total service price (\$${servicePrice})",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              final String? serviceId = args?['serviceId'];
                              if (serviceId == null) {
                                Get.snackbar("Error", "Service ID not found");
                                return;
                              }

                              final dynamic result = await bookingController.createBooking(
                                serviceId: serviceId,
                                bookingDate: DateFormat('yyyy-MM-dd').format(selectedDateTime!),
                                downPayment: downPayment,
                                userNotes: notesController.text,
                              );

                              if (result != null) {
                                // If API returns booking data, pass it to payment screen
                                Get.toNamed(AppRoutes.userPayment, arguments: {
                                  'bookingId': result['data']?['_id'] ?? result['_id'],
                                  'amount': downPayment,
                                  'serviceName': providerName ?? "Service",
                                });
                              }
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6F5C),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: bookingController.isLoading.value 
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}