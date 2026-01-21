class NearbyProvidersResponse {
  final bool? success;
  final String? message;
  final NearbyProvidersData? data;

  NearbyProvidersResponse({
    this.success,
    this.message,
    this.data,
  });

  factory NearbyProvidersResponse.fromJson(Map<String, dynamic> json) {
    return NearbyProvidersResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? NearbyProvidersData.fromJson(json['data'])
          : null,
    );
  }
}

class NearbyProvidersData {
  final List<CategoryWithProviders>? categories;
  final int? totalCategories;
  final int? totalProviders;
  final SearchRadius? searchRadius;

  NearbyProvidersData({
    this.categories,
    this.totalCategories,
    this.totalProviders,
    this.searchRadius,
  });

  factory NearbyProvidersData.fromJson(Map<String, dynamic> json) {
    return NearbyProvidersData(
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((i) => CategoryWithProviders.fromJson(i))
              .toList()
          : null,
      totalCategories: json['totalCategories'],
      totalProviders: json['totalProviders'],
      searchRadius: json['searchRadius'] != null
          ? SearchRadius.fromJson(json['searchRadius'])
          : null,
    );
  }
}

class SearchRadius {
  final int? meters;
  final String? kilometers;

  SearchRadius({
    this.meters,
    this.kilometers,
  });

  factory SearchRadius.fromJson(Map<String, dynamic> json) {
    return SearchRadius(
      meters: json['meters'],
      kilometers: json['kilometers'],
    );
  }
}


class CategoryWithProviders {
  final String? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final num? averageDistance;
  final String? averageDistanceKm;
  final int? providerCount;

  CategoryWithProviders({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.averageDistance,
    this.averageDistanceKm,
    this.providerCount,
  });

  factory CategoryWithProviders.fromJson(Map<String, dynamic> json) {
    return CategoryWithProviders(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      categoryImage: json['categoryImage'],
      averageDistance: json['averageDistance'],
      averageDistanceKm: json['averageDistanceKm'],
      providerCount: json['providerCount'],
    );
  }
}

class NearbyProvider {
  final String? providerId;
  final String? name;
  final String? profileImage;
  final String? address;
  final double? distance;
  final String? distanceKm;
  final String? activityTime;
  final double? rating;
  final int? totalReviews;
  final int? completedJobs;
  final String? occupation;

  NearbyProvider({
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
    this.occupation,
  });

  factory NearbyProvider.fromJson(Map<String, dynamic> json) {
    return NearbyProvider(
      providerId: json['providerId'],
      name: json['name'],
      profileImage: json['profileImage'],
      address: json['address'],
      distance: (json['distance'] as num?)?.toDouble(),
      distanceKm: json['distanceKm'],
      activityTime: json['activityTime'],
      rating: (json['rating'] as num?)?.toDouble(),
      totalReviews: json['totalReviews'],
      completedJobs: json['completedJobs'],
      occupation: json['occupation'],
    );
  }
}
