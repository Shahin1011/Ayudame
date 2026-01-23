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
    // Determine the source of data (merged or nested)
    final Map<String, dynamic> data;
    if (json['businessProfile'] != null && json['businessProfile'] is Map) {
      data = json['businessProfile'];
    } else if (json['businessOwner'] != null && json['businessOwner'] is Map) {
      data = json['businessOwner'];
    } else {
      data = json;
    }

    // Capture User Info (might be root or nested)
    final userData = data['userId'] ?? data['user'] ?? data;

    // Helper to parse categories which might be a List of objects
    String? parseCategories(dynamic val) {
      if (val is List) {
        if (val.isEmpty) return null;
        if (val.first is Map && val.first['name'] != null) {
          return val.map((e) => e['name'].toString()).join(', ');
        }
        return val.join(', ');
      }
      return val?.toString();
    }

    // Helper to parse logo/photo
    String? parseLogo(dynamic val) {
      if (val is List) {
        final valid = val.where((e) => e != null).toList();
        if (valid.isNotEmpty) return valid.last.toString();
        return null;
      }
      return val?.toString();
    }

    return BusinessModel(
      id: data['id']?.toString() ?? data['_id']?.toString(),
      businessName:
          data['businessName']?.toString() ??
          data['business_name']?.toString() ??
          data['name']?.toString(),
      ownerName: userData is Map
          ? (userData['fullName'] ?? userData['name'])?.toString()
          : data['fullName']?.toString(),
      email: userData is Map
          ? userData['email']?.toString()
          : data['email']?.toString(),
      phone: userData is Map
          ? (userData['phoneNumber'] ?? userData['phone'])?.toString()
          : (data['phoneNumber'] ?? data['phone'])?.toString(),
      address: data['businessAddress'] != null && data['businessAddress'] is Map
          ? data['businessAddress']['fullAddress']?.toString()
          : (data['address']?.toString() ?? data['location']?.toString()),
      businessType: parseCategories(
        data['businessCategory'] ??
            data['categories'] ??
            data['businessType'] ??
            data['business_type'],
      ),
      description: data['description']?.toString() ?? data['about']?.toString(),
      logo: parseLogo(
        data['businessPhoto'] ??
            data['logo'] ??
            data['profilePicture'] ??
            data['profilePhoto'] ??
            data['photos'],
      ),
      coverPhoto:
          data['coverPhoto']?.toString() ??
          data['cover_photo']?.toString() ??
          data['b_cover']?.toString(),
      occupation: data['occupation']?.toString(),
      dateOfBirth: data['dateOfBirth']?.toString(),
      isVerified: data['isVerified'] ?? data['is_verified'] ?? false,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : (data['created_at'] != null
                ? DateTime.tryParse(data['created_at'].toString())
                : null),
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
