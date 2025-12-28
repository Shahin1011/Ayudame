import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:middle_ware/views/event_manager/home/EventHomeScreen.dart';
import 'package:middle_ware/widgets/bottom_nave.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';


class EditEventPage extends StatefulWidget {
  const EditEventPage({super.key});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;


  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _eventManagerController = TextEditingController();
  final TextEditingController _eventLocationController = TextEditingController();
  final TextEditingController _ticketStartDateController = TextEditingController();
  final TextEditingController _ticketEndDateController = TextEditingController();
  final TextEditingController _eventStartDateController = TextEditingController();
  final TextEditingController _eventEndDateController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _maxTicketsController = TextEditingController();
  final TextEditingController _confirmationCodeController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();

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


  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectDateTime(TextEditingController controller, {bool onlyDate = false}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      if (onlyDate) {
        setState(() {
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        });
      } else {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          final DateTime fullDateTime = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute,
          );
          setState(() {
            controller.text = DateFormat('yyyy-MM-dd hh:mm a').format(fullDateTime);
          });
        }
      }
    }
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      appBar: CustomAppBar(title: "Edit Event"),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ১. Event Flier Card
              _buildSectionCard(
                title: 'Event Flier',
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _buildImageUploadBox(),
                ),
              ),
              const SizedBox(height: 16),

              // ২. Event Information
              _buildSectionCard(
                title: 'Event Information',
                child: Column(
                  children: [
                    _buildFieldGroup("Event Name", _buildTextField(_eventNameController, 'Enter Event Name')),
                    const SizedBox(height: 12),
                    _buildFieldGroup("Event Type", _buildDropdownField(_eventTypeController, 'Select Type')),
                    const SizedBox(height: 12),
                    _buildFieldGroup("Manager Name", _buildTextField(_eventManagerController, 'Manager Name')),
                    const SizedBox(height: 12),
                    _buildFieldGroup("Location", _buildLocationField(_eventLocationController, 'Event Location')),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ৩. Dates & Times
              _buildSectionCard(
                title: 'Dates & Times',
                child: Column(
                  children: [
                    _buildFieldGroup("Ticket Sales Start", _buildDateField(_ticketStartDateController, 'Select Date', () => _selectDateTime(_ticketStartDateController, onlyDate: true))),
                    const SizedBox(height: 12),
                    _buildFieldGroup("Event Start Time", _buildDateTimeField(_eventStartDateController, 'Select Date & Time', () => _selectDateTime(_eventStartDateController))),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ৪. Ticket Information
              _buildSectionCard(
                title: 'Ticket Information',
                child: Column(
                  children: [
                    _buildFieldGroup("Price", _buildTextField(_ticketPriceController, 'Ticket Price (\$)', keyboardType: TextInputType.number)),
                    const SizedBox(height: 12),
                    _buildFieldGroup("Confirmation Prefix", _buildTextField(_confirmationCodeController, 'Prefix', readOnly: true)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ৫. Description
              _buildSectionCard(
                title: 'Description',
                child: _buildTextField(_eventDescriptionController, 'Event Description', maxLines: 4),
              ),
              const SizedBox(height: 32),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => BottomNavEScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C5941),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- হেল্পার উইজেটস ---

  Widget _buildFieldGroup(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 6),
        field,
      ],
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
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildImageUploadBox() {
    return Container(
      height: 130.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: _selectedImage != null
          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_selectedImage!, fit: BoxFit.cover))
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 32, color: Colors.grey[400]),
          const SizedBox(height: 8),
          const Text('Choose file to upload', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {int maxLines = 1, TextInputType? keyboardType, bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdownField(TextEditingController controller, String hintText) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildLocationField(TextEditingController controller, String hintText) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: const Icon(Icons.location_on_outlined, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String hintText, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: _buildTextField(controller, hintText),
      ),
    );
  }

  Widget _buildDateTimeField(TextEditingController controller, String hintText, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: _buildTextField(controller, hintText),
      ),
    );
  }
}