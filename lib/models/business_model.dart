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
  final String? logo;
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
    this.isVerified,
    this.createdAt,
  });

  /// Create BusinessModel from JSON
  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      businessName:
          json['business_name']?.toString() ?? json['businessName']?.toString(),
      ownerName:
          json['owner_name']?.toString() ?? json['ownerName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      businessType:
          json['business_type']?.toString() ?? json['businessType']?.toString(),
      description: json['description']?.toString(),
      logo: json['logo']?.toString(),
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
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
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'BusinessModel(id: $id, businessName: $businessName, email: $email)';
  }
}
