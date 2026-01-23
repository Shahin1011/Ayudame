import 'provider_profile_model.dart';

class BusinessDetailsResponse {
  final bool? success;
  final BusinessDetailsData? data;

  BusinessDetailsResponse({this.success, this.data});

  factory BusinessDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsResponse(
      success: json['success'],
      data: json['data'] != null ? BusinessDetailsData.fromJson(json['data']) : null,
    );
  }
}

class BusinessDetailsData {
  final BusinessHeaderInfo? businessDetails;
  final List<TeamMember>? team;
  final List<BusinessService>? services;
  final List<ProviderReview>? reviews;

  BusinessDetailsData({this.businessDetails, this.team, this.services, this.reviews});

  factory BusinessDetailsData.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsData(
      businessDetails: json['businessDetails'] != null ? BusinessHeaderInfo.fromJson(json['businessDetails']) : null,
      team: json['team'] != null ? (json['team'] as List).map((i) => TeamMember.fromJson(i)).toList() : null,
      services: json['services'] != null ? (json['services'] as List).map((i) => BusinessService.fromJson(i)).toList() : null,
      reviews: json['reviews'] != null ? (json['reviews'] as List).map((i) => ProviderReview.fromJson(i)).toList() : null,
    );
  }
}

class BusinessHeaderInfo {
  final String? businessOwnerId;
  final String? businessCoverPhoto;
  final String? businessPhoto;
  final String? businessName;
  final int? employeeCount;
  final int? serviceCount;
  final int? appointmentServiceCount;
  final String? businessLocation;
  final String? about;

  BusinessHeaderInfo({
    this.businessOwnerId,
    this.businessCoverPhoto,
    this.businessPhoto,
    this.businessName,
    this.employeeCount,
    this.serviceCount,
    this.appointmentServiceCount,
    this.businessLocation,
    this.about,
  });

  factory BusinessHeaderInfo.fromJson(Map<String, dynamic> json) {
    return BusinessHeaderInfo(
      businessOwnerId: json['businessOwnerId'],
      businessCoverPhoto: json['businessCoverPhoto'],
      businessPhoto: json['businessPhoto'],
      businessName: json['businessName'],
      employeeCount: json['employeeCount'],
      serviceCount: json['serviceCount'],
      appointmentServiceCount: json['appointmentServiceCount'],
      businessLocation: json['businessLocation'],
      about: json['about'],
    );
  }
}

class TeamMember {
  final String? employeeId;
  final String? employeeServicePhoto;
  final String? employeeImage;
  final String? employeeName;
  final String? employeeAddress;
  final String? serviceHeadline;
  final String? serviceDescription;
  final num? rating;
  final int? totalReviews;
  final num? basePrice;
  final bool? appointmentEnabled;
  final List<BusinessAppointmentSlot>? appointmentSlots;
  final num? minAppointmentPrice;
  final int? daysAgo;

  TeamMember({
    this.employeeId,
    this.employeeServicePhoto,
    this.employeeImage,
    this.employeeName,
    this.employeeAddress,
    this.serviceHeadline,
    this.serviceDescription,
    this.rating,
    this.totalReviews,
    this.basePrice,
    this.appointmentEnabled,
    this.appointmentSlots,
    this.minAppointmentPrice,
    this.daysAgo,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      employeeId: json['employeeId'],
      employeeServicePhoto: json['employeeServicePhoto'],
      employeeImage: json['employeeImage'],
      employeeName: json['employeeName'],
      employeeAddress: json['employeeAddress'],
      serviceHeadline: json['serviceHeadline'],
      serviceDescription: json['serviceDescription'],
      rating: json['rating'],
      totalReviews: json['totalReviews'],
      basePrice: json['basePrice'],
      appointmentEnabled: json['appointmentEnabled'],
      appointmentSlots: json['appointmentSlots'] != null
          ? (json['appointmentSlots'] as List).map((i) => BusinessAppointmentSlot.fromJson(i)).toList()
          : null,
      minAppointmentPrice: json['minAppointmentPrice'],
      daysAgo: json['daysAgo'],
    );
  }
}

class BusinessAppointmentSlot {
  final int? duration;
  final String? durationUnit;
  final num? price;
  final String? id;

  BusinessAppointmentSlot({this.duration, this.durationUnit, this.price, this.id});

  factory BusinessAppointmentSlot.fromJson(Map<String, dynamic> json) {
    return BusinessAppointmentSlot(
      duration: json['duration'],
      durationUnit: json['durationUnit'],
      price: json['price'],
      id: json['_id'],
    );
  }
}

class BusinessService {
  final String? serviceId;
  final String? headline;

  BusinessService({this.serviceId, this.headline});

  factory BusinessService.fromJson(Map<String, dynamic> json) {
    return BusinessService(
      serviceId: json['serviceId'],
      headline: json['headline'],
    );
  }
}
