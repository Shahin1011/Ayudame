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
    // Check if user details are nested inside 'userId' object (common in populated responses)
    final userMap = json['userId'] is Map<String, dynamic>
        ? json['userId']
        : json;

    return EventManagerModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      fullName:
          userMap['fullName']?.toString() ??
          json['name']?.toString() ??
          userMap['name']?.toString(),
      email: userMap['email']?.toString(),
      phoneNumber:
          userMap['phoneNumber']?.toString() ??
          json['phone']?.toString() ??
          userMap['phone']?.toString(),
      dateOfBirth:
          json['dateOfBirth']?.toString() ?? json['birthdate']?.toString(),
      idType: json['idType']?.toString() ?? json['IdType']?.toString(),
      identificationNumber: json['identificationNumber']?.toString(),
      idCardFront:
          json['idCard']?['frontImage']?.toString() ??
          json['idCardFront']?.toString(),
      idCardBack:
          json['idCard']?['backImage']?.toString() ??
          json['idCardBack']?.toString(),
      userType: userMap['userType']?.toString() ?? json['userType']?.toString(),
      profilePicture:
          userMap['profilePicture']?.toString() ??
          json['profilePicture']?.toString(),
      category: json['category']?.toString() ?? json['Category']?.toString(),
      address:
          json['address']?.toString() ??
          json['Address']?.toString() ??
          json['businessAddress']?.toString(),
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
