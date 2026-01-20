class EventDetailsResponse {
  final bool success;
  final EventData data;

  EventDetailsResponse({
    required this.success,
    required this.data,
  });

  factory EventDetailsResponse.fromJson(Map<String, dynamic> json) {
    return EventDetailsResponse(
      success: json['success'],
      data: EventData.fromJson(json['data']),
    );
  }
}

class EventData {
  final EventModel event;

  EventData({required this.event});

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      event: EventModel.fromJson(json['event']),
    );
  }
}

class EventModel {
  final String eventId;
  final String eventName;
  final String eventImage;
  final String eventType;
  final String eventDescription;
  final String eventLocation;
  final String eventManagerName;
  final DateTime eventStartDateTime;
  final DateTime eventEndDateTime;
  final int ticketPrice;
  final int ticketsAvailable;
  final int ticketsSold;
  final int maximumNumberOfTickets;
  final bool isAvailableForPurchase;
  final bool isSoldOut;
  final String formattedDate;
  final String formattedTime;

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.eventImage,
    required this.eventType,
    required this.eventDescription,
    required this.eventLocation,
    required this.eventManagerName,
    required this.eventStartDateTime,
    required this.eventEndDateTime,
    required this.ticketPrice,
    required this.ticketsAvailable,
    required this.ticketsSold,
    required this.maximumNumberOfTickets,
    required this.isAvailableForPurchase,
    required this.isSoldOut,
    required this.formattedDate,
    required this.formattedTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'],
      eventName: json['eventName'],
      eventImage: json['eventImage'],
      eventType: json['eventType'],
      eventDescription: json['eventDescription'],
      eventLocation: json['eventLocation'],
      eventManagerName: json['eventManagerName'],
      eventStartDateTime: DateTime.parse(json['eventStartDateTime']),
      eventEndDateTime: DateTime.parse(json['eventEndDateTime']),
      ticketPrice: json['ticketPrice'],
      ticketsAvailable: json['ticketsAvailable'],
      ticketsSold: json['ticketsSold'],
      maximumNumberOfTickets: json['maximumNumberOfTickets'],
      isAvailableForPurchase: json['isAvailableForPurchase'],
      isSoldOut: json['isSoldOut'],
      formattedDate: json['formattedDate'],
      formattedTime: json['formattedTime'],
    );
  }
}
