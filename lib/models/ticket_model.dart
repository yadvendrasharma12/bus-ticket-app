// class TicketModel {
//   String bookingId;
//   String bookingReference;
//   String source;
//   String destination;
//   String departureTime;
//   String arrivalTime;
//   String travelDuration;
//   String travelDate;
//   String travelDateTime;
//   int price;
//   String status;
//
//   TicketModel({
//     required this.bookingId,
//     required this.bookingReference,
//     required this.source,
//     required this.destination,
//     required this.departureTime,
//     required this.arrivalTime,
//     required this.travelDuration,
//     required this.travelDate,
//     required this.travelDateTime,
//     required this.price,
//     required this.status,
//   });
//
//   factory TicketModel.fromJson(Map<String, dynamic> json) {
//     return TicketModel(
//       bookingId: json['bookingId'],
//       bookingReference: json['bookingReference'],
//       source: json['source'],
//       destination: json['destination'],
//       departureTime: json['departureTime'],
//       arrivalTime: json['arrivalTime'],
//       travelDuration: json['travelDuration'],
//       travelDate: json['travelDate'],
//       travelDateTime: json['travelDateTime'],
//       price: json['price'],
//       status: json['status'],
//     );
//   }
//
//
//
// }


class TicketModel {
  String bookingId;
  String bookingReference;
  String source;
  String destination;
  String departureTime;
  String arrivalTime;
  String travelDuration;
  String travelDate;
  String travelDateTime;
  int price;
  String status;
  double? rating; // <-- Add this field, nullable for rides not rated yet

  TicketModel({
    required this.bookingId,
    required this.bookingReference,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.travelDuration,
    required this.travelDate,
    required this.travelDateTime,
    required this.price,
    required this.status,
    this.rating, // optional
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      bookingId: json['bookingId'],
      bookingReference: json['bookingReference'],
      source: json['source'],
      destination: json['destination'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      travelDuration: json['travelDuration'],
      travelDate: json['travelDate'],
      travelDateTime: json['travelDateTime'],
      price: json['price'],
      status: json['status'],
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null, // parse rating if available
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'bookingReference': bookingReference,
      'source': source,
      'destination': destination,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'travelDuration': travelDuration,
      'travelDate': travelDate,
      'travelDateTime': travelDateTime,
      'price': price,
      'status': status,
      'rating': rating,
    };
  }
}
