class BankInformation {
  final String accountHolderName;
  final String bankName;
  final String accountNumber;
  final String routingNumber;
  final String accountHolderType;

  BankInformation({
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.routingNumber,
    required this.accountHolderType,
  });

  factory BankInformation.fromJson(Map<String, dynamic> json) {
    return BankInformation(
      accountHolderName: json['accountHolderName'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      routingNumber: json['routingNumber'] ?? '',
      accountHolderType: json['accountHolderType'] ?? '',
    );
  }

  String get last4Digits =>
      accountNumber.length >= 4 ? accountNumber.substring(accountNumber.length - 4) : accountNumber;
}
