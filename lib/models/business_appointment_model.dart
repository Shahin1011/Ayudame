import 'package:middle_ware/services/api_service.dart';

class BusinessAppointmentModel {
  final String? id;
  final String? customerName;
  final String? customerProfilePhoto;
  final String? address;
  final String? date;
  final String? time;
  final String? problemNote;
  final double? totalPrice;
  final double? downPayment;
  final String? status;
  final String? serviceName;

  BusinessAppointmentModel({
    this.id,
    this.customerName,
    this.customerProfilePhoto,
    this.address,
    this.date,
    this.time,
    this.problemNote,
    this.totalPrice,
    this.downPayment,
    this.status,
    this.serviceName,
  });

  factory BusinessAppointmentModel.fromJson(Map<String, dynamic> json) {
    String formatUrl(String? url) {
      if (url == null || url.isEmpty) return '';
      if (url.startsWith('http')) return url;
      return '${ApiService.baseURL}${url.startsWith('/') ? '' : '/'}$url';
    }

    final user = json['user'] ?? json['userId'];
    final serviceSnapshot = json['serviceSnapshot'];
    final timeSlot = json['timeSlot'];
    final service = json['service'] ?? json['serviceId'];

    // Handle date and time from appointmentDate (ISO string)
    String? dateString;
    String? timeString;
    if (json['appointmentDate'] != null) {
      try {
        DateTime dt = DateTime.parse(json['appointmentDate']);
        dateString = "${dt.day} ${_getMonth(dt.month)}, ${dt.year}";
      } catch (e) {
        dateString = json['appointmentDate'];
      }
    }

    // Handle time from timeSlot
    if (timeSlot is Map) {
      timeString = timeSlot['startTime'];
      if (timeSlot['endTime'] != null) {
        timeString = "$timeString - ${timeSlot['endTime']}";
      }
    }

    return BusinessAppointmentModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      customerName: user is Map ? (user['fullName'] ?? user['name']) : null,
      customerProfilePhoto: user is Map
          ? formatUrl(user['profilePicture'] ?? user['profilePhoto'])
          : null,
      address: json['address'] ?? json['location'] ?? 'No address provided',
      date: dateString,
      time: timeString ?? json['time'],
      problemNote:
          json['userNotes'] ??
          json['note'] ??
          json['problemNote'] ??
          'No problem note provided.',
      totalPrice: json['totalAmount'] != null
          ? double.tryParse(json['totalAmount'].toString())
          : (json['totalPrice'] != null
                ? double.tryParse(json['totalPrice'].toString())
                : null),
      downPayment: json['downPayment'] != null
          ? double.tryParse(json['downPayment'].toString())
          : null,
      status: json['appointmentStatus'] ?? json['status'],
      serviceName: serviceSnapshot is Map
          ? serviceSnapshot['serviceName']
          : (service is Map ? (service['headline'] ?? service['name']) : null),
    );
  }

  static String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
