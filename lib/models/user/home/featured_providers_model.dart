class FeaturedProvidersResponse {
  final bool? success;
  final String? message;
  final FeaturedProvidersData? data;

  FeaturedProvidersResponse({this.success, this.message, this.data});

  factory FeaturedProvidersResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedProvidersResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? FeaturedProvidersData.fromJson(json['data']) : null,
    );
  }
}

class FeaturedProvidersData {
  final List<FeaturedProvider>? providers;
  final int? count;
  final UserLocation? userLocation;

  FeaturedProvidersData({this.providers, this.count, this.userLocation});

  factory FeaturedProvidersData.fromJson(Map<String, dynamic> json) {
    return FeaturedProvidersData(
      providers: json['providers'] != null
          ? (json['providers'] as List).map((i) => FeaturedProvider.fromJson(i)).toList()
          : null,
      count: json['count'],
      userLocation: json['userLocation'] != null ? UserLocation.fromJson(json['userLocation']) : null,
    );
  }
}

class FeaturedProvider {
  final String? providerId;
  final String? name;
  final String? profileImage;
  final String? address;
  final dynamic distance;
  final String? distanceKm;
  final String? activityTime;
  final dynamic rating;
  final int? totalReviews;
  final int? completedJobs;
  final bool? isAvailable;
  final String? occupation;
  final List<FeaturedService>? services;

  FeaturedProvider({
    this.providerId,
    this.name,
    this.profileImage,
    this.address,
    this.distance,
    this.distanceKm,
    this.activityTime,
    this.rating,
    this.totalReviews,
    this.completedJobs,
    this.isAvailable,
    this.occupation,
    this.services,
  });

  factory FeaturedProvider.fromJson(Map<String, dynamic> json) {
    return FeaturedProvider(
      providerId: json['providerId'],
      name: json['name'],
      profileImage: json['profileImage'],
      address: json['address'],
      distance: json['distance'],
      distanceKm: json['distanceKm'],
      activityTime: json['activityTime'],
      rating: json['rating'],
      totalReviews: json['totalReviews'],
      completedJobs: json['completedJobs'],
      isAvailable: json['isAvailable'],
      occupation: json['occupation'],
      services: json['services'] != null
          ? (json['services'] as List).map((i) => FeaturedService.fromJson(i)).toList()
          : null,
    );
  }
}

class FeaturedService {
  final String? serviceId;
  final String? serviceName;
  final String? serviceDetail;
  final String? servicePhoto;
  final Category? category;
  final dynamic basePrice;
  final bool? appointmentEnabled;
  final List<dynamic>? appointmentSlots;
  final dynamic rating;
  final int? totalReviews;

  FeaturedService({
    this.serviceId,
    this.serviceName,
    this.serviceDetail,
    this.servicePhoto,
    this.category,
    this.basePrice,
    this.appointmentEnabled,
    this.appointmentSlots,
    this.rating,
    this.totalReviews,
  });

  factory FeaturedService.fromJson(Map<String, dynamic> json) {
    return FeaturedService(
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      serviceDetail: json['serviceDetail'],
      servicePhoto: json['servicePhoto'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      basePrice: json['basePrice'],
      appointmentEnabled: json['appointmentEnabled'],
      appointmentSlots: json['appointmentSlots'],
      rating: json['rating'],
      totalReviews: json['totalReviews'],
    );
  }
}

class Category {
  final String? id;
  final String? name;
  final String? icon;

  Category({this.id, this.name, this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

class UserLocation {
  final dynamic latitude;
  final dynamic longitude;

  UserLocation({this.latitude, this.longitude});

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
