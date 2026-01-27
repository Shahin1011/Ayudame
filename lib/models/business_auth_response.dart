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
  final String? refreshToken;
  final int? expiresIn;
  final BusinessModel business;

  BusinessAuthData({
    required this.token,
    this.refreshToken,
    this.expiresIn,
    required this.business,
  });

  factory BusinessAuthData.fromJson(Map<String, dynamic> json) {
    // Try to find business data in different possible locations
    Map<String, dynamic> mergedData = {};

    // 1. If 'user' exists, add its data (usually contains ID, name, email)
    if (json['user'] != null && json['user'] is Map) {
      mergedData.addAll(json['user'] as Map<String, dynamic>);
    }

    // 2. If 'businessOwner' exists, merge it
    // Note: In the new API, user contains common auth info, businessOwner contains business specifics
    final businessObj = json['businessOwner'] ?? json['business'] ?? json['owner'];
    if (businessObj != null && businessObj is Map) {
      // Store user ID separately if needed before overwriting with businessOwner ID
      if (mergedData['id'] != null) {
        mergedData['userId'] = mergedData['id'];
      }
      mergedData.addAll(businessObj as Map<String, dynamic>);
      
      // If businessOwner has a nested user object (like in profile updates)
      if (businessObj['user'] != null) mergedData['user'] = businessObj['user'];
    }

    // 3. If nothing was found yet, use the root json
    if (mergedData.isEmpty) {
      mergedData = json;
    }

    return BusinessAuthData(
      token:
          json['accessToken']?.toString() ??
          json['token']?.toString() ??
          json['access_token']?.toString() ??
          '',
      refreshToken: json['refreshToken']?.toString() ?? json['refresh_token']?.toString(),
      expiresIn: json['expiresIn'] is int ? json['expiresIn'] : int.tryParse(json['expiresIn']?.toString() ?? ''),
      business: BusinessModel.fromJson(mergedData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'business': business.toJson(),
    };
  }
}
