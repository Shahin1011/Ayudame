import 'business_model.dart';

/// Business Auth Response Model
class BusinessAuthResponse {
  final bool success;
  final String message;
  final BusinessAuthData? data;

  BusinessAuthResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BusinessAuthResponse.fromJson(Map<String, dynamic> json) {
    return BusinessAuthResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? BusinessAuthData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

/// Business Auth Data (contains token and business info)
class BusinessAuthData {
  final String token;
  final BusinessModel business;

  BusinessAuthData({required this.token, required this.business});

  factory BusinessAuthData.fromJson(Map<String, dynamic> json) {
    // Try to find business data in different possible locations
    Map<String, dynamic>? businessData;

    if (json['business'] != null) {
      businessData = json['business'] as Map<String, dynamic>;
    } else if (json['businessOwner'] != null) {
      businessData = json['businessOwner'] as Map<String, dynamic>;
    } else if (json['owner'] != null) {
      businessData = json['owner'] as Map<String, dynamic>;
    } else if (json['user'] != null) {
      businessData = json['user'] as Map<String, dynamic>;
    } else if (json['data'] != null && json['data'] is Map) {
      businessData = json['data'] as Map<String, dynamic>;
    } else {
      // If no nested object, use the json itself (might contain business fields directly)
      businessData = json;
    }

    return BusinessAuthData(
      token:
          json['token']?.toString() ??
          json['accessToken']?.toString() ??
          json['access_token']?.toString() ??
          '',
      business: BusinessModel.fromJson(businessData),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'business': business.toJson()};
  }
}
