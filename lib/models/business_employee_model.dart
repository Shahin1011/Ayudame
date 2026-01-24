import '../services/api_service.dart';

class BusinessEmployeeModel {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? profileImage;
  final String? idCardFront;
  final String? idCardBack;
  final String? serviceCategory;
  final String? headline;
  final String? about;
  final List<String>? whyChooseUs;
  final double? price; // Base price or starting price
  final bool? isAppointmentBased;
  final String? availableTime;
  final List<AppointmentOption>? appointmentOptions;
  final String? businessId;
  final bool? isActive;

  BusinessEmployeeModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.profileImage,
    this.idCardFront,
    this.idCardBack,
    this.serviceCategory,
    this.headline,
    this.about,
    this.whyChooseUs,
    this.price,
    this.isAppointmentBased,
    this.availableTime,
    this.appointmentOptions,
    this.businessId,
    this.isActive,
  });

  // Aliases for UI compatibility with robust formatting
  String _formatUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http')) return url;
    // Base URL for images
    final String baseUrl = ApiService.baseURL;
    return '$baseUrl${url.startsWith('/') ? '' : '/'}$url';
  }

  String? get servicePhoto => _formatUrl(idCardBack ?? profileImage);
  String? get profilePicture => _formatUrl(profileImage);
  String get pricing => price?.toString() ?? '0';

  factory BusinessEmployeeModel.fromJson(Map<String, dynamic> json) {
    // Handle top-level 'data' wrapper if present
    final Map<String, dynamic> root = json['data'] ?? json;

    // Determine the source of data (merged or nested)
    final Map<String, dynamic> employeeData;
    final Map<String, dynamic>? serviceData;

    if (root['employee'] != null && root['employee'] is Map) {
      employeeData = root['employee'];
      // Check for 'services' array as seen in Postman response
      if (root['services'] != null &&
          root['services'] is List &&
          (root['services'] as List).isNotEmpty) {
        serviceData = root['services'][0] as Map<String, dynamic>;
      } else if (root['service'] != null && root['service'] is Map) {
        serviceData = root['service'] as Map<String, dynamic>;
      } else {
        serviceData = null;
      }
    } else {
      employeeData = root;
      serviceData = null;
    }

    // Helper to parse categories which might be a List of objects, strings or a single object
    dynamic parseCategory(Map<String, dynamic> data) {
      final val =
          data['categories'] ??
          data['category'] ??
          data['serviceCategory'] ??
          data['service_category'];
      if (val == null) return null;

      if (val is List) {
        if (val.isEmpty) return null;
        if (val[0] is Map) {
          return val[0]['name']?.toString() ??
              val[0]['_id']?.toString() ??
              val[0]['id']?.toString();
        }
        return val[0].toString();
      }

      if (val is Map) {
        return val['name']?.toString() ??
            val['_id']?.toString() ??
            val['id']?.toString();
      }

      return val.toString();
    }

    // Helper to parse whyChooseUs
    List<String>? parseWhyChoose(Map<String, dynamic> data) {
      final val =
          data['whyChooseService'] ??
          data['why_choose_service'] ??
          data['whyChooseUs'] ??
          data['why_choose_us'];
      if (val == null) return null;

      if (val is List) {
        return val.map((e) => e.toString()).toList();
      }

      if (val is Map) {
        return val.values
            .map((v) => v.toString())
            .where((v) => v.isNotEmpty)
            .toList();
      }

      return [val.toString()];
    }

    // Merge logic: fields in serviceData take priority for headline/description etc.
    final String? headline =
        (serviceData?['headline'] ??
                employeeData['headline'] ??
                serviceData?['service_name'])
            ?.toString();

    final String? description =
        (serviceData?['description'] ??
                employeeData['description'] ??
                employeeData['about'] ??
                serviceData?['about'])
            ?.toString();

    final String? servicePhoto =
        (serviceData?['servicePhoto'] ??
                serviceData?['service_photo'] ??
                employeeData['servicePhoto'] ??
                employeeData['idCardBack'] ??
                employeeData['id_card_back'])
            ?.toString();

    return BusinessEmployeeModel(
      id: employeeData['id']?.toString() ?? employeeData['_id']?.toString(),
      name:
          (employeeData['fullName'] ??
                  employeeData['full_name'] ??
                  employeeData['name'] ??
                  employeeData['employeeName'])
              ?.toString(),
      phone:
          (employeeData['mobileNumber'] ??
                  employeeData['mobile_number'] ??
                  employeeData['phone'])
              ?.toString(),
      email: employeeData['email']?.toString(),
      profileImage:
          (employeeData['profilePhoto'] ??
                  employeeData['profile_photo'] ??
                  employeeData['profileImage'] ??
                  employeeData['photo'])
              ?.toString(),
      idCardFront:
          (employeeData['idCardFront'] ??
                  employeeData['id_card_front'] ??
                  employeeData['profilePhoto'] ??
                  employeeData['profile_photo'])
              ?.toString(),
      idCardBack: servicePhoto,
      serviceCategory: parseCategory(serviceData ?? employeeData),
      headline: headline,
      about: description,
      whyChooseUs: parseWhyChoose(serviceData ?? employeeData),
      price: (serviceData?['basePrice'] ?? employeeData['basePrice']) != null
          ? double.tryParse(
              (serviceData?['basePrice'] ?? employeeData['basePrice'])
                  .toString(),
            )
          : (serviceData?['price'] ?? employeeData['price']) != null
          ? double.tryParse(
              (serviceData?['price'] ?? employeeData['price']).toString(),
            )
          : null,
      isAppointmentBased:
          (serviceData?['appointmentEnabled'] ??
                  employeeData['appointmentEnabled'] ??
                  employeeData['isAppointmentBased'] ??
                  false)
              .toString()
              .toLowerCase() ==
          'true',
      availableTime:
          (employeeData['availableTime'] ?? employeeData['available_time'])
              ?.toString(),
      appointmentOptions:
          (serviceData?['appointmentSlots'] ??
                  serviceData?['appointment_slots'] ??
                  employeeData['appointmentOptions']) !=
              null
          ? ((serviceData?['appointmentSlots'] ??
                        serviceData?['appointment_slots'] ??
                        employeeData['appointmentOptions'])
                    as List)
                .map((e) => AppointmentOption.fromJson(e))
                .toList()
          : null,
      businessId:
          (employeeData['businessId'] ??
                  employeeData['business_id'] ??
                  employeeData['businessOwnerId'])
              ?.toString(),
      isActive: employeeData['isActive'] ?? employeeData['active'] ?? true,
    );
  }

  /// Factory to merge employee and service data when they come separately
  factory BusinessEmployeeModel.fromJsonWithService({
    required Map<String, dynamic> employeeData,
    Map<String, dynamic>? serviceData,
  }) {
    // Construct a composite map to reuse fromJson nested logic precisely
    Map<String, dynamic> composite = {};
    composite['employee'] = employeeData;
    if (serviceData != null) {
      composite['services'] = [serviceData];
    }
    return BusinessEmployeeModel.fromJson(composite);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': name,
      'mobileNumber': phone,
      'email': email,
      'photo': profileImage,
      'idCardFront': idCardFront,
      'servicePhoto': idCardBack,
      'categories': serviceCategory,
      'headline': headline,
      'description': about,
      'whyChooseService': whyChooseUs,
      'price': price,
      'appointmentEnabled': isAppointmentBased,
      'availableTime': availableTime,
      'appointmentSlots': appointmentOptions?.map((e) => e.toJson()).toList(),
      'businessId': businessId,
      'isActive': isActive,
    };
  }
}

class AppointmentOption {
  final String? duration; // e.g., "30 min"
  final double? price;

  AppointmentOption({this.duration, this.price});

  factory AppointmentOption.fromJson(Map<String, dynamic> json) {
    return AppointmentOption(
      duration: json['duration']?.toString(),
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'duration': duration, 'price': price};
  }
}
