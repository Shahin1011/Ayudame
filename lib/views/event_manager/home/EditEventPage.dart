import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/core/app_icons.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/models/event_model.dart';
import 'package:middle_ware/viewmodels/event_viewmodel.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class EditEventPage extends StatefulWidget {
  final EventModel event;
  const EditEventPage({super.key, required this.event});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final EventViewModel _eventViewModel = Get.find<EventViewModel>();

  // Controllers
  late TextEditingController _eventNameController;
  late TextEditingController _eventTypeController;
  late TextEditingController _eventManagerController;
  late TextEditingController _eventLocationController;
  late TextEditingController _ticketStartDateController;
  late TextEditingController _ticketEndDateController;
  late TextEditingController _eventStartDateController;
  late TextEditingController _eventEndDateController;
  late TextEditingController _ticketPriceController;
  late TextEditingController _maxTicketsController;
  late TextEditingController _confirmationCodeController;
  late TextEditingController _eventDescriptionController;

  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: widget.event.eventName);
    _eventTypeController = TextEditingController(text: widget.event.eventType);
    _eventManagerController = TextEditingController(
      text: widget.event.eventManagerName,
    );
    _eventLocationController = TextEditingController(
      text: widget.event.eventLocation,
    );
    _ticketStartDateController = TextEditingController(
      text: widget.event.ticketSalesStartDate,
    );
    _ticketEndDateController = TextEditingController(
      text: widget.event.ticketSalesEndDate,
    );
    _eventStartDateController = TextEditingController(
      text: widget.event.eventStartDateTime,
    );
    _eventEndDateController = TextEditingController(
      text: widget.event.eventEndDateTime,
    );
    _ticketPriceController = TextEditingController(
      text: widget.event.ticketPrice?.toString(),
    );
    _maxTicketsController = TextEditingController(
      text: widget.event.maximumNumberOfTickets?.toString(),
    );
    _confirmationCodeController = TextEditingController(
      text: widget.event.confirmationCodePrefix,
    );
    _eventDescriptionController = TextEditingController(
      text: widget.event.eventDescription,
    );
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      _eventViewModel.updateEvent(
        widget.event.id!,
        {
          'eventName': _eventNameController.text,
          'eventType': _eventTypeController.text,
          'eventManagerName': _eventManagerController.text,
          'eventLocation': _eventLocationController.text,
          'ticketSalesStartDate': _ticketStartDateController.text,
          'ticketSalesEndDate': _ticketEndDateController.text,
          'eventStartDateTime': _eventStartDateController.text,
          'eventEndDateTime': _eventEndDateController.text,
          'ticketPrice': double.tryParse(_ticketPriceController.text) ?? 0,
          'maximumNumberOfTickets':
              int.tryParse(_maxTicketsController.text) ?? 0,
          'confirmationCodePrefix': _confirmationCodeController.text,
          'eventDescription': _eventDescriptionController.text,
        },
        _selectedImagePath,
        onSuccess: () {
          _eventViewModel.fetchEvents(); // Refresh home list
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Edit Event", showBackButton: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Event Flier',
                child: _buildImageUploadBox(),
              ),
              const SizedBox(height: 16),

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
                        'Concert / Music Show',
                        'Cultural Program',
                        'Seminar / Conference',
                        'Sports Event',
                        'Festival / Fair',
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
                        if (value == null || value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null) return 'Invalid';
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
                        if (int.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _confirmationCodeController,
                      hintText: 'Confirmation Code Prefix',
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Used to generate unique confirmation codes.',
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
                  hintText: 'Description',
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 32),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _eventViewModel.isLoading.value
                        ? null
                        : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C5941),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _eventViewModel.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: _selectedImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(_selectedImagePath!), fit: BoxFit.cover),
              )
            : widget.event.eventImage != null &&
                  widget.event.eventImage!.startsWith('http')
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.event.eventImage!,
                  fit: BoxFit.cover,
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
                    'Change Event Image',
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
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator:
            validator ??
            (value) => (value == null || value.trim().isEmpty)
                ? '$hintText is required'
                : null,
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
        value: items.contains(controller.text) ? controller.text : null,
        validator: (value) =>
            (value == null || value.isEmpty) ? '$hintText is required' : null,
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
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              ),
            )
            .toList(),
        onChanged: (val) => setState(() => controller.text = val ?? ""),
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
        validator: (value) => (value == null || value.trim().isEmpty)
            ? '$hintText is required'
            : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
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
        validator: (value) =>
            (value == null || value.isEmpty) ? '$hintText is required' : null,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (picked != null) {
            setState(() {
              final isoDate =
                  picked.toIso8601String().split('T')[0] + 'T00:00:00.000Z';
              controller.text = isoDate;
            });
          }
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
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppIcons.date,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            ),
          ),
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
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: (value) =>
            (value == null || value.isEmpty) ? '$hintText is required' : null,
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (pickedDate != null) {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              setState(() {
                final finalDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
                controller.text = finalDateTime.toIso8601String() + 'Z';
              });
            }
          }
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
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppIcons.date,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            ),
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
}
