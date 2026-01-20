class EventModel {
  final String eventId;
  final String eventName;
  final String eventImage;
  final String eventType;
  final String eventLocation;
  final String formattedDate;
  final String formattedTime;
  final int ticketsSold;

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.eventImage,
    required this.eventType,
    required this.eventLocation,
    required this.formattedDate,
    required this.formattedTime,
    required this.ticketsSold,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'],
      eventName: json['eventName'],
      eventImage: json['eventImage'],
      eventType: json['eventType'],
      eventLocation: json['eventLocation'],
      formattedDate: json['formattedDate'],
      formattedTime: json['formattedTime'],
      ticketsSold: json['ticketsSold'],
    );
  }
}
