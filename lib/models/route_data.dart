// import 'onboard_bus_model.dart';
//
// class RouteData {
//   final String id;
//   final String name;
//   final String startPoint;
//   final String finalDestination;
//   final String originalDepartureTime;
//   final int totalDistance;
//   final int estimatedTravelTime;
//   final List<Stop> stops;
//
//   RouteData({
//     required this.id,
//     required this.name,
//     required this.startPoint,
//     required this.finalDestination,
//     required this.originalDepartureTime,
//     required this.totalDistance,
//     required this.estimatedTravelTime,
//     required this.stops,
//   });
//
//   factory RouteData.fromJson(Map<String, dynamic> json) {
//     return RouteData(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       startPoint: json['startPoint'] ?? '',
//       finalDestination: json['finalDestination'] ?? '',
//       originalDepartureTime: json['originalDepartureTime'] ?? '',
//       totalDistance: json['totalDistance'] ?? 0,
//       estimatedTravelTime: json['estimatedTravelTime'] ?? 0,
//       stops: (json['stops'] ?? [])
//           .map<Stop>((e) => Stop.fromJson(e))
//           .toList(),
//     );
//   }
// }
