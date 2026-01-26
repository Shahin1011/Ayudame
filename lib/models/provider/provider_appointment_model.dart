class ProviderAppointmentModel {
  bool? success;
  List<ProviderAppointment>? data;

  ProviderAppointmentModel({this.success, this.data});

  ProviderAppointmentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProviderAppointment>[];
      json['data'].forEach((v) {
        data!.add(ProviderAppointment.fromJson(v));
      });
    }
  }
}

class ProviderAppointment {
  String? id;
  String? appointmentStatus;
  String? appointmentDate;
  int? totalAmount;
  int? downPayment;
  String? userNotes;
  AppointmentUser? user;
  AppointmentServiceSnapshot? serviceSnapshot;
  AppointmentSelectedSlot? selectedSlot;
  AppointmentTimeSlot? timeSlot;

  ProviderAppointment({
    this.id,
    this.appointmentStatus,
    this.appointmentDate,
    this.totalAmount,
    this.downPayment,
    this.userNotes,
    this.user,
    this.serviceSnapshot,
    this.selectedSlot,
    this.timeSlot,
  });

  ProviderAppointment.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    appointmentStatus = json['appointmentStatus'];
    appointmentDate = json['appointmentDate'];
    // Handle number types safely
    totalAmount = json['totalAmount'];
    downPayment = json['downPayment'];
    userNotes = json['userNotes'];
    
    user = json['user'] != null ? AppointmentUser.fromJson(json['user']) : null;
    serviceSnapshot = json['serviceSnapshot'] != null ? AppointmentServiceSnapshot.fromJson(json['serviceSnapshot']) : null;
    selectedSlot = json['selectedSlot'] != null ? AppointmentSelectedSlot.fromJson(json['selectedSlot']) : null;
    timeSlot = json['timeSlot'] != null ? AppointmentTimeSlot.fromJson(json['timeSlot']) : null;
  }
}

class AppointmentUser {
  String? id;
  String? fullName;
  String? email;
  String? profilePicture;
  String? phoneNumber;

  AppointmentUser({this.id, this.fullName, this.email, this.profilePicture, this.phoneNumber});

  AppointmentUser.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    fullName = json['fullName'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    phoneNumber = json['phoneNumber'];
  }
}

class AppointmentServiceSnapshot {
  String? serviceName;
  String? servicePhoto;
  String? headline;
  String? category;

  AppointmentServiceSnapshot({this.serviceName, this.servicePhoto, this.headline, this.category});

  AppointmentServiceSnapshot.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
    servicePhoto = json['servicePhoto'];
    headline = json['headline'];
    category = json['category'];
  }
}

class AppointmentSelectedSlot {
  int? duration;
  String? durationUnit;
  int? price;

  AppointmentSelectedSlot({this.duration, this.durationUnit, this.price});

  AppointmentSelectedSlot.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    durationUnit = json['durationUnit'];
    price = json['price'];
  }
}

class AppointmentTimeSlot {
  String? startTime;
  String? endTime;

  AppointmentTimeSlot({this.startTime, this.endTime});

  AppointmentTimeSlot.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
  }
}
