// class CardModel {
//   final String cardName;
//   final String cardNumber;
//   final String expiryDate;
//   final String cvv;
//   final String country;
//   final String street;
//   final String city;
//   final String postcode;
//   final bool isDefault;
//
//   CardModel({
//     required this.cardName,
//     required this.cardNumber,
//     required this.expiryDate,
//     required this.cvv,
//     required this.country,
//     required this.street,
//     required this.city,
//     required this.postcode,
//     this.isDefault = true,
//   });
//
//   String get last4Digits =>
//       cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : cardNumber;
// }
class CardModel {
  final String cardName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String country;
  final String street;
  final String city;
  final String postcode;
  final bool isDefault;

  CardModel({
    required this.cardName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.country,
    required this.street,
    required this.city,
    required this.postcode,
    this.isDefault = true,
  });

  String get last4Digits =>
      cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : cardNumber;
}