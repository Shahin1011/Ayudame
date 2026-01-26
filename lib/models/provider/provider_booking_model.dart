class ProviderBookingModel {
  bool? success;
  List<ProviderBooking>? data;

  ProviderBookingModel({this.success, this.data});

  ProviderBookingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProviderBooking>[];
      json['data'].forEach((v) {
        data!.add(ProviderBooking.fromJson(v));
      });
    }
  }
}

class ProviderBooking {
  String? id;
  String? bookingStatus;
  String? bookingDate;
  int? totalAmount;
  int? downPayment;
  String? userNotes;
  BookingUser? user;
  BookingServiceSnapshot? serviceSnapshot;

  ProviderBooking({
    this.id,
    this.bookingStatus,
    this.bookingDate,
    this.totalAmount,
    this.downPayment,
    this.userNotes,
    this.user,
    this.serviceSnapshot,
  });

  ProviderBooking.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    bookingStatus = json['bookingStatus'];
    bookingDate = json['bookingDate'];
    // Handle int/double safety
    totalAmount = json['totalAmount'];
    downPayment = json['downPayment'];
    userNotes = json['userNotes'];
    
    user = json['user'] != null ? BookingUser.fromJson(json['user']) : null;
    serviceSnapshot = json['serviceSnapshot'] != null ? BookingServiceSnapshot.fromJson(json['serviceSnapshot']) : null;
  }
}

class BookingUser {
  String? id;
  String? fullName;
  String? email;
  String? profilePicture;
  String? phoneNumber;
  String? address;

  BookingUser({this.id, this.fullName, this.email, this.profilePicture, this.phoneNumber, this.address});

  BookingUser.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    fullName = json['fullName'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
  }
}

class BookingServiceSnapshot {
  String? serviceName;
  String? servicePhoto;
  int? basePrice;

  BookingServiceSnapshot({this.serviceName, this.servicePhoto, this.basePrice});

  BookingServiceSnapshot.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
    servicePhoto = json['servicePhoto'];
    basePrice = json['basePrice'];
  }
}
