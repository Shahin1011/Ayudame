import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/provider/home/HomeProviderScreen.dart';
import 'package:middle_ware/widgets/CustomDashedBorder.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class allCreateServicePage extends StatefulWidget {
  const allCreateServicePage({super.key});

  @override
  State<allCreateServicePage> createState() => _allCreateServicePageState();
}

class _allCreateServicePageState extends State<allCreateServicePage> {
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
  String? _selectedImage;

  // Appointment fields
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final List<Map<String, TextEditingController>> _durationPriceControllers = [
    {
      'duration': TextEditingController(text: '30 min'),
      'price': TextEditingController(text: '50'),
    },
    {
      'duration': TextEditingController(text: '1 hour'),
      'price': TextEditingController(text: '150'),
    },
    {
      'duration': TextEditingController(text: '1.5 hour'),
      'price': TextEditingController(text: '200'),
    },
  ];

  @override
  void dispose() {
    _headlineController.dispose();
    _aboutController.dispose();
    _priceController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
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
                Text(
                  isAppointment
                      ? 'Your appointment successfully added'
                      : 'Your service successfully added',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const HomeProviderScreen());
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
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => const HomeProviderScreen());
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 13,
          color: Color(0xFF999999),
        ),
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
            width: 2,
          ),
        ),
        counterText: '',
      ),
      onChanged: maxLength != null
          ? (value) {
        setState(() {
          _charCount = value.length;
        });
      }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Service"),
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
                      onTap: () {
                        // Handle image upload
                      },
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
                          child: Column(
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
                              const SizedBox(height: 8),
                              const Text(
                                'Click to upload',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF999999),
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
                        initialValue: _selectedCategory,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF2D6A4F),
                          size: 24,
                        ),
                        items: [
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

                    // Headline
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
                    _buildTextField(
                      controller: _headlineController,
                      hintText: 'Enter service name',
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
                        _buildTextField(
                          controller: _aboutController,
                          hintText: 'Write service details',
                          maxLines: 4,
                          maxLength: 500,
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
                        child: _buildTextField(
                          controller: entry.value,
                          hintText: 'Enter reason ${entry.key + 1}',
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
                    _buildTextField(
                      controller: _priceController,
                      hintText: '250',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 14, right: 8),
                        child: Icon(
                          Icons.attach_money,
                          color: Color(0xFF999999),
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Make an Appointment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Appointment Booking',
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
                            activeTrackColor: const Color(0xFF2D6A4F),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFE0E0E0),
                          ),
                        ),
                      ],
                    ),

                    // Appointment Section
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
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _fromTimeController,
                              hintText: 'From',
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'To',
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _toTimeController,
                              hintText: '09:55 AM',
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Add Duration & Price button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _durationPriceControllers.add({
                              'duration': TextEditingController(),
                              'price': TextEditingController(),
                            });
                          });
                        },
                        child: CustomPaint(
                          painter: DashedBorderPainter(
                            color: const Color(0xFFD0D0D0),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add Duration & Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
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
                                    _buildTextField(
                                      controller: entry.value['duration']!,
                                      hintText: '30 min',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
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
                                    _buildTextField(
                                      controller: entry.value['price']!,
                                      hintText: '50',
                                      keyboardType: TextInputType.number,
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 30),

                    // Save Changes Button
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
                              : 'Save Changes',
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