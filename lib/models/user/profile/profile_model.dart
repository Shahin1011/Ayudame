class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? profilePicture;
  final String userType;
  final bool isActive;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.profilePicture,
    required this.userType,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      fullName: json['fullName'].toString(),
      email: json['email'].toString(),
      profilePicture: json['profilePicture']?.toString(), // Fixed: handle null properly
      userType: json['userType'].toString(),
      isActive: json['isActive'] as bool,
    );
  }
}