import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:middle_ware/core/app_icons.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/models/event_model.dart';
import 'package:middle_ware/viewmodels/event_viewmodel.dart';
import 'package:middle_ware/viewmodels/event_manager_viewmodel.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import 'package:middle_ware/core/routes/app_routes.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _eventManagerController =
      TextEditingController(); // Should be auto-filled or removed if inferred
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _ticketStartDateController =
      TextEditingController();
  final TextEditingController _ticketEndDateController =
      TextEditingController();
  final TextEditingController _eventStartDateController =
      TextEditingController();
  final TextEditingController _eventEndDateController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _maxTicketsController = TextEditingController();
  final TextEditingController _confirmationCodeController =
      TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _generateConfirmationCode();

    // Auto-fill manager name if available
    final managerVM = Get.find<EventManagerViewModel>();
    if (managerVM.currentManager.value != null) {
      _eventManagerController.text =
          managerVM.currentManager.value!.fullName ?? "";
    }
  }

  void _generateConfirmationCode() {
    final random = Random();
    final code = List.generate(10, (index) => random.nextInt(10)).join();
    _confirmationCodeController.text = code;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventTypeController.dispose();
    _eventManagerController.dispose();
    _eventLocationController.dispose();
    _ticketStartDateController.dispose();
    _ticketEndDateController.dispose();
    _eventStartDateController.dispose();
    _eventEndDateController.dispose();
    _ticketPriceController.dispose();
    _maxTicketsController.dispose();
    _confirmationCodeController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImagePath == null) {
        Get.snackbar(
          "Required",
          "Please select an event flier",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      final event = EventModel(
        eventName: _eventNameController.text,
        eventType: _eventTypeController.text,
        eventManagerName: _eventManagerController.text,
        eventLocation: _eventLocationController.text,
        ticketSalesStartDate: _ticketStartDateController.text,
        ticketSalesEndDate: _ticketEndDateController.text,
        eventStartDateTime: _eventStartDateController.text,
        eventEndDateTime: _eventEndDateController.text,
        ticketPrice: double.tryParse(_ticketPriceController.text),
        maximumNumberOfTickets: int.tryParse(_maxTicketsController.text),
        confirmationCodePrefix: _confirmationCodeController.text,
        eventDescription: _eventDescriptionController.text,
        eventImage: _selectedImagePath,
        status: 'draft',
      );

      // Navigate to preview page using Get
      Get.to(() => EventPreviewPage(event: event));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Event Create", showBackButton: false),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ১. Event Flier Card
              _buildSectionCard(
                title: 'Event Flier',
                child: _buildImageUploadBox(),
              ),
              const SizedBox(height: 16),

              // ২. Event Information Card
              _buildSectionCard(
                title: 'Event Information',
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _eventNameController,
                      hintText: 'Event Name',
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      controller: _eventTypeController,
                      hintText: 'Event Type',
                      items: [
                        'Concert/Music Show',
                        'Cultural Program',
                        'Seminar/Conference',
                        'Sports Event',
                        'Festival/Fair',
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _eventManagerController,
                      hintText: 'Event Manager Name',
                    ),
                    const SizedBox(height: 12),
                    _buildLocationField(
                      controller: _eventLocationController,
                      hintText: 'Event Location',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ৩. Dates & Times Card
              _buildSectionCard(
                title: 'Dates & Times',
                child: Column(
                  children: [
                    _buildDateField(
                      controller: _ticketStartDateController,
                      hintText: 'Ticket Sales Start Date',
                    ),
                    const SizedBox(height: 12),
                    _buildDateField(
                      controller: _ticketEndDateController,
                      hintText: 'Ticket Sales End Date',
                    ),
                    const SizedBox(height: 12),
                    _buildDateTimeField(
                      controller: _eventStartDateController,
                      hintText: 'Event Start Date & Time',
                    ),
                    const SizedBox(height: 12),
                    _buildDateTimeField(
                      controller: _eventEndDateController,
                      hintText: 'Event End Date & Time',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ৪. Ticket Information Card
              _buildSectionCard(
                title: 'Ticket Information',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _ticketPriceController,
                      hintText: 'Ticket Price (\$)',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Price is required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _maxTicketsController,
                      hintText: 'Maximum Number of Tickets',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _confirmationCodeController,
                      hintText: 'Confirmation Code Prefix',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'This will be used to generate unique confirmation codes for attendees.',
                      style: TextStyle(fontSize: 11, color: AppColors.dark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Event Description',
                child: _buildTextField(
                  controller: _eventDescriptionController,
                  hintText: 'Event Description',
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 32),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C5941),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            style: BorderStyle.solid,
          ),
        ),
        child: _selectedImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_selectedImagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.create,
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload your event flier or promotional image',
                    style: TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        validator:
            validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return '$hintText is required';
              }
              return null;
            },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
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
            borderSide: const BorderSide(color: Color(0xFF1C5941)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String hintText,
    required List<String> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: controller.text.isEmpty ? null : controller.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText is required';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
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
            borderSide: const BorderSide(color: Color(0xFF1C5941)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            controller.text = newValue ?? "";
          });
        },
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$hintText is required';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              AppIcons.location,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),
            ),
          ),
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
            borderSide: const BorderSide(color: Color(0xFF1C5941)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText is required';
          }
          return null;
        },
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (picked != null) {
            final isoDate =
                '${picked.toIso8601String().split('T')[0]}T00:00:00.000Z';
            controller.text = isoDate;
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              AppIcons.date,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            ),
          ),
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
            borderSide: const BorderSide(color: Color(0xFF1C5941)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDateTimeField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText is required';
          }
          return null;
        },
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (pickedDate != null) {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              final finalDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              controller.text = '${finalDateTime.toIso8601String()}Z';
            }
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              AppIcons.date,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            ),
          ),
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
            borderSide: const BorderSide(color: Color(0xFF1C5941)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

// Event Preview Page
class EventPreviewPage extends StatelessWidget {
  final EventModel event;

  const EventPreviewPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final EventViewModel eventViewModel = Get.find<EventViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomAppBar(title: "Event Preview"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        event.eventImage != null && event.eventImage!.isNotEmpty
                        ? Image.file(
                            File(event.eventImage!),
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: 180,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    event.eventName ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInfoRow(
                    AppIcons.date,
                    'Date & Time',
                    '${_formatDateTime(event.eventStartDateTime)} - ${_formatDateTime(event.eventEndDateTime)}',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    AppIcons.location,
                    'Location',
                    event.eventLocation ?? 'N/A',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    AppIcons.ticket,
                    'Ticket Price',
                    '\$${event.ticketPrice} per ticket',
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.eventDescription ?? 'No description provided.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(thickness: 0.8),
                  const SizedBox(height: 16),

                  const Text(
                    'Confirmation Code Prefix',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.confirmationCodePrefix ?? 'N/A',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1C5941),
                            side: const BorderSide(color: Color(0xFF1C5941)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Edit Event'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: eventViewModel.isLoading.value
                                ? null
                                : () {
                                    eventViewModel.createEvent(
                                      fields: {
                                        'eventName': event.eventName ?? '',
                                        'eventType': event.eventType ?? '',
                                        'eventManagerName':
                                            event.eventManagerName ?? '',
                                        'eventLocation':
                                            event.eventLocation ?? '',
                                        'ticketSalesStartDate':
                                            event.ticketSalesStartDate ?? '',
                                        'ticketSalesEndDate':
                                            event.ticketSalesEndDate ?? '',
                                        'eventStartDateTime':
                                            event.eventStartDateTime ?? '',
                                        'eventEndDateTime':
                                            event.eventEndDateTime ?? '',
                                        'ticketPrice': event.ticketPrice ?? 0,
                                        'maximumNumberOfTickets':
                                            event.maximumNumberOfTickets ?? 0,
                                        'confirmationCodePrefix':
                                            event.confirmationCodePrefix ?? '',
                                        'eventDescription':
                                            event.eventDescription ?? '',
                                        'status': 'draft',
                                      },
                                      imagePath: event.eventImage,
                                      onSuccess: () {
                                        eventViewModel
                                            .fetchEvents(); // Refresh home list
                                        _showSuccessDialog(context);
                                      },
                                      onError: (msg) {
                                        // Error already handled in VM via snackbar
                                      },
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1C5941),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: eventViewModel.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Create Event'),
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

  Widget _buildInfoRow(String iconPath, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.dark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.tryParse(dateTimeStr);
      if (dateTime == null) return dateTimeStr;
      return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.check,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Success! Your Event Has Been Created!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event Name',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          event.eventName ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          event.eventLocation ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ticket Price',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$${event.ticketPrice}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.eventHome);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C5941),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Go Home',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
