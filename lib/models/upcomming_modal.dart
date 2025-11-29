class UpCommingBus {
  final String id;
  final DateTime? date;
  final String time;
  final Pricing? pricing;
  final Bus? bus;
  final RouteData? route;

  final String searchOrigin;
  final String searchDestination;
  final String finalDestination;
  final String originalDepartureTime;

  UpCommingBus({
    required this.id,
    required this.date,
    required this.time,
    required this.pricing,
    required this.bus,
    required this.route,
    this.searchOrigin = '',
    this.searchDestination = '',
    this.finalDestination = '',
    this.originalDepartureTime = '',
  });

  factory UpCommingBus.fromJson(Map<String, dynamic> json) {
    final routeData = json['route'] != null
        ? RouteData.fromJson(Map<String, dynamic>.from(json['route']))
        : null;
    final busData = json['bus'] != null
        ? Bus.fromJson(Map<String, dynamic>.from(json['bus']))
        : null;
    final pricingData = json['pricing'] != null
        ? Pricing.fromJson(Map<String, dynamic>.from(json['pricing']))
        : null;

    return UpCommingBus(
      id: json['_id']?.toString() ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time']?.toString() ?? '',
      pricing: pricingData,
      bus: busData,
      route: routeData,
      searchOrigin: json['searchOrigin']?.toString() ?? '',
      searchDestination: json['searchDestination']?.toString() ?? '',
      finalDestination: routeData?.finalDestination ?? '',
      originalDepartureTime: routeData?.originalDepartureTime ?? '',
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

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
    baseAmount: (json['baseAmount'] ?? 0).toInt(),
    perKmRate: (json['perKmRate'] ?? 0).toInt(),
    totalFare: (json['totalFare'] ?? 0).toInt(),
  );
}

class Bus {
  final String id;
  final String busName;
  final String busNumber;
  final int seatCapacity;
  final String seatArchitecture;
  final String acType;
  final String? frontImage;
  final int? averageRating;
  final int? totalRatings;
  final Map<String, dynamic>? seatLayout;

  Bus({
    required this.id,
    required this.busName,
    required this.busNumber,
    required this.seatCapacity,
    required this.seatArchitecture,
    required this.acType,
    this.frontImage,
    this.averageRating,
    this.totalRatings,
    this.seatLayout,
  });

  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
    id: json['_id']?.toString() ?? '',
    busName: json['busName']?.toString() ?? '',
    busNumber: json['busNumber']?.toString() ?? '',
    seatCapacity: (json['seatCapacity'] ?? 0).toInt(),
    seatArchitecture: json['seatArchitecture']?.toString() ?? '2+2',
    acType: json['acType']?.toString() ?? '',
    frontImage: json['frontImage']?.toString(),
    averageRating: json['averageRating'] != null
        ? (json['averageRating'] as num).toInt()
        : null,
    totalRatings: json['totalRatings'] != null
        ? (json['totalRatings'] as num).toInt()
        : null,
    seatLayout: json['seatLayout'] != null
        ? Map<String, dynamic>.from(json['seatLayout'])
        : null,
  );
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
    final stopsList = (json['stops'] as List<dynamic>? ?? [])
        .map((e) => Stop.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return RouteData(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      startPoint: json['startPoint']?.toString() ?? '',
      finalDestination: json['finalDestination']?.toString() ?? '',
      originalDepartureTime: json['originalDepartureTime']?.toString() ?? '',
      totalDistance: (json['totalDistance'] ?? 0).toInt(),
      estimatedTravelTime: (json['estimatedTravelTime'] ?? 0).toInt(),
      stops: stopsList,
    );
  }
}

class Stop {
  final String id;
  final String name;
  final String arrivalTime;
  final double distanceFromStart;

  Stop({
    required this.id,
    required this.name,
    required this.arrivalTime,
    required this.distanceFromStart,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
    id: json['_id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    arrivalTime: json['arrivalTime']?.toString() ?? '',
    distanceFromStart: (json['distanceFromStart'] ?? 0).toDouble(),
  );
}
