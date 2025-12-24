import 'package:flutter/material.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({super.key});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _totalTicketsController = TextEditingController();
  final TextEditingController _lastDateController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _eventNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    _ticketPriceController.dispose();
    _totalTicketsController.dispose();
    _lastDateController.dispose();
    _termsController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
          'Edit Event',
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title Section
                _buildSectionTitle('Event Title'),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _eventNameController,
                  hintText: 'Enter event name',
                ),
                const SizedBox(height: 24),

                // Event Image Section
                _buildSectionTitle('Event Image'),
                const SizedBox(height: 12),
                _buildImageUploadBox(),
                const SizedBox(height: 24),

                // Event Information Section
                _buildSectionTitle('Event Information'),
                const SizedBox(height: 12),

                _buildLabel('Event Start Date'),
                const SizedBox(height: 8),
                _buildDateField(
                  controller: _startDateController,
                  hintText: 'Select Date',
                ),
                const SizedBox(height: 16),

                _buildLabel('Event End Date'),
                const SizedBox(height: 8),
                _buildDateField(
                  controller: _endDateController,
                  hintText: 'Select Date',
                ),
                const SizedBox(height: 16),

                _buildLabel('Event Start Time'),
                const SizedBox(height: 8),
                _buildTimeField(
                  controller: _startTimeController,
                  hintText: 'Select Time',
                ),
                const SizedBox(height: 16),

                _buildLabel('Event End Time'),
                const SizedBox(height: 8),
                _buildTimeField(
                  controller: _endTimeController,
                  hintText: 'Select Time',
                ),
                const SizedBox(height: 16),

                _buildLabel('Event Location'),
                const SizedBox(height: 8),
                _buildLocationField(
                  controller: _locationController,
                  hintText: 'Select Location',
                ),
                const SizedBox(height: 24),

                // Details & Prices Section
                _buildSectionTitle('Details & Prices'),
                const SizedBox(height: 12),

                _buildLabel('Ticket Price (Per Ticket)'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _ticketPriceController,
                  hintText: 'Enter Amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                _buildLabel('Total Number of Tickets'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _totalTicketsController,
                  hintText: 'Enter Amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                _buildLabel('Last Date of Entry'),
                const SizedBox(height: 8),
                _buildDateField(
                  controller: _lastDateController,
                  hintText: 'Select Date',
                ),
                const SizedBox(height: 24),

                // Event Information Section
                _buildSectionTitle('Event Information'),
                const SizedBox(height: 12),

                _buildLabel('Description (Tell the all about your Event)'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _descriptionController,
                  hintText: 'Enter text here...',
                  maxLines: 4,
                ),
                const SizedBox(height: 16),

                _buildLabel('Terms & Conditions (Tell users what\'s not allowed along with terms and conditions before checkout)'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _termsController,
                  hintText: 'Enter text here...',
                  maxLines: 4,
                ),
                const SizedBox(height: 16),

                _buildLabel('Event Description'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: TextEditingController(),
                  hintText: 'Enter text here...',
                  maxLines: 4,
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                      }
                    },
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
                      'Submit',
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
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
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

  Widget _buildTimeField({
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
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (picked != null) {
            controller.text = picked.format(context);
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          suffixIcon: Icon(
            Icons.access_time,
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
          suffixIcon: Icon(
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

  Widget _buildImageUploadBox() {
    return Container(
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
            'Drag & Drop or Choose file to upload',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'PNG and JPG',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}