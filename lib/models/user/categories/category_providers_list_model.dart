class CategoryProvidersResponse {
  final bool? success;
  final String? message;
  final CategoryProvidersData? data;

  CategoryProvidersResponse({this.success, this.message, this.data});

  factory CategoryProvidersResponse.fromJson(Map<String, dynamic> json) {
    return CategoryProvidersResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? CategoryProvidersData.fromJson(json['data']) : null,
    );
  }
}

class CategoryProvidersData {
  final List<CategoryProvider>? providers;
  final int? totalProviders;

  CategoryProvidersData({this.providers, this.totalProviders});

  factory CategoryProvidersData.fromJson(Map<String, dynamic> json) {
    return CategoryProvidersData(
      providers: json['providers'] != null
          ? (json['providers'] as List).map((i) => CategoryProvider.fromJson(i)).toList()
          : null,
      totalProviders: json['totalProviders'],
    );
  }
}

class CategoryProvider {
  final String? providerId;
  final String? name;
  final String? profileImage;
  final String? address;
  final List<CategoryProviderService>? services;

  CategoryProvider({this.providerId, this.name, this.profileImage, this.address, this.services});

  factory CategoryProvider.fromJson(Map<String, dynamic> json) {
    return CategoryProvider(
      providerId: json['providerId'],
      name: json['name'],
      profileImage: json['profileImage'],
      address: json['address'],
      services: json['services'] != null
          ? (json['services'] as List).map((i) => CategoryProviderService.fromJson(i)).toList()
          : null,
    );
  }
}

class CategoryProviderService {
  final String? serviceId;
  final String? title;
  final String? description;
  final dynamic rating;
  final int? totalReviews;
  final dynamic price;
  final String? image;
  final bool? appointmentEnabled;

  CategoryProviderService({
    this.serviceId,
    this.title,
    this.description,
    this.rating,
    this.totalReviews,
    this.price,
    this.image,
    this.appointmentEnabled,
  });

  factory CategoryProviderService.fromJson(Map<String, dynamic> json) {
    return CategoryProviderService(
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
