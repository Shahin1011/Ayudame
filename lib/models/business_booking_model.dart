import 'package:flutter/foundation.dart';
import 'package:middle_ware/services/api_service.dart';

class BusinessBookingModel {
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

  BusinessBookingModel({
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

  factory BusinessBookingModel.fromJson(Map<String, dynamic> json) {
    debugPrint('🔍 Parsing Booking JSON. ID: ${json['_id'] ?? json['id']}');
    // Helper to format URLs
    String formatUrl(String? url) {
      if (url == null || url.isEmpty) return '';
      if (url.startsWith('http')) return url;
      return '${ApiService.baseURL}${url.startsWith('/') ? '' : '/'}$url';
    }

    final user = json['user'] ?? json['userId'];
    final serviceSnapshot = json['serviceSnapshot'];
    final service = json['service'] ?? json['serviceId'];

    // Handle date and time from bookingDate (ISO string)
    String? dateString;
    String? timeString;
    if (json['bookingDate'] != null) {
      try {
        DateTime dt = DateTime.parse(json['bookingDate']);
        dateString = "${dt.day} ${_getMonth(dt.month)}, ${dt.year}";
        timeString =
            "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'pm' : 'am'}";
      } catch (e) {
        dateString = json['bookingDate'];
      }
    }

    return BusinessBookingModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      customerName: user is Map ? (user['fullName'] ?? user['name']) : null,
      customerProfilePhoto: user is Map
          ? formatUrl(
              user['profilePicture'] ??
                  user['profilePhoto'] ??
                  user['profile_photo'],
            )
          : null,
      address: json['address'] ?? json['location'] ?? 'No address provided',
      date: dateString ?? json['date'],
      time: timeString ?? json['time'],
      problemNote: json['userNotes'] ?? json['note'] ?? 'No notes available.',
      totalPrice: json['totalAmount'] != null
          ? double.tryParse(json['totalAmount'].toString())
          : (json['totalPrice'] != null
                ? double.tryParse(json['totalPrice'].toString())
                : null),
      downPayment: json['downPayment'] != null
          ? double.tryParse(json['downPayment'].toString())
          : null,
      status: json['bookingStatus'] ?? json['status'],
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerProfilePhoto': customerProfilePhoto,
      'address': address,
      'date': date,
      'time': time,
      'problemNote': problemNote,
      'totalPrice': totalPrice,
      'downPayment': downPayment,
      'status': status,
      'serviceName': serviceName,
    };
  }
}
