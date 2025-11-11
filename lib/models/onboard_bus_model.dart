class OnboardBus {
  final String id;
  final DateTime date;
  final String time;
  final Pricing pricing;
  final Bus bus;
  final RouteData route;

  OnboardBus({
    required this.id,
    required this.date,
    required this.time,
    required this.pricing,
    required this.bus,
    required this.route,
  });

  factory OnboardBus.fromJson(Map<String, dynamic> json) {
    return OnboardBus(
      id: json['_id'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      pricing: Pricing.fromJson(json['pricing']),
      bus: Bus.fromJson(json['bus']),
      route: RouteData.fromJson(json['route']),
    );
  }

  void operator [](String other) {}
}

class Pricing {
  final int baseAmount;
  final int perKmRate;
  final int totalFare;

  Pricing({
    required this.baseAmount,
    required this.perKmRate,
    required this.totalFare,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      baseAmount: json['baseAmount'],
      perKmRate: json['perKmRate'],
      totalFare: json['totalFare'],
    );
  }
}

class Bus {
  final String id;
  final String busName;
  final String busNumber;
  final int seatCapacity;
  final String seatArchitecture;
  final String acType;
  final String? frontImage;

  Bus({
    required this.id,
    required this.busName,
    required this.busNumber,
    required this.seatCapacity,
    required this.seatArchitecture,
    required this.acType,
    this.frontImage,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['_id'],
      busName: json['busName'],
      busNumber: json['busNumber'],
      seatCapacity: json['seatCapacity'],
      seatArchitecture: json['seatArchitecture'],
      acType: json['acType'],
      frontImage: json['frontImage'],
    );
  }
}

class RouteData {
  final String id;
  final String name;
  final String startPoint;
  final String finalDestination;
  final String originalDepartureTime;
  final int totalDistance;
  final int estimatedTravelTime;
  final List<Stop> stops;

  RouteData({
    required this.id,
    required this.name,
    required this.startPoint,
    required this.finalDestination,
    required this.originalDepartureTime,
    required this.totalDistance,
    required this.estimatedTravelTime,
    required this.stops,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) {
    return RouteData(
      id: json['_id'],
      name: json['name'],
      startPoint: json['startPoint'],
      finalDestination: json['finalDestination'],
      originalDepartureTime: json['originalDepartureTime'],
      totalDistance: json['totalDistance'],
      estimatedTravelTime: json['estimatedTravelTime'],
      stops:
      (json['stops'] as List).map((e) => Stop.fromJson(e)).toList(),
    );
  }
}

class Stop {
  final String name;
  final int distanceFromPrev;
  final int durationFromPrev;
  final String arrivalTime;
  final int distanceFromStart;

  Stop({
    required this.name,
    required this.distanceFromPrev,
    required this.durationFromPrev,
    required this.arrivalTime,
    required this.distanceFromStart,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      name: json['name'],
      distanceFromPrev: json['distanceFromPrev'],
      durationFromPrev: json['durationFromPrev'],
      arrivalTime: json['arrivalTime'],
      distanceFromStart: json['distanceFromStart'],
    );
  }
}
