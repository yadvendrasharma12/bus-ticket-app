class Ticket {
  final String bookingId;
  final String scheduleId;
  final String bookingReference;
  final PassengerDetails passenger;
  final TravelDetails travel;
  final BusDetails bus;
  final BookingDetails bookingDetails;
  final CrewDetails crew;
   String? ratingId;

  Ticket({
    required this.bookingId,
    required this.scheduleId,
    required this.bookingReference,
    required this.passenger,
    required this.travel,
     this.ratingId, // ✅
    required this.bus,
    required this.bookingDetails,
    required this.crew,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      bookingId: json['bookingId'] ?? '',
      ratingId: json['ratingId']?.toString(),
      scheduleId: json['scheduleId'] ??
          json['bookingDetails']?['scheduleId'] ??
          '', // top-level first, fallback to bookingDetails
      bookingReference: json['bookingReference'] ?? '',
      passenger: PassengerDetails.fromJson(json['passengerDetails'] ?? {}),
      travel: TravelDetails.fromJson(json['travelDetails'] ?? {}),
      bus: BusDetails.fromJson(json['busDetails'] ?? {}),
      bookingDetails: BookingDetails.fromJson(json['bookingDetails'] ?? {}),
      crew: CrewDetails.fromJson(json['crewDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'scheduleId': scheduleId,
      'bookingReference': bookingReference,
      'passengerDetails': passenger.toJson(),
      'travelDetails': travel.toJson(),
      'busDetails': bus.toJson(),
      'bookingDetails': bookingDetails.toJson(),
      'crewDetails': crew.toJson(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'contactNumber': contactNumber,
      'altContactNumber': altContactNumber,
      'email': email,
      'city': city,
      'state': state,
    };
  }
}

class TravelDetails {
  final String routeName;
  final String source;
  final String destination;
  final String travelDate;
  final String departureTime;
  final String arrivalTime;
  final String? travelDateRaw;
  final String? departureTime24;
  final String? arrivalTime24;
  final bool? isNextDay;

  TravelDetails({
    required this.routeName,
    required this.source,
    required this.destination,
    required this.travelDate,
    required this.departureTime,
    required this.arrivalTime,
    this.travelDateRaw,
    this.departureTime24,
    this.arrivalTime24,
    this.isNextDay,
  });

  factory TravelDetails.fromJson(Map<String, dynamic> json) {
    return TravelDetails(
      routeName: json['routeName'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      travelDate: json['travelDate'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      travelDateRaw: json['travelDateRaw'],
      departureTime24: json['departureTime24'],
      arrivalTime24: json['arrivalTime24'],
      isNextDay: json['isNextDay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routeName': routeName,
      'source': source,
      'destination': destination,
      'travelDate': travelDate,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'travelDateRaw': travelDateRaw,
      'departureTime24': departureTime24,
      'arrivalTime24': arrivalTime24,
      'isNextDay': isNextDay,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'busName': busName,
      'busNumber': busNumber,
      'seatCapacity': seatCapacity,
      'acType': acType,
    };
  }
}

class BookingDetails {
  final String? scheduleId;
  final List<String> seats;
  final int numberOfSeats;
  final double fare;
  final String status;
  final int? rating;
  final String? bookingDate;
  final String? specialRequests;
  final String? farePerSeat;

  BookingDetails({
    this.scheduleId,
    required this.seats,
    required this.numberOfSeats,
    required this.fare,
    required this.status,
    this.rating,
    this.bookingDate,
    this.specialRequests,
    this.farePerSeat,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      scheduleId: json['scheduleId'] ?? json['_id'],
      seats: List<String>.from(json['seats'] ?? []),
      numberOfSeats: json['numberOfSeats'] ?? 0,
      fare: (json['fare'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      rating: json['rating'] != null ? int.tryParse(json['rating'].toString()) : null,
      bookingDate: json['bookingDate'],
      specialRequests: json['specialRequests'],
      farePerSeat: json['farePerSeat']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'seats': seats,
      'numberOfSeats': numberOfSeats,
      'fare': fare,
      'status': status,
      'rating': rating,
      'bookingDate': bookingDate,
      'specialRequests': specialRequests,
      'farePerSeat': farePerSeat,
    };
  }
}

class CrewDetails {
  final String driverName;
  final String conductorName;

  CrewDetails({
    required this.driverName,
    required this.conductorName,
  });

  factory CrewDetails.fromJson(Map<String, dynamic> json) {
    return CrewDetails(
      driverName: json['driverName'] ?? '',
      conductorName: json['conductorName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'conductorName': conductorName,
    };
  }
}
