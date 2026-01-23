class TopBusinessesResponse {
  final bool? success;
  final TopBusinessesData? data;

  TopBusinessesResponse({this.success, this.data});

  factory TopBusinessesResponse.fromJson(Map<String, dynamic> json) {
    return TopBusinessesResponse(
      success: json['success'],
      data: json['data'] != null ? TopBusinessesData.fromJson(json['data']) : null,
    );
  }
}

class TopBusinessesData {
  final List<TopBusiness>? businesses;
  final int? count;

  TopBusinessesData({this.businesses, this.count});

  factory TopBusinessesData.fromJson(Map<String, dynamic> json) {
    return TopBusinessesData(
      businesses: json['businesses'] != null
          ? (json['businesses'] as List).map((i) => TopBusiness.fromJson(i)).toList()
          : null,
      count: json['count'],
    );
  }
}

class TopBusiness {
  final String? businessOwnerId;
  final String? businessPhoto;
  final String? businessName;
  final num? businessRating;
  final String? businessAddress;
  final int? employeeCount;
  final int? serviceCount;
  final int? appointmentServiceCount;

  TopBusiness({
    this.businessOwnerId,
    this.businessPhoto,
    this.businessName,
    this.businessRating,
    this.businessAddress,
    this.employeeCount,
    this.serviceCount,
    this.appointmentServiceCount,
  });

  factory TopBusiness.fromJson(Map<String, dynamic> json) {
    return TopBusiness(
      businessOwnerId: json['businessOwnerId'],
      businessPhoto: json['businessPhoto'],
      businessName: json['businessName'],
      businessRating: json['businessRating'],
      businessAddress: json['businessAddress'],
      employeeCount: json['employeeCount'],
      serviceCount: json['serviceCount'],
      appointmentServiceCount: json['appointmentServiceCount'],
    );
  }
}
