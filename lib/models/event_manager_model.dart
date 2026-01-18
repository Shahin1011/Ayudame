import 'user_model.dart';

class EventManagerModel extends BaseModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? idType;
  final String? identificationNumber;
  final String? idCardFront;
  final String? idCardBack;
  final String? userType;
  final String? profilePicture;
  final String? category;
  final String? address;

  EventManagerModel({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.idType,
    this.identificationNumber,
    this.idCardFront,
    this.idCardBack,
    this.userType,
    this.profilePicture,
    this.category,
    this.address,
  });

  factory EventManagerModel.fromJson(Map<String, dynamic> json) {
    return EventManagerModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      fullName: json['fullName']?.toString() ?? json['name']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString() ?? json['phone']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      idType: json['idType']?.toString() ?? json['IdType']?.toString(),
      identificationNumber: json['identificationNumber']?.toString(),
      idCardFront: json['idCardFront']?.toString(),
      idCardBack: json['idCardBack']?.toString(),
      userType: json['userType']?.toString(),
      profilePicture: json['profilePicture']?.toString(),
      category: json['category']?.toString() ?? json['Category']?.toString(),
      address: json['address']?.toString() ?? json['Address']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'IdType': idType,
      'identificationNumber': identificationNumber,
      'idCardFront': idCardFront,
      'idCardBack': idCardBack,
      'userType': userType,
      'profilePicture': profilePicture,
      'category': category,
      'address': address,
    };
  }

  Map<String, String> toRegistrationFields() {
    return {
      'fullName': fullName ?? '',
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'dateOfBirth': dateOfBirth ?? '',
      'idType': idType ?? '',
      'identificationNumber': identificationNumber ?? '',
    };
  }
}
