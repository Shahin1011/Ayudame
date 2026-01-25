
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/CustomDashedBorder.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import 'package:middle_ware/widgets/custom_loading_button.dart';
import 'package:middle_ware/utils/constants.dart' hide AppColors;
import 'package:middle_ware/utils/token_service.dart';
import 'package:middle_ware/models/user/categories/category_model.dart';

class SaveServicePage extends StatefulWidget {
  const SaveServicePage({Key? key}) : super(key: key);

  @override
  State<SaveServicePage> createState() => _SaveServicePageState();
}

class _SaveServicePageState extends State<SaveServicePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final List<TextEditingController> _whyChooseControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> _whyChooseKeys = [
    'twentyFourSeven',
    'efficientAndFast',
    'affordablePrices',
    'expertTeam',
  ];

  bool _makeAppointment = false;
  String? _selectedCategoryId;
  int _charCount = 0;
  XFile? _image;
  String _serviceId = '';
  String _existingImageUrl = '';
  bool _isLoading = false;
  bool _categoriesLoading = false;
  String _categoriesError = '';
  List<CategoryModel> _categories = [];

  final TextEditingController _availableTimeController = TextEditingController(
    text: '06:00am-09:00pm',
  );
  final List<Map<String, TextEditingController>> _durationPriceControllers = [
    {'duration': TextEditingController(), 'price': TextEditingController()},
    {'duration': TextEditingController(), 'price': TextEditingController()},
    {'duration': TextEditingController(), 'price': TextEditingController()},
  ];

  @override
  void initState() {
    super.initState();
    _loadFromArgs();
    _fetchCategories();
  }

  void _loadFromArgs() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _serviceId = args['id'] ?? '';
    _headlineController.text = args['headline'] ?? '';
    _aboutController.text = args['description'] ?? '';
    _existingImageUrl = args['servicePhoto'] ?? '';
    _selectedCategoryId = args['categoryId'];
    _makeAppointment = args['appointmentEnabled'] ?? false;
    _priceController.text = (args['basePrice'] ?? '').toString();

    final whyChoose = (args['whyChooseUs'] ?? {}) as Map<String, dynamic>;
    for (var i = 0; i < _whyChooseKeys.length; i++) {
      _whyChooseControllers[i].text =
          (whyChoose[_whyChooseKeys[i]] ?? '').toString();
    }

    final slots = (args['appointmentSlots'] ?? []) as List<dynamic>;
    for (var i = 0; i < _durationPriceControllers.length; i++) {
      if (i >= slots.length) break;
      final slot = slots[i] as Map<String, dynamic>;
      _durationPriceControllers[i]['duration']?.text =
          "${slot['duration'] ?? ''} ${slot['durationUnit'] ?? 'minutes'}";
      _durationPriceControllers[i]['price']?.text =
          (slot['price'] ?? '').toString();
    }
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _categoriesLoading = true;
      _categoriesError = '';
    });

    try {
      await TokenService().init();
      final token = await TokenService().getToken();
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse("${AppConstants.BASE_URL}/api/categories"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list =
            data["data"]?['categories'] ?? data['categories'] ?? [];
        _categories = list
            .map((e) => CategoryModel.fromJson(e))
            .where((c) => c.isActive)
            .toList();
        if (_categories.isEmpty) {
          _categoriesError = 'No categories found.';
        }
      } else {
        _categoriesError =
            'Failed to load categories (${response.statusCode}).';
      }
    } catch (e) {
      _categoriesError = e.toString();
    } finally {
      setState(() {
        _categoriesLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final ext = image.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
      Get.snackbar(
        'Invalid Format',
        'Only JPG, JPEG, PNG, or WEBP files are allowed.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _image = image;
    });
  }

  int? _parseIntValue(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    return value?.round();
  }

  int? _parseDurationMinutes(String input) {
    final lower = input.toLowerCase();
    final match = RegExp(r'([0-9]+(\\.[0-9]+)?)').firstMatch(lower);
    if (match == null) return null;
    final value = double.tryParse(match.group(1) ?? '');
    if (value == null) return null;
    if (lower.contains('hour')) {
      return (value * 60).round();
    }
    return value.round();
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _updateService() async {
    if (!_formKey.currentState!.validate()) return;

    if (_serviceId.isEmpty) {
      Get.snackbar('Error', 'Service ID is missing.');
      return;
    }

    if (!await _hasInternetConnection()) {
      Get.snackbar('No Internet', 'Please check your internet connection.');
      return;
    }

    await TokenService().init();
    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please log in again to continue.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final basePrice = _parseIntValue(_priceController.text.trim());
    if (basePrice == null || (!_makeAppointment && basePrice <= 0)) {
      Get.snackbar(
        'Invalid Price',
        'Please enter a valid base price.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final whyChooseUs = <String, String>{};
    for (var i = 0; i < _whyChooseControllers.length; i++) {
      final value = _whyChooseControllers[i].text.trim();
      if (value.isNotEmpty) {
        whyChooseUs[_whyChooseKeys[i]] = value;
      }
    }

    final body = <String, dynamic>{
      'category': _selectedCategoryId,
      'headline': _headlineController.text.trim(),
      'description': _aboutController.text.trim(),
      'whyChooseUs': whyChooseUs,
      'appointmentEnabled': _makeAppointment,
      'basePrice': basePrice,
    };

    if (_makeAppointment) {
      final slots = <Map<String, dynamic>>[];
      for (var i = 0; i < _durationPriceControllers.length; i++) {
        final durationText =
            _durationPriceControllers[i]['duration']?.text.trim() ?? '';
        final priceText =
            _durationPriceControllers[i]['price']?.text.trim() ?? '';

        if (durationText.isEmpty && priceText.isEmpty) {
          continue;
        }

        final durationMinutes = _parseDurationMinutes(durationText);
        final priceValue = _parseIntValue(priceText);
        if (durationMinutes == null || priceValue == null) {
          Get.snackbar(
            'Invalid Slot',
            'Please enter valid duration and price for slot ${i + 1}.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        slots.add({
          'duration': durationMinutes,
          'durationUnit': 'minutes',
          'price': priceValue,
        });
      }

      if (slots.isEmpty) {
        Get.snackbar(
          'Missing Slots',
          'Please add at least one appointment slot.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      body['appointmentSlots'] = slots;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse("${AppConstants.BASE_URL}/api/providers/services/$_serviceId"),
      );
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['category'] = body['category'] ?? '';
      request.fields['headline'] = body['headline'] ?? '';
      request.fields['description'] = body['description'] ?? '';
      request.fields['whyChooseUs'] = jsonEncode(body['whyChooseUs']);
      request.fields['appointmentEnabled'] =
          body['appointmentEnabled'].toString();
      request.fields['basePrice'] = body['basePrice'].toString();

      if (body.containsKey('appointmentSlots')) {
        request.fields['appointmentSlots'] = jsonEncode(body['appointmentSlots']);
      }

      if (_image != null) {
        final imagePath = _image!.path;
        final ext = imagePath.split('.').last.toLowerCase();
        final subtype = ext == 'png'
            ? 'png'
            : ext == 'webp'
                ? 'webp'
                : 'jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'servicePhoto',
            imagePath,
            filename: 'service_photo.$subtype',
            contentType: MediaType('image', subtype),
          ),
        );
      }

      final streamed = await request.send();
      final responseBody = await streamed.stream.bytesToString();
      final data = json.decode(responseBody);

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        Get.snackbar(
          'Success',
          data['message'] ?? 'Service updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Failed to update service',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Service'),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload your service photo',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage,
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
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_image!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : (_existingImageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          _existingImageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(Icons.image),
                                            );
                                          },
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      )),
                          ),
                        ),
                      ),
                      if (_image != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _image!.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select category',
                        style: TextStyle(
                          fontFamily: 'Inter',
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
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          hint: const Text(
                            'Select service category',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                          ),
                          value: _selectedCategoryId,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF2D6A4F),
                            size: 24,
                          ),
                          items: _categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category.id,
                                  child: Text(
                                    category.name,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_categoriesLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Loading categories...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      if (_categoriesError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _categoriesError,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        'Headline',
                        style: TextStyle(
                          fontFamily: 'Inter',
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a headline';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'About this service',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          TextFormField(
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
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please add a description';
                              }
                              return null;
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
                      const Text(
                        'Why choose us',
                        style: TextStyle(
                          fontFamily: 'Inter',
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
                      const Text(
                        'Service pricing',
                        style: TextStyle(
                          fontFamily: 'Inter',
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
                        validator: (value) {
                          final parsed = _parseIntValue(value ?? '');
                          if (parsed == null || (!_makeAppointment && parsed <= 0)) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Make an Appointment',
                            style: TextStyle(
                              fontFamily: 'Inter',
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
                      if (_makeAppointment) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Available time',
                          style: TextStyle(
                            fontFamily: 'Inter',
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
                        CustomPaint(
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
                                    fontFamily: 'Inter',
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
                                          fontFamily: 'Inter',
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Price',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
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
                      CustomLoadingButton(
                        title: 'Save Changes',
                        isLoading: _isLoading,
                        onTap: _updateService,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
