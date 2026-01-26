class ProviderProfileModel {
  final bool success;
  final ProviderData data;

  ProviderProfileModel({
    required this.success,
    required this.data,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      success: json['success'] ?? false,
      data: ProviderData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProviderData {
  final ProviderInfo provider;

  ProviderData({required this.provider});

  factory ProviderData.fromJson(Map<String, dynamic> json) {
    return ProviderData(
      provider: ProviderInfo.fromJson(json['provider'] ?? {}),
    );
  }
}

class ProviderInfo {
  final String id;
  final IdCard idCard;
  final UserInfo userId;
  final String verificationStatus;
  final String occupation;
  final String referenceId;
  final List<dynamic> categories;
  final List<dynamic> servicesOffered;
  final double rating;
  final int totalReviews;
  final bool isAvailable;
  final int completedJobs;
  final bool isPaidForHomeScreen;
  final String? paidHomeScreenExpiresAt;
  final String activityTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? idVerifiedAt;

  ProviderInfo({
    required this.id,
    required this.idCard,
    required this.userId,
    required this.verificationStatus,
    required this.occupation,
    required this.referenceId,
    required this.categories,
    required this.servicesOffered,
    required this.rating,
    required this.totalReviews,
    required this.isAvailable,
    required this.completedJobs,
    required this.isPaidForHomeScreen,
    this.paidHomeScreenExpiresAt,
    required this.activityTime,
    this.createdAt,
    this.updatedAt,
    this.idVerifiedAt,
  });

  factory ProviderInfo.fromJson(Map<String, dynamic> json) {
    return ProviderInfo(
      id: json['_id'] ?? json['id'] ?? '',
      idCard: IdCard.fromJson(json['idCard'] ?? {}),
      userId: UserInfo.fromJson(json['userId'] ?? {}),
      verificationStatus: json['verificationStatus'] ?? '',
      occupation: json['occupation'] ?? '',
      referenceId: json['referenceId'] ?? '',
      categories: List<dynamic>.from(json['categories'] ?? []),
      servicesOffered: List<dynamic>.from(json['servicesOffered'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
      completedJobs: json['completedJobs'] ?? 0,
      isPaidForHomeScreen: json['isPaidForHomeScreen'] ?? false,
      paidHomeScreenExpiresAt: json['paidHomeScreenExpiresAt'],
      activityTime: json['activityTime'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      idVerifiedAt: json['idVerifiedAt'] != null ? DateTime.parse(json['idVerifiedAt']) : null,
    );
  }
}

class IdCard {
  final String? frontImage;
  final String? backImage;
  final String? idNumber;
  final String fullNameOnId;
  final String? dateOfBirth;
  final String? expiryDate;
  final String? issuedDate;
  final String? nationality;
  final String? address;

  IdCard({
    this.frontImage,
    this.backImage,
    this.idNumber,
    required this.fullNameOnId,
    this.dateOfBirth,
    this.expiryDate,
    this.issuedDate,
    this.nationality,
    this.address,
  });

  factory IdCard.fromJson(Map<String, dynamic> json) {
    return IdCard(
      frontImage: json['frontImage'],
      backImage: json['backImage'],
      idNumber: json['idNumber'],
      fullNameOnId: json['fullNameOnId'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      expiryDate: json['expiryDate'],
      issuedDate: json['issuedDate'],
      nationality: json['nationality'],
      address: json['address'],
    );
  }
}

class UserInfo {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String authProvider;
  final String? profilePicture;
  final bool termsAccepted;
  final String userType;
  final bool isActive;
  final bool isPendingVerification;
  final Location location;

  UserInfo({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.authProvider,
    this.profilePicture,
    required this.termsAccepted,
    required this.userType,
    required this.isActive,
    required this.isPendingVerification,
    required this.location,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      authProvider: json['authProvider'] ?? '',
      profilePicture: json['profilePicture'],
      termsAccepted: json['termsAccepted'] ?? false,
      userType: json['userType'] ?? '',
      isActive: json['isActive'] ?? false,
      isPendingVerification: json['isPendingVerification'] ?? false,
      location: Location.fromJson(json['location'] ?? {}),
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;
  final String address;

  Location({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from((json['coordinates'] ?? [0.0, 0.0]).map((e) => e.toDouble())),
      address: json['address'] ?? '',
    );
  }
}
