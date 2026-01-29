class TicketPurchaseRequest {
  final int quantity;
  final List<TicketOwner> ticketOwners;

  TicketPurchaseRequest({
    required this.quantity,
    required this.ticketOwners,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'ticketOwners': ticketOwners.map((e) => e.toJson()).toList(),
    };
  }
}

class TicketOwner {
  final String name;
  final String identificationType;
  final String identificationNumber;

  TicketOwner({
    required this.name,
    required this.identificationType,
    required this.identificationNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'identificationType': identificationType,
      'identificationNumber': identificationNumber,
    };
  }
}

class TicketPurchaseResponse {
  final bool success;
  final String message;
  final PurchaseData? data;

  TicketPurchaseResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory TicketPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return TicketPurchaseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PurchaseData.fromJson(json['data']) : null,
    );
  }
}

class PurchaseData {
  final String purchaseId;
  final CheckoutData checkout;

  PurchaseData({
    required this.purchaseId,
    required this.checkout,
  });

  factory PurchaseData.fromJson(Map<String, dynamic> json) {
    return PurchaseData(
      purchaseId: json['purchaseId'] ?? '',
      checkout: CheckoutData.fromJson(json['checkout'] ?? {}),
    );
  }
}

class CheckoutData {
  final String sessionUrl;

  CheckoutData({required this.sessionUrl});

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      sessionUrl: json['sessionUrl'] ?? '',
    );
  }
}
