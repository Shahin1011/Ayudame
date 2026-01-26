import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/CustomDashedBorder.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../../models/business_employee_model.dart';
import '../../../../viewmodels/business_employee_viewmodel.dart';

class CreateEmployee extends StatefulWidget {
  final BusinessEmployeeModel? employee;
  const CreateEmployee({super.key, this.employee});

  @override
  State<CreateEmployee> createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  final BusinessEmployeeViewModel _viewModel = Get.put(
    BusinessEmployeeViewModel(),
  );

  // Employee Info Controllers
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Service Controllers
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final List<TextEditingController> _whyChooseControllers = [
    TextEditingController(text: '24/7 Service'),
    TextEditingController(text: 'Efficient & Fast.'),
    TextEditingController(text: 'Affordable Prices.'),
    TextEditingController(text: 'Expert Team.'),
  ];

  bool _makeAppointment = false;
  int _charCount = 0;
  XFile? _idCardBackImage;
  XFile? _idCardFrontImage;

  Future<void> _pickIdCardBackImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _idCardBackImage = image;
      });
    }
  }

  Future<void> _pickIdCardFrontImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _idCardFrontImage = image;
      });
    }
  }

  // Appointment fields
  final TextEditingController _availableTimeController = TextEditingController(
    text: '06:00am-09:00pm',
  );
  final List<Map<String, TextEditingController>> _durationPriceControllers = [
    {
      'duration': TextEditingController(text: '15 min'),
      'price': TextEditingController(text: '\$50'),
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      final e = widget.employee!;
      _employeeNameController.text = e.name ?? '';
      _mobileNumberController.text = e.phone ?? '';
      _emailController.text = e.email ?? '';
      _categoryController.text = e.serviceCategory ?? '';
      _headlineController.text = e.headline ?? '';
      _aboutController.text = e.about ?? '';
      _priceController.text = e.price?.toString() ?? '';
      _availableTimeController.text = e.availableTime ?? '';
      _makeAppointment = e.isAppointmentBased == true;

      if (e.whyChooseUs != null) {
        for (
          int i = 0;
          i < e.whyChooseUs!.length && i < _whyChooseControllers.length;
          i++
        ) {
          _whyChooseControllers[i].text = e.whyChooseUs![i];
        }
      }

      if (e.appointmentOptions != null && e.appointmentOptions!.isNotEmpty) {
        _durationPriceControllers.clear();
        for (var option in e.appointmentOptions!) {
          _durationPriceControllers.add({
            'duration': TextEditingController(text: option.duration ?? ''),
            'price': TextEditingController(
              text: option.price?.toString() ?? '',
            ),
          });
        }
      }
    }
  }

  Future<void> _submit() async {
    if (_employeeNameController.text.isEmpty ||
        _mobileNumberController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Employee Name and Mobile Number are required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate required images (backend requires both profilePhoto and servicePhoto)
    if (_idCardFrontImage == null) {
      Get.snackbar(
        "Error",
        "Please upload profile photo",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_idCardBackImage == null) {
      Get.snackbar(
        "Error",
        "Please upload service photo",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Build appointment slots if enabled
    List<Map<String, dynamic>> appointmentSlots = [];
    if (_makeAppointment) {
      for (var pair in _durationPriceControllers) {
        String duration = pair['duration']!.text;
        String priceStr = pair['price']!.text.replaceAll('\$', '').trim();
        if (duration.isNotEmpty && priceStr.isNotEmpty) {
          appointmentSlots.add({
            'duration': duration,
            'price': double.tryParse(priceStr) ?? 0.0,
          });
        }
      }
    }

    // Create employee model
    final employee = BusinessEmployeeModel(
      name: _employeeNameController.text,
      phone: _mobileNumberController.text,
      email: _emailController.text,
      serviceCategory: _categoryController.text.trim().isNotEmpty
          ? _categoryController.text.trim()
          : null,
      headline: _headlineController.text,
      about: _aboutController.text,
      whyChooseUs: _whyChooseControllers
          .map((c) => c.text)
          .where((t) => t.isNotEmpty)
          .toList(),
      price: double.tryParse(_priceController.text.replaceAll('\$', '')),
      isAppointmentBased: _makeAppointment,
      availableTime: _availableTimeController.text,
      appointmentOptions: _makeAppointment
          ? appointmentSlots
                .map(
                  (slot) => AppointmentOption(
                    duration: slot['duration'],
                    price: slot['price'],
                  ),
                )
                .toList()
          : null,
    );

    if (widget.employee != null) {
      // Update Mode
      await _viewModel.updateEmployee(
        id: widget.employee!.id!,
        employee: employee,
        idCardFront: _idCardFrontImage?.path,
        idCardBack: _idCardBackImage?.path,
      );
    } else {
      // Create Mode
      await _viewModel.createEmployee(
        employee: employee,
        idCardFront: _idCardFrontImage!.path,
        idCardBack: _idCardBackImage!.path,
      );
    }
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _categoryController.dispose();
    _headlineController.dispose();
    _aboutController.dispose();
    _priceController.dispose();
    _availableTimeController.dispose();
    for (var controller in _whyChooseControllers) {
      controller.dispose();
    }
    for (var pair in _durationPriceControllers) {
      pair['duration']?.dispose();
      pair['price']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.employee != null ? "Update Service" : "Create Employee",
      ),
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile Photo / ID Front',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Profile Image Picker
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _idCardFrontImage != null
                                ? FileImage(File(_idCardFrontImage!.path))
                                : (widget.employee?.idCardFront != null &&
                                      widget.employee!.idCardFront!.isNotEmpty)
                                ? NetworkImage(widget.employee!.idCardFront!)
                                      as ImageProvider
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickIdCardFrontImage,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2D6A4F),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Employee Name
                    const Text(
                      'Employee name',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _employeeNameController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter employee name',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D6A4F),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D6A4F),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Mobile Number
                    const Text(
                      'Mobile number',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter mobile number',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D6A4F),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email Address
                    const Text(
                      'E-mail address',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter e-mail address',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D6A4F),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Upload Employee Service Photo
                    const Text(
                      'Upload employee service photo',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickIdCardBackImage,
                      child: CustomPaint(
                        painter: DashedBorderPainter(
                          color: const Color(0xFF2D6A4F),
                          strokeWidth: 1.5,
                          dashWidth: 6,
                          dashSpace: 4,
                          borderRadius: 8,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 134,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _idCardBackImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_idCardBackImage!.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                )
                              : (widget.employee?.idCardBack != null &&
                                    widget.employee!.idCardBack!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    widget.employee!.idCardBack!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF2D6A4F),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Click to upload',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'PNG or GIF (max. 5MB)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF999999),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Category ID
                    const Text(
                      'Category ID',
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _categoryController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText:
                            'Enter category ID (e.g., 691a3d69bd6bcc9b83148ed6)',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D6A4F),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D6A4F),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Headline',
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _headlineController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Professional Cleaning Expert',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D6A4F),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // About this service
                    const Text(
                      'About this service',
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        TextField(
                          controller: _aboutController,
                          maxLines: 4,
                          maxLength: 500,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Write service details',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD0D0D0),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF2D6A4F),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF2D6A4F),
                                width: 1.5,
                              ),
                            ),
                            counterText: '',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _charCount = value.length;
                            });
                          },
                        ),
                        Positioned(
                          bottom: 10,
                          right: 14,
                          child: Text(
                            '$_charCount/500',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Why choose us
                    const Text(
                      'Why choose us',
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._whyChooseControllers.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: entry.value,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD0D0D0),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF2D6A4F),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF2D6A4F),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),

                    // Service pricing
                    const Text(
                      'Service pricing',
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: '150',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 14, right: 8),
                          child: Icon(
                            Icons.attach_money,
                            color: Color(0xFF999999),
                            size: 18,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D0D0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D6A4F),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Make an Appointment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Make an Appointment',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: _makeAppointment,
                            onChanged: (value) {
                              setState(() {
                                _makeAppointment = value;
                              });
                            },
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppColors.mainAppColor,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFE0E0E0),
                          ),
                        ),
                      ],
                    ),

                    // Appointment Section - Shows when toggle is ON
                    if (_makeAppointment) ...[
                      const SizedBox(height: 20),

                      // Available time
                      const Text(
                        'Available time',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _availableTimeController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: '06:00am to 09:00pm',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF999999),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D0D0),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D0D0),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF2D6A4F),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Add Duration & Price button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            String nextDuration = "15 min";
                            String nextPrice = "50";

                            if (_durationPriceControllers.isNotEmpty) {
                              final last = _durationPriceControllers.last;
                              final lastDur = last['duration']?.text ?? "0 min";
                              final lastPri = (last['price']?.text ?? "0")
                                  .replaceAll(',', '')
                                  .replaceAll('\$', '')
                                  .trim();

                              // Increment duration
                              int durValue =
                                  int.tryParse(lastDur.split(' ')[0]) ?? 0;
                              nextDuration = "${durValue + 15} min";

                              // Increment price
                              int priValue = int.tryParse(lastPri) ?? 0;
                              nextPrice = "${priValue + 50}";
                            }

                            _durationPriceControllers.add({
                              'duration': TextEditingController(
                                text: nextDuration,
                              ),
                              'price': TextEditingController(
                                text: '\$$nextPrice',
                              ),
                            });
                          });
                        },
                        child: CustomPaint(
                          painter: DashedBorderPainter(
                            color: AppColors.grey,
                            strokeWidth: 1.5,
                            dashWidth: 5,
                            dashSpace: 3,
                            borderRadius: 8,
                          ),
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Add Duration & Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Duration and Price pairs
                      ..._durationPriceControllers.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              // Duration field
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Duration',
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: entry.value['duration'],
                                      style: const TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
                                        hintText: '15 min',
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD0D0D0),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD0D0D0),
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF2D6A4F),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Price field
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Price',
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: entry.value['price'],
                                      style: const TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
                                        hintText: '50',
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.only(
                                            left: 14,
                                            right: 8,
                                          ),
                                          child: Icon(
                                            Icons.attach_money,
                                            color: Color(0xFF999999),
                                            size: 18,
                                          ),
                                        ),
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                              minWidth: 0,
                                              minHeight: 0,
                                            ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD0D0D0),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD0D0D0),
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF2D6A4F),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 15),

                    // Create Service/Appointment Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6A4F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Obx(
                          () => _viewModel.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }
}
