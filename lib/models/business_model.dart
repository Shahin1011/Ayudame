/// Business User Model
class BusinessModel {
  final String? id;
  final String? businessName;
  final String? ownerName;
  final String? email;
  final String? phone;
  final String? address;
  final String? businessType;
  final String? description;
  final String? logo; // Business Profile Photo / Logo
  final String? coverPhoto;
  final String? occupation;
  final String? dateOfBirth;
  final bool? isVerified;
  final DateTime? createdAt;

  BusinessModel({
    this.id,
    this.businessName,
    this.ownerName,
    this.email,
    this.phone,
    this.address,
    this.businessType,
    this.description,
    this.logo,
    this.coverPhoto,
    this.occupation,
    this.dateOfBirth,
    this.isVerified,
    this.createdAt,
  });

  /// Create BusinessModel from JSON
  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    // Check if data is nested under 'businessOwner' or just top-level
    final data = json['businessOwner'] != null ? json['businessOwner'] : json;
    final userData = data['userId'];

    return BusinessModel(
      id: data['id']?.toString() ?? data['_id']?.toString(),
      businessName:
          data['business_name']?.toString() ??
          data['businessName']?.toString() ??
          data['name']?.toString(),
      // Extract from userId object if available
      ownerName: userData != null
          ? userData['fullName']?.toString()
          : (data['owner_name']?.toString() ??
                data['ownerName']?.toString() ??
                data['fullName']?.toString() ??
                data['full_name']?.toString()),
      email: userData != null
          ? userData['email']?.toString()
          : data['email']?.toString(),
      phone: userData != null
          ? userData['phoneNumber']?.toString()
          : (data['phone']?.toString() ?? data['phoneNumber']?.toString()),
      // Map other fields
      address:
          data['address']?.toString() ??
          data['businessAddress']?['fullAddress']?.toString() ??
          data['businessAddress']?.toString() ??
          data['location']?.toString(),
      businessType:
          data['business_type']?.toString() ??
          data['businessType']?.toString() ??
          data['businessCategory']?.toString() ??
          data['categories']?.toString(),
      description: data['description']?.toString() ?? data['about']?.toString(),
      // Check userData for profile picture first, then business photo
      logo: userData != null
          ? userData['profilePicture']?.toString()
          : (data['logo']?.toString() ??
                data['profilePicture']?.toString() ??
                data['business_photo']?.toString() ??
                data['businessPhotos']?.toString() ??
                data['businessPhoto']?.toString()),
      coverPhoto:
          data['cover_photo']?.toString() ??
          data['coverPhoto']?.toString() ??
          data['businessProfile']?['coverPhoto']?.toString() ??
          data['b_cover']?.toString(),
      occupation: data['occupation']?.toString(),
      dateOfBirth: data['dateOfBirth']?.toString(),
      isVerified: data['is_verified'] ?? data['isVerified'] ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : null,
    );
  }

  /// Convert BusinessModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': businessName,
      'owner_name': ownerName,
      'email': email,
      'phone': phone,
      'address': address,
      'business_type': businessType,
      'description': description,
      'logo': logo,
      'cover_photo': coverPhoto,
      'occupation': occupation,
      'dateOfBirth': dateOfBirth,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Create a copy of BusinessModel with updated fields
  BusinessModel copyWith({
    String? id,
    String? businessName,
    String? ownerName,
    String? email,
    String? phone,
    String? address,
    String? businessType,
    String? description,
    String? logo,
    String? coverPhoto,
    String? occupation,
    String? dateOfBirth,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      businessType: businessType ?? this.businessType,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      occupation: occupation ?? this.occupation,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'BusinessModel(id: $id, businessName: $businessName, email: $email)';
  }
}
