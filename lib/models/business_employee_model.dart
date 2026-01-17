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
  });

  factory BusinessEmployeeModel.fromJson(Map<String, dynamic> json) {
    return BusinessEmployeeModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['fullName'] ?? json['name'] ?? json['employeeName'],
      phone: json['mobileNumber'] ?? json['phone'],
      email: json['email'],
      // Backend doesn't have 'photo' field - use servicePhoto for both
      profileImage:
          json['servicePhoto'] ?? json['photo'] ?? json['profileImage'],
      idCardFront: json['idCardFront'],
      idCardBack: json['servicePhoto'] ?? json['idCardBack'],
      serviceCategory:
          json['categories'] ?? json['serviceCategory'] ?? json['category'],
      headline: json['headline'],
      about: json['description'] ?? json['about'],
      whyChooseUs: json['whyChooseService'] != null
          ? (json['whyChooseService'] is List
                ? List<String>.from(json['whyChooseService'])
                : [json['whyChooseService'].toString()])
          : (json['whyChooseUs'] != null
                ? List<String>.from(json['whyChooseUs'])
                : null),
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      isAppointmentBased:
          json['appointmentEnabled'] ?? json['isAppointmentBased'] ?? false,
      availableTime: json['availableTime'],
      appointmentOptions:
          (json['appointmentSlots'] != null ||
              json['appointmentOptions'] != null)
          ? ((json['appointmentSlots'] ?? json['appointmentOptions']) as List)
                .map((e) => AppointmentOption.fromJson(e))
                .toList()
          : null,
      businessId: json['businessId'],
    );
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
    };
  }
}

class AppointmentOption {
  final String? duration; // e.g., "30 min"
  final double? price;

  AppointmentOption({this.duration, this.price});

  factory AppointmentOption.fromJson(Map<String, dynamic> json) {
    return AppointmentOption(
      duration: json['duration'],
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'duration': duration, 'price': price};
  }
}
