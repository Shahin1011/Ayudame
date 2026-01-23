class ServiceDetailsResponse {
  final bool? success;
  final ServiceDetailsData? data;

  ServiceDetailsResponse({this.success, this.data});

  factory ServiceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsResponse(
      success: json['success'],
      data: json['data'] != null ? ServiceDetailsData.fromJson(json['data']) : null,
    );
  }
}

class ServiceDetailsData {
  final ServiceProvider? provider;
  final ServiceDetails? service;

  ServiceDetailsData({this.provider, this.service});

  factory ServiceDetailsData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? providerMap = json['provider'] != null ? Map<String, dynamic>.from(json['provider']) : null;
    
    // If providerId is in the parent but missing in the provider map
    if (providerMap != null && !(providerMap.containsKey('id') || providerMap.containsKey('providerId') || providerMap.containsKey('_id'))) {
      if (json.containsKey('providerId')) {
        providerMap['providerId'] = json['providerId'];
      } else if (json.containsKey('id')) {
        providerMap['id'] = json['id'];
      } else if (json.containsKey('_id')) {
        providerMap['_id'] = json['_id'];
      }
    }

    return ServiceDetailsData(
      provider: providerMap != null ? ServiceProvider.fromJson(providerMap) : null,
      service: json['service'] != null ? ServiceDetails.fromJson(json['service']) : null,
    );
  }
}

class ServiceProvider {
  final String? id;
  final String? name;
  final String? image;
  final String? address;

  ServiceProvider({this.id, this.name, this.image, this.address});

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['providerId']?.toString() ?? json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name'],
      image: json['image'],
      address: json['address'],
    );
  }
}

class ServiceDetails {
  final String? serviceId;
  final String? image;
  final String? title;
  final String? about;
  final WhyChooseUs? whyChooseUs;
  final bool? appointmentEnabled;
  final num? basePrice;
  final List<AppointmentSlot>? appointmentSlots;
  final List<TopReview>? topReviews;
  final String? providerId;

  ServiceDetails({
    this.serviceId,
    this.image,
    this.title,
    this.about,
    this.whyChooseUs,
    this.appointmentEnabled,
    this.basePrice,
    this.appointmentSlots,
    this.topReviews,
    this.providerId,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      serviceId: json['serviceId'],
      image: json['image'],
      title: json['title'],
      about: json['about'],
      whyChooseUs: json['whyChooseUs'] != null ? WhyChooseUs.fromJson(json['whyChooseUs']) : null,
      appointmentEnabled: json['appointmentEnabled'],
      basePrice: json['basePrice'],
      appointmentSlots: json['appointmentSlots'] != null
          ? (json['appointmentSlots'] as List).map((i) => AppointmentSlot.fromJson(i)).toList()
          : null,
      topReviews: json['topReviews'] != null
          ? (json['topReviews'] as List).map((i) => TopReview.fromJson(i)).toList()
          : null,
      providerId: json['providerId']?.toString() ?? json['id']?.toString() ?? json['_id']?.toString(),
    );
  }
}

class WhyChooseUs {
  final String? twentyFourSeven;
  final String? efficientAndFast;
  final String? affordablePrices;
  final String? expertTeam;

  WhyChooseUs({
    this.twentyFourSeven,
    this.efficientAndFast,
    this.affordablePrices,
    this.expertTeam,
  });

  factory WhyChooseUs.fromJson(Map<String, dynamic> json) {
    return WhyChooseUs(
      twentyFourSeven: json['twentyFourSeven'],
      efficientAndFast: json['efficientAndFast'],
      affordablePrices: json['affordablePrices'],
      expertTeam: json['expertTeam'],
    );
  }
}

class AppointmentSlot {
  final int? duration;
  final String? durationUnit;
  final num? price;

  AppointmentSlot({this.duration, this.durationUnit, this.price});

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      duration: json['duration'],
      durationUnit: json['durationUnit'],
      price: json['price'],
    );
  }
}

class TopReview {
  final String? reviewId;
  final num? rating;
  final String? comment;
  final String? createdAt;
  final ReviewUser? user;

  TopReview({this.reviewId, this.rating, this.comment, this.createdAt, this.user});

  factory TopReview.fromJson(Map<String, dynamic> json) {
    return TopReview(
      reviewId: json['reviewId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      user: json['user'] != null ? ReviewUser.fromJson(json['user']) : null,
    );
  }
}

class ReviewUser {
  final String? name;
  final String? image;

  ReviewUser({this.name, this.image});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      name: json['name'],
      image: json['image'],
    );
  }
}
