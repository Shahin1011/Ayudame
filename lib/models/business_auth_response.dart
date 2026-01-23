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
    Map<String, dynamic> mergedData = {};

    // 1. If 'user' exists, add its data (usually contains ID, name, email)
    if (json['user'] != null && json['user'] is Map) {
      mergedData.addAll(json['user'] as Map<String, dynamic>);
    }

    // 2. If 'businessOwner' or 'business' exists, merge it (contains business-specific info)
    final businessObj =
        json['businessOwner'] ?? json['business'] ?? json['owner'];
    if (businessObj != null && businessObj is Map) {
      mergedData.addAll(businessObj as Map<String, dynamic>);
      // Ensure we keep the user object if it was nested inside businessOwner (for 'me' endpoint compatibility)
      if (businessObj['user'] != null) mergedData['user'] = businessObj['user'];
      if (businessObj['userId'] != null)
        mergedData['userId'] = businessObj['userId'];
    }

    // 3. If nothing was found yet, use the root json
    if (mergedData.isEmpty) {
      mergedData = json;
    }

    return BusinessAuthData(
      token:
          json['token']?.toString() ??
          json['accessToken']?.toString() ??
          json['access_token']?.toString() ??
          '',
      business: BusinessModel.fromJson(mergedData),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'business': business.toJson()};
  }
}
