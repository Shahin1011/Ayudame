import 'provider_profile_model.dart';

class EmployeeProfileResponse {
  final bool? success;
  final EmployeeProfileData? data;

  EmployeeProfileResponse({this.success, this.data});

  factory EmployeeProfileResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileResponse(
      success: json['success'],
      data: json['data'] != null ? EmployeeProfileData.fromJson(json['data']) : null,
    );
  }
}

class EmployeeProfileData {
  final ProviderInfo? provider; // Backend uses 'provider' key
  final AllServices? allServices;
  final List<ProviderReview>? reviews;
  final List<PortfolioItem>? portfolio;

  EmployeeProfileData({this.provider, this.allServices, this.reviews, this.portfolio});

  factory EmployeeProfileData.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileData(
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
