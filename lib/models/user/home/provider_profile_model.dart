class ProviderProfileResponse {
  final bool? success;
  final ProviderProfileData? data;

  ProviderProfileResponse({this.success, this.data});

  factory ProviderProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProviderProfileResponse(
      success: json['success'],
      data: json['data'] != null ? ProviderProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProviderProfileData {
  final ProviderInfo? provider;
  final AllServices? allServices;
  final List<ProviderReview>? reviews;
  final List<PortfolioItem>? portfolio;

  ProviderProfileData({this.provider, this.allServices, this.reviews, this.portfolio});

  factory ProviderProfileData.fromJson(Map<String, dynamic> json) {
    return ProviderProfileData(
      provider: json['provider'] != null ? ProviderInfo.fromJson(json['provider']) : null,
      allServices: json['allServices'] != null ? AllServices.fromJson(json['allServices']) : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List).map((i) => ProviderReview.fromJson(i)).toList()
          : null,
      portfolio: json['portfolio'] != null
          ? (json['portfolio'] as List).map((i) => PortfolioItem.fromJson(i)).toList()
          : null,
    );
  }
}

class ProviderInfo {
  final String? name;
  final String? image;
  final String? address;
  final num? rating;
  final int? totalReviews;

  ProviderInfo({this.name, this.image, this.address, this.rating, this.totalReviews});

  factory ProviderInfo.fromJson(Map<String, dynamic> json) {
    return ProviderInfo(
      name: json['name'],
      image: json['image'],
      address: json['address'],
      rating: json['rating'],
      totalReviews: json['totalReviews'],
    );
  }
}

class AllServices {
  final int? totalServices;
  final List<ProfileService>? services;

  AllServices({this.totalServices, this.services});

  factory AllServices.fromJson(Map<String, dynamic> json) {
    return AllServices(
      totalServices: json['totalServices'],
      services: json['services'] != null
          ? (json['services'] as List).map((i) => ProfileService.fromJson(i)).toList()
          : null,
    );
  }
}

class ProfileService {
  final String? serviceId;
  final String? image;
  final String? title;
  final String? about;
  final num? rating;
  final num? basePrice;
  final bool? appointmentEnabled;
  final List<ServiceAppointmentSlot>? appointmentSlots;
  final num? minAppointmentPrice;
  final int? daysAgo;
  final int? totalReviews;

  ProfileService({
    this.serviceId,
    this.image,
    this.title,
    this.about,
    this.rating,
    this.basePrice,
    this.appointmentEnabled,
    this.appointmentSlots,
    this.minAppointmentPrice,
    this.daysAgo,
    this.totalReviews,
  });

  factory ProfileService.fromJson(Map<String, dynamic> json) {
    return ProfileService(
      serviceId: json['serviceId'],
      image: json['image'],
      title: json['title'],
      about: json['about'],
      rating: json['rating'],
      basePrice: json['basePrice'],
      appointmentEnabled: json['appointmentEnabled'],
      appointmentSlots: json['appointmentSlots'] != null
          ? (json['appointmentSlots'] as List).map((i) => ServiceAppointmentSlot.fromJson(i)).toList()
          : null,
      minAppointmentPrice: json['minAppointmentPrice'],
      daysAgo: json['daysAgo'],
      totalReviews: json['totalReviews'],
    );
  }
}

class ServiceAppointmentSlot {
  final int? duration;
  final String? durationUnit;
  final num? price;
  final String? id;

  ServiceAppointmentSlot({this.duration, this.durationUnit, this.price, this.id});

  factory ServiceAppointmentSlot.fromJson(Map<String, dynamic> json) {
    return ServiceAppointmentSlot(
      duration: json['duration'],
      durationUnit: json['durationUnit'],
      price: json['price'],
      id: json['_id'],
    );
  }
}

class ProviderReview {
  final String? reviewId;
  final num? rating;
  final String? comment;
  final String? createdAt;
  final ReviewUser? user;

  ProviderReview({this.reviewId, this.rating, this.comment, this.createdAt, this.user});

  factory ProviderReview.fromJson(Map<String, dynamic> json) {
    return ProviderReview(
      reviewId: json['reviewId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      user: json['user'] != null ? ReviewUser.fromJson(json['user']) : null,
    );
  }
}

class ReviewUser {
  final String? name;
  final String? image;

  ReviewUser({this.name, this.image});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      name: json['name'],
      image: json['image'],
    );
  }
}

class PortfolioItem {
  final String? portfolioId;
  final String? beforeImage;
  final String? afterImage;
  final String? about;

  PortfolioItem({this.portfolioId, this.beforeImage, this.afterImage, this.about});

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      portfolioId: json['portfolioId'],
      beforeImage: json['beforeImage'],
      afterImage: json['afterImage'],
      about: json['about'],
    );
  }
}
