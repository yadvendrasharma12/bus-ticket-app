class TicketModel {
  final String bookingId;
  final String scheduleId;
  final String source;
  final String destination;
  final String travelDate;
  final String departureTime;
  final String arrivalTime;
  final String travelDuration;
  final int price;
  final String status;
  final double? rating;

  // ✅ NEW FIELDS
  final String? ratingId;
  final String? driverName;
  final String? driverNumber;
  final String? conductorName;
  final String? conductorNumber;

  TicketModel({
    required this.bookingId,
    required this.scheduleId,
    required this.source,
    required this.destination,
    required this.travelDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.travelDuration,
    required this.price,
    required this.status,
    this.rating,
    this.ratingId,
    this.driverName,
    this.driverNumber,
    this.conductorName,
    this.conductorNumber,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      bookingId: json['bookingId']?.toString() ?? '',
      scheduleId: json['scheduleId']?.toString()
          ?? json['_id']?.toString()
          ?? '',
      source: json['source']?.toString() ?? '',
      destination: json['destination']?.toString() ?? '',
      travelDate: json['travelDate']?.toString() ?? '',
      departureTime: json['departureTime']?.toString() ?? '',
      arrivalTime: json['arrivalTime']?.toString() ?? '',
      travelDuration: json['travelDuration']?.toString() ?? '',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      status: json['status']?.toString() ?? '',
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,

      // ✅ NEW MAPPINGS
      ratingId: json['ratingId']?.toString(),
      driverName: json['driverDetails']?['driverName'],
      driverNumber: json['driverDetails']?['driverNumber'],
      conductorName: json['driverDetails']?['conductorName'],
      conductorNumber: json['driverDetails']?['conductorNumber'],
    );
  }
}
