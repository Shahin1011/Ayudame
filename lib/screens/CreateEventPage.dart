import 'package:flutter/material.dart';
import 'dart:math';

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

  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _generateConfirmationCode();
  }

  void _generateConfirmationCode() {
    final random = Random();
    final code = List.generate(10, (index) => random.nextInt(10)).join();
    _confirmationCodeController.text = code;
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
      // Navigate to preview page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventPreviewPage(
            eventName: _eventNameController.text,
            location: _eventLocationController.text,
            ticketPrice: _ticketPriceController.text,
            confirmationCode: _confirmationCodeController.text,
            imagePath: _selectedImagePath,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C5941),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Flier Section
              const Text(
                'Event Flier',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildImageUploadBox(),
              const SizedBox(height: 24),

              // Event Information Section
              const Text(
                'Event Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _eventNameController,
                hintText: 'Event Name',
              ),
              const SizedBox(height: 12),

              _buildDropdownField(
                controller: _eventTypeController,
                hintText: 'Event Type',
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
              const SizedBox(height: 24),

              // Dates & Times Section
              const Text(
                'Dates & Times',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

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
              const SizedBox(height: 24),

              // Ticket Information Section
              const Text(
                'Ticket Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _ticketPriceController,
                hintText: 'Ticket Price (\$)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _maxTicketsController,
                hintText: 'Maximum Number of Tickets',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _confirmationCodeController,
                hintText: 'Confirmation Code Prefix (e.g MDR23012)',
                readOnly: true,
              ),
              const SizedBox(height: 6),
              Text(
                'This will be used to generate unique confirmation codes for attendees.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Ticket Information (Description) Section
              const Text(
                'Ticket Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _eventDescriptionController,
                hintText: 'Event Description',
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C5941),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
      onTap: () {
        // Handle image upload
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 32,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your event flier or promotional image',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          border: InputBorder.none,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () {
          // Show dropdown
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey[600],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.location_on_outlined,
            size: 20,
            color: Colors.grey[600],
          ),
          border: InputBorder.none,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (picked != null) {
            controller.text = '${picked.day}/${picked.month}/${picked.year}';
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          suffixIcon: Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: Colors.grey[600],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
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
              controller.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year} ${pickedTime.format(context)}';
            }
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          suffixIcon: Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: Colors.grey[600],
          ),
          border: InputBorder.none,
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
  final String eventName;
  final String location;
  final String ticketPrice;
  final String confirmationCode;
  final String? imagePath;

  const EventPreviewPage({
    super.key,
    required this.eventName,
    required this.location,
    required this.ticketPrice,
    required this.confirmationCode,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C5941),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath ?? 'assets/images/event_preview.jpg',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            Text(
              eventName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            _buildInfoRow(Icons.calendar_today_outlined, 'Date & Time', 'August 15, 2023 at 08:30 PM - August 15, 2026 at 11:00 PM'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on_outlined, 'Location', location),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.confirmation_number_outlined, 'Ticket Price', '\$${ticketPrice} per ticket'),
            const SizedBox(height: 16),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join us for an unforgettable night of music under the stars! Featuring top artists and bands from around the world.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Confirmation Code Prefix',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              confirmationCode,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1C5941),
                      side: const BorderSide(color: Color(0xFF1C5941)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Edit Event',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showSuccessDialog(context);
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
                      'Create Event',
                      style: TextStyle(
                        fontSize: 15,
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
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
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
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Happy New Year Fest',
                          style: TextStyle(
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Central Park, New York',
                          style: TextStyle(
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
              const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ticket Price',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$80',
                          style: TextStyle(
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
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