class OrderResponse {
  final bool? success;
  final int? count;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final List<OrderModel>? data;

  OrderResponse({
    this.success,
    this.count,
    this.total,
    this.currentPage,
    this.totalPages,
    this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'],
      count: json['count'],
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => OrderModel.fromJson(i)).toList()
          : null,
    );
  }
}

class OrderModel {
  final String? id;
  final String? userId;
  final String? serviceId;
  final String? providerId;
  final String? bookingDate;
  final int? downPayment;
  final int? totalAmount;
  final int? remainingAmount;
  final String? paymentStatus;
  final String? bookingStatus;
  final String? userNotes;
  final ServiceSnapshot? serviceSnapshot;
  final ProviderDetails? provider;

  OrderModel({
    this.id,
    this.userId,
    this.serviceId,
    this.providerId,
    this.bookingDate,
    this.downPayment,
    this.totalAmount,
    this.remainingAmount,
    this.paymentStatus,
    this.bookingStatus,
    this.userNotes,
    this.serviceSnapshot,
    this.provider,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      userId: json['userId'],
      serviceId: json['serviceId'],
      providerId: json['providerId'],
      bookingDate: json['bookingDate'],
      downPayment: json['downPayment'],
      totalAmount: json['totalAmount'],
      remainingAmount: json['remainingAmount'],
      paymentStatus: json['paymentStatus'],
      bookingStatus: json['bookingStatus'],
      userNotes: json['userNotes'],
      serviceSnapshot: json['serviceSnapshot'] != null
          ? ServiceSnapshot.fromJson(json['serviceSnapshot'])
          : null,
      provider: json['provider'] != null
          ? ProviderDetails.fromJson(json['provider'])
          : null,
    );
  }
}

class ServiceSnapshot {
  final String? serviceName;
  final String? servicePhoto;
  final int? basePrice;

  ServiceSnapshot({
    this.serviceName,
    this.servicePhoto,
    this.basePrice,
  });

  factory ServiceSnapshot.fromJson(Map<String, dynamic> json) {
    return ServiceSnapshot(
      serviceName: json['serviceName'],
      servicePhoto: json['servicePhoto'],
      basePrice: json['basePrice'],
    );
  }
}

class ProviderDetails {
  final String? id;
  final String? occupation;
  final String? verificationStatus;
  final double? rating;
  final int? totalReviews;
  final UserProfile? user;

  ProviderDetails({
    this.id,
    this.occupation,
    this.verificationStatus,
    this.rating,
    this.totalReviews,
    this.user,
  });

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      id: json['_id'],
      occupation: json['occupation'],
      verificationStatus: json['verificationStatus'],
      rating: (json['rating'] as num?)?.toDouble(),
      totalReviews: json['totalReviews'],
      user: json['userId'] != null ? UserProfile.fromJson(json['userId']) : null,
    );
  }
}

class UserProfile {
  final String? id;
  final String? fullName;
  final String? profilePicture;

  UserProfile({
    this.id,
    this.fullName,
    this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'],
    );
  }
}
