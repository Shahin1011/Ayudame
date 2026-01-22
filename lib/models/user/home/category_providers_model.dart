class CategoryProvidersResponse {
  final bool? success;
  final String? message;
  final CategoryProvidersData? data;

  CategoryProvidersResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CategoryProvidersResponse.fromJson(Map<String, dynamic> json) {
    return CategoryProvidersResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? CategoryProvidersData.fromJson(json['data'])
          : null,
    );
  }
}

class CategoryProvidersData {
  final List<CategoryProvider>? providers;
  final int? totalProviders;
  final CategorySearchRadius? searchRadius;

  CategoryProvidersData({
    this.providers,
    this.totalProviders,
    this.searchRadius,
  });

  factory CategoryProvidersData.fromJson(Map<String, dynamic> json) {
    return CategoryProvidersData(
      providers: json['providers'] != null
          ? (json['providers'] as List)
              .map((i) => CategoryProvider.fromJson(i))
              .toList()
          : null,
      totalProviders: json['totalProviders'],
      searchRadius: json['searchRadius'] != null
          ? CategorySearchRadius.fromJson(json['searchRadius'])
          : null,
    );
  }
}

class CategorySearchRadius {
  final int? meters;
  final String? kilometers;

  CategorySearchRadius({this.meters, this.kilometers});

  factory CategorySearchRadius.fromJson(Map<String, dynamic> json) {
    return CategorySearchRadius(
      meters: json['meters'],
      kilometers: json['kilometers'],
    );
  }
}

class CategoryProvider {
  final String? providerId;
  final String? name;
  final String? profileImage;
  final String? address;
  final num? distance;
  final String? distanceKm;
  final List<ProviderService>? services;

  CategoryProvider({
    this.providerId,
    this.name,
    this.profileImage,
    this.address,
    this.distance,
    this.distanceKm,
    this.services,
  });

  factory CategoryProvider.fromJson(Map<String, dynamic> json) {
    return CategoryProvider(
      providerId: json['providerId'],
      name: json['name'],
      profileImage: json['profileImage'],
      address: json['address'],
      distance: json['distance'],
      distanceKm: json['distanceKm'],
      services: json['services'] != null
          ? (json['services'] as List)
              .map((i) => ProviderService.fromJson(i))
              .toList()
          : null,
    );
  }
}

class ProviderService {
  final String? serviceId;
  final String? title;
  final String? description;
  final num? rating;
  final int? totalReviews;
  final num? price;
  final String? image;
  final bool? appointmentEnabled;

  ProviderService({
    this.serviceId,
    this.title,
    this.description,
    this.rating,
    this.totalReviews,
    this.price,
    this.image,
    this.appointmentEnabled,
  });

  factory ProviderService.fromJson(Map<String, dynamic> json) {
    return ProviderService(
      serviceId: json['serviceId'],
      title: json['title'],
      description: json['description'],
      rating: json['rating'],
      totalReviews: json['totalReviews'],
      price: json['price'],
      image: json['image'],
      appointmentEnabled: json['appointmentEnabled'],
    );
  }
}
