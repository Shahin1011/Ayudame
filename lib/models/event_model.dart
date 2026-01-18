class EventModel {
  String? id;
  String? eventName;
  String? eventType;
  String? eventManagerName;
  String? eventLocation;
  String? ticketSalesStartDate;
  String? ticketSalesEndDate;
  String? eventStartDateTime;
  String? eventEndDateTime;
  double? ticketPrice;
  int? maximumNumberOfTickets;
  String? confirmationCodePrefix;
  String? eventDescription;
  String? eventImage; // File path or URL
  String? status; // 'draft', 'published', 'cancelled'
  int? soldTickets;
  double? revenue;

  EventModel({
    this.id,
    this.eventName,
    this.eventType,
    this.eventManagerName,
    this.eventLocation,
    this.ticketSalesStartDate,
    this.ticketSalesEndDate,
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.ticketPrice,
    this.maximumNumberOfTickets,
    this.confirmationCodePrefix,
    this.eventDescription,
    this.eventImage,
    this.status,
    this.soldTickets,
    this.revenue,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      eventName: json['eventName'],
      eventType: json['eventType'],
      eventManagerName: json['eventManagerName'],
      eventLocation: json['eventLocation'],
      ticketSalesStartDate: json['ticketSalesStartDate'],
      ticketSalesEndDate: json['ticketSalesEndDate'],
      eventStartDateTime: json['eventStartDateTime'],
      eventEndDateTime: json['eventEndDateTime'],
      ticketPrice: double.tryParse(json['ticketPrice']?.toString() ?? '0'),
      maximumNumberOfTickets: int.tryParse(
        json['maximumNumberOfTickets']?.toString() ?? '0',
      ),
      confirmationCodePrefix: json['confirmationCodePrefix'],
      eventDescription: json['eventDescription'],
      eventImage: json['eventImage'] ?? json['eventFlier'],
      status: json['status'],
      soldTickets: int.tryParse(json['soldTickets']?.toString() ?? '0'),
      revenue: double.tryParse(json['revenue']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'eventType': eventType,
      'eventManagerName': eventManagerName,
      'eventLocation': eventLocation,
      'ticketSalesStartDate': ticketSalesStartDate,
      'ticketSalesEndDate': ticketSalesEndDate,
      'eventStartDateTime': eventStartDateTime,
      'eventEndDateTime': eventEndDateTime,
      'ticketPrice': ticketPrice?.toString(),
      'maximumNumberOfTickets': maximumNumberOfTickets?.toString(),
      'confirmationCodePrefix': confirmationCodePrefix,
      'eventDescription': eventDescription,
    };
  }

  Map<String, String> toApiFields() {
    return {
      'eventName': eventName ?? '',
      'eventType': eventType ?? '',
      'eventManagerName': eventManagerName ?? '',
      'eventLocation': eventLocation ?? '',
      'ticketSalesStartDate': ticketSalesStartDate ?? '',
      'ticketSalesEndDate': ticketSalesEndDate ?? '',
      'eventStartDateTime': eventStartDateTime ?? '',
      'eventEndDateTime': eventEndDateTime ?? '',
      'ticketPrice': ticketPrice?.toString() ?? '0',
      'maximumNumberOfTickets': maximumNumberOfTickets?.toString() ?? '0',
      'confirmationCodePrefix': confirmationCodePrefix ?? '',
      'eventDescription': eventDescription ?? '',
    };
  }
}
