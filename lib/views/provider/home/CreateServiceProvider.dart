import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/provider/home/HomeProviderScreen.dart';
import 'package:middle_ware/widgets/CustomDashedBorder.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({Key? key}) : super(key: key);

  @override
  State<CreateServicePage> createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
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
  String? _selectedCategory;
  int _charCount = 0;
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  // Appointment fields
  final TextEditingController _availableTimeController = TextEditingController(
    text: '06:00am-09:00pm',
  );
  final List<Map<String, TextEditingController>> _durationPriceControllers = [
    {
      'duration': TextEditingController(text: '30 min'),
      'price': TextEditingController(text: '\$50'),
    },
    {
      'duration': TextEditingController(text: '1 hour'),
      'price': TextEditingController(text: '\$150'),
    },
    {
      'duration': TextEditingController(text: '1.5 hour'),
      'price': TextEditingController(text: '\$200'),
    },
  ];
  @override
  void dispose() {
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

  void _showSuccessDialog(bool isAppointment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),

                // Success icon
                Container(
                  width: 80,
                  height: 80,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2D6A4F),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF2D6A4F),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                // Success message
                Text(
                  isAppointment
                      ? 'Your appointment successfully add'
                      : 'Your service successfully add',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                // Create Service/Appointment button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const HomeProviderScreen());
                      // Handle create service/appointment action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D6A4F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isAppointment ? 'Create Appointment' : 'Create Service',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Go Home button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => const HomeProviderScreen());
                      // Handle go home action
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Go Home',
                      style: TextStyle(
                        color: Color(0xFF2D6A4F),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Create Service"),
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
                    // Upload Photo Section
                    const Text(
                      'Upload your service photo',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CustomPaint(
                        painter: DashedBorderPainter(
                          color: const Color(0xFF2D6A4F), // Your theme green
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
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_image!.path),
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
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Select Category
                    const Text(
                      'Select category',
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF2D6A4F),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: InputBorder.none,
                        ),
                        hint: const Text(
                          'Select service category',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 13,
                            color: Color(0xFF999999),
                          ),
                        ),
                        value: _selectedCategory,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF2D6A4F),
                          size: 24,
                        ),
                        items:
                            [
                                  'Event / Show Organizer',
                                  'Music / Band / DJ',
                                  'Film / Media Production',
                                  'Theatre / Drama',
                                  'Gaming / Esports',
                                  'Amusement / Fun Zone',
                                  'Content Creator / Studio',
                                  'Ticketing / Promotions',
                                ]
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
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
                    TextField(
                      controller: _headlineController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter service name',
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
                            color: Color(0xFF2D6A4F),
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
                    }).toList(),
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
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: '\$150',
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
                            activeColor: Colors.white,
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
                      TextField(
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
                      CustomPaint(
                        painter: DashedBorderPainter(
                          color: AppColors.grey,
                          strokeWidth: 1.5,
                          dashWidth: 5,
                          dashSpace: 3,
                          borderRadius: 8,
                        ),
                        child: Container(
                          // Increased height from 12 to a functional size (e.g., 48)
                          height: 48,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize:
                                MainAxisSize.min, // Adjusts width to content
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
                                    TextField(
                                      controller: entry.value['duration'],
                                      style: const TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
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
                                    TextField(
                                      controller: entry.value['price'],
                                      style: const TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
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
                      }).toList(),
                    ],

                    const SizedBox(height: 15),

                    // Create Service/Appointment Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showSuccessDialog(_makeAppointment);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6A4F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _makeAppointment
                              ? 'Create Appointment'
                              : 'Create Service',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
        ],
      ),
    );
  }
}
