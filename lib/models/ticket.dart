class Ticket {
  final String bookingId;
  final String bookingReference;
  final PassengerDetails passenger;
  final TravelDetails travel;
  final BusDetails bus;
  final BookingDetails bookingDetails;
  final CrewDetails crew;

  Ticket({
    required this.bookingId,
    required this.bookingReference,
    required this.passenger,
    required this.travel,
    required this.bus,
    required this.bookingDetails,
    required this.crew,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      bookingId: json['bookingId'] ?? '',
      bookingReference: json['bookingReference'] ?? '',
      passenger: PassengerDetails.fromJson(json['passengerDetails']),
      travel: TravelDetails.fromJson(json['travelDetails']),
      bus: BusDetails.fromJson(json['busDetails']),
      bookingDetails: BookingDetails.fromJson(json['bookingDetails']),
      crew: CrewDetails.fromJson(json['crewDetails']),
    );
  }
}

class PassengerDetails {
  final String name;
  final int age;
  final String gender;
  final String contactNumber;
  final String altContactNumber;
  final String email;
  final String city;
  final String state;

  PassengerDetails({
    required this.name,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.altContactNumber,
    required this.email,
    required this.city,
    required this.state,
  });

  factory PassengerDetails.fromJson(Map<String, dynamic> json) {
    return PassengerDetails(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      altContactNumber: json['altContactNumber'] ?? '',
      email: json['email'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}

class TravelDetails {
  final String routeName;
  final String source;
  final String destination;
  final String travelDate;
  final String departureTime;
  final String arrivalTime;

  TravelDetails({
    required this.routeName,
    required this.source,
    required this.destination,
    required this.travelDate,
    required this.departureTime,
    required this.arrivalTime,
  });

  factory TravelDetails.fromJson(Map<String, dynamic> json) {
    return TravelDetails(
      routeName: json['routeName'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      travelDate: json['travelDate'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
    );
  }
}

class BusDetails {
  final String busName;
  final String busNumber;
  final int seatCapacity;
  final String acType;

  BusDetails({
    required this.busName,
    required this.busNumber,
    required this.seatCapacity,
    required this.acType,
  });

  factory BusDetails.fromJson(Map<String, dynamic> json) {
    return BusDetails(
      busName: json['busName'] ?? '',
      busNumber: json['busNumber'] ?? '',
      seatCapacity: json['seatCapacity'] ?? 0,
      acType: json['acType'] ?? '',
    );
  }
}

class BookingDetails {
  final List<String> seats;
  final int numberOfSeats;
  final double fare;
  final String status;

  BookingDetails({
    required this.seats,
    required this.numberOfSeats,
    required this.fare,
    required this.status,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      seats: List<String>.from(json['seats'] ?? []),
      numberOfSeats: json['numberOfSeats'] ?? 0,
      fare: (json['fare'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}

class CrewDetails {
  final String driverName;
  final String conductorName;

  CrewDetails({required this.driverName, required this.conductorName});

  factory CrewDetails.fromJson(Map<String, dynamic> json) {
    return CrewDetails(
      driverName: json['driverName'] ?? '',
      conductorName: json['conductorName'] ?? '',
    );
  }
}
