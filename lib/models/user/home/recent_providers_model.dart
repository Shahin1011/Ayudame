class RecentProviderResponse {
  final bool success;
  final String message;
  final RecentProviderData data;

  RecentProviderResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RecentProviderResponse.fromJson(Map<String, dynamic> json) {
    return RecentProviderResponse(
      success: json['success'],
      message: json['message'],
      data: RecentProviderData.fromJson(json['data']),
    );
  }
}

class RecentProviderData {
  final List<ProviderModel> providers;
  final int count;

  RecentProviderData({
    required this.providers,
    required this.count,
  });

  factory RecentProviderData.fromJson(Map<String, dynamic> json) {
    return RecentProviderData(
      providers: List<ProviderModel>.from(
        json['providers'].map((x) => ProviderModel.fromJson(x)),
      ),
      count: json['count'],
    );
  }
}

class ProviderModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profilePicture;
  final LocationModel location;
  final List<CategoryModel> categories;
  final double rating;
  final int totalReviews;
  final bool isAvailable;
  final int completedJobs;
  final String occupation;
  final String activityTime;
  final LastServiceModel lastService;
  final DateTime joinedAt;

  ProviderModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.location,
    required this.categories,
    required this.rating,
    required this.totalReviews,
    required this.isAvailable,
    required this.completedJobs,
    required this.occupation,
    required this.activityTime,
    required this.lastService,
    required this.joinedAt,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      location: LocationModel.fromJson(json['location']),
      categories: List<CategoryModel>.from(
        json['categories'].map((x) => CategoryModel.fromJson(x)),
      ),
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      isAvailable: json['isAvailable'],
      completedJobs: json['completedJobs'],
      occupation: json['occupation'],
      activityTime: json['activityTime'],
      lastService: LastServiceModel.fromJson(json['lastService']),
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}

class LocationModel {
  final double latitude;
  final double longitude;
  final String address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'],
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

class LastServiceModel {
  final DateTime date;
  final String type;
  final String status;
  final ServiceModel service;

  LastServiceModel({
    required this.date,
    required this.type,
    required this.status,
    required this.service,
  });

  factory LastServiceModel.fromJson(Map<String, dynamic> json) {
    return LastServiceModel(
      date: DateTime.parse(json['date']),
      type: json['type'],
      status: json['status'],
      service: ServiceModel.fromJson(json['service']),
    );
  }
}

class ServiceModel {
  final String id;
  final String name;
  final String photo;
  final String category;
  final double basePrice;
  final String description;

  ServiceModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.category,
    required this.basePrice,
    required this.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      category: json['category'],
      basePrice: (json['basePrice'] as num).toDouble(),
      description: json['description'],
    );
  }
}
