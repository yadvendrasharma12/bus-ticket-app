
class OnboardBus {
  final String id;
  final DateTime? date;
  final String? time;
  final Pricing? pricing;
  final Bus? bus;
  final RouteData route;

  OnboardBus({
    required this.route,
    this.id = '',
    this.date,
    this.time,
    this.pricing,
    this.bus,
  });

  factory OnboardBus.fromJson(Map<String, dynamic> json) {
    return OnboardBus(
      id: json['_id'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'],
      pricing: json['pricing'] != null ? Pricing.fromJson(json['pricing']) : null,
      bus: json['bus'] != null ? Bus.fromJson(json['bus']) : null,
      route: json['route'] != null
          ? RouteData.fromJson(json['route'])
          : RouteData(name: '', stops: []),
    );
  }


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
      baseAmount: json['baseAmount'] ?? 0,
      perKmRate: json['perKmRate'] ?? 0,
      totalFare: json['totalFare'] ?? 0,
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
      id: json['_id'] ?? '',
      busName: json['busName'] ?? '',
      busNumber: json['busNumber'] ?? '',
      seatCapacity: json['seatCapacity'] ?? 0,
      seatArchitecture: json['seatArchitecture'] ?? '',
      acType: json['acType'] ?? '',
      frontImage: json['frontImage'],
    );
  }
}

class RouteData {
  final String name;
  final String startPoint;
  final String finalDestination;
  final String originalDepartureTime;
  final List<Stop> stops;

  RouteData({
    required this.name,
    this.startPoint = '',
    this.finalDestination = '',
    this.originalDepartureTime = '',
    required this.stops,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) {
    final stopsJson = json['stops'] as List<dynamic>? ?? [];
    return RouteData(
      name: json['name'] ?? '',
      startPoint: json['startPoint'] ?? '',
      finalDestination: json['finalDestination'] ?? '',
      originalDepartureTime: json['originalDepartureTime'] ?? '',
      stops: stopsJson.map((e) => Stop.fromJson(e)).toList(),
    );
  }
}

class Stop {
  final String name;
  final String arrivalTime;
  final double distanceFromStart;

  Stop({
    required this.name,
    required this.arrivalTime,
    required this.distanceFromStart,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      name: json['name'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      distanceFromStart: (json['distanceFromStart'] ?? 0).toDouble(),
    );
  }
}
