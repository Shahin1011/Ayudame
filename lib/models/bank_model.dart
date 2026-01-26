class BankInfoModel {
  final String? id;
  final String accountHolderName;
  final String bankName;
  final String accountNumber;
  final String routingNumber;
  final String accountHolderType;

  BankInfoModel({
    this.id,
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.routingNumber,
    required this.accountHolderType,
  });

  factory BankInfoModel.fromJson(Map<String, dynamic> json) {
    return BankInfoModel(
      id: json['_id'] ?? json['id'],
      accountHolderName: json['accountHolderName'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      routingNumber: json['routingNumber'] ?? '',
      accountHolderType: json['accountHolderType'] ?? 'personal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'routingNumber': routingNumber,
      'accountHolderType': accountHolderType,
    };
  }
}
