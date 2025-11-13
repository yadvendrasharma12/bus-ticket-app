import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/bus_search_controller.dart';
import '../../models/onboard_bus_model.dart' as model;
import '../../widgets/custom_button.dart';
import '../select_seats/select_seats_screen.dart';

// ================== MAIN SCREEN ==================
class SearchBusScreen extends StatefulWidget {
  const SearchBusScreen({super.key});

  @override
  State<SearchBusScreen> createState() => _SearchBusScreenState();
}

class _SearchBusScreenState extends State<SearchBusScreen> {
  final BusSearchController busController = Get.find<BusSearchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
        title: Text(
          "Available Buses",
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade900,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        final buses = busController.busList;
        if (busController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (buses.isEmpty) {
          return Center(
            child: Text(
              "No buses found",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: buses.length,
          itemBuilder: (context, index) {
            final bus = buses[index];
            final pricing = bus['pricing'] ?? {};
            final busId = bus['busId'] ?? {};
            final busNumber = busId['busNumber'] ?? "N/A";
            final seatCapacity = busId['seatCapacity'] ?? 0;
            final isAc =
                (busId['acType'] ?? '').toString().toLowerCase() == 'ac';

            return GestureDetector(
              onTap: () {
                // ✅ Corrected: create OnboardBus with source & destination
                final busObj = OnboardBus.fromJson(bus);
                Get.to(() => BusRoutesScreen(busData: busObj));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.indigo.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bus Icon
                      Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: !isAc
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.indigo.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_bus_rounded,
                          color: isAc ? Colors.indigo : Colors.orange,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Bus Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bus['busName'] ?? "Unknown Bus",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo.shade900,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Row(
                              children: [
                                Text("Bus No - ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                                Text(
                                  busNumber,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Text("Seats - ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                                Text(
                                  "$seatCapacity",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Text("Route - ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                                Flexible(
                                  child: Text(
                                    "${bus['searchOrigin']} → ${bus['searchDestination']}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            Row(
                              children: [
                                Text("Time - ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                                Text(
                                  "Dep: ${bus['originalDepartureTime'] ?? 'N/A'}",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                const SizedBox(width: 10),
                                const Text("•"),
                                const SizedBox(width: 10),
                                Text(
                                  "Arr: ${bus['arrivalTimeAtDestination'] ?? 'N/A'}",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(
                                    isAc ? "AC Bus" : "Non-AC Bus",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isAc
                                          ? Colors.indigo
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                  backgroundColor: isAc
                                      ? Colors.indigo.shade50
                                      : Colors.orange.shade50,
                                ),
                                Text(
                                  "₹${pricing['totalFare'] ?? 0}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.indigo.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


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
    // 🔍 Step 1: Safely extract route data (handles route OR routeId)
    final routeJson = json['route'] ?? json['routeId'] ?? {};

    // 🔍 Step 2: Safely extract bus data (handles bus OR busId)
    final busJson = json['bus'] ?? json['busId'];

    // 🔍 Step 3: Return model
    return OnboardBus(
      id: json['_id'] ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time'],
      pricing: json['pricing'] != null
          ? Pricing.fromJson(json['pricing'])
          : null,
      bus: busJson != null ? Bus.fromJson(busJson) : null,
      route: routeJson.isNotEmpty
          ? RouteData.fromJson(routeJson)
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
    final stopsList = (json['stops'] as List?) ?? [];

    // 👇 agar finalDestination nahi mila, to last stop ka naam lo
    String destination = json['finalDestination'] ??
        json['searchDestination'] ??
        json['destination'] ??
        '';

    if (destination.isEmpty && stopsList.isNotEmpty) {
      final lastStop = stopsList.last;
      destination = lastStop['name'] ?? '';
    }

    return RouteData(
      name: json['name'] ?? '',
      startPoint: json['startPoint'] ??
          json['searchOrigin'] ??
          json['source'] ??
          '',
      finalDestination: destination,
      originalDepartureTime: json['originalDepartureTime'] ?? '',
      stops: stopsList.map((e) => Stop.fromJson(e)).toList(),
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



// ================== ROUTES SCREEN ==================
class BusRoutesScreen extends StatelessWidget {
  final OnboardBus busData;
  const BusRoutesScreen({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    final route = busData.route;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          route.name.isNotEmpty ? route.name : "Route Details",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.indigo.shade900,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: route.stops.length,
          itemBuilder: (context, index) {
            final stop = route.stops[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.indigo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Arrival: ${stop.arrivalTime}  |  Distance: ${stop.distanceFromStart} km",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          backgroundColor: Colors.yellow.shade800,
          text: "Book Ticket",
          onPressed: () {
            // 🟢 Console log all booking details before navigation
            print("🚌 Booking Data →");
            print("ID: ${busData.id}");
            print("Bus Name: ${busData.bus?.busName ?? 'N/A'}");
            print("Bus No: ${busData.bus?.busNumber ?? 'N/A'}");
            print("Seat Capacity: ${busData.bus?.seatCapacity ?? 0}");
            print("Route Name: ${busData.route.name}");
            print("Start Point: ${busData.route.startPoint}");
            print("Destination: ${busData.route.finalDestination}");
            print("Departure: ${busData.route.originalDepartureTime}");
            print("Total Stops: ${busData.route.stops.length}");
            for (var stop in busData.route.stops) {
              print(
                "➡ Stop: ${stop.name}, Arrival: ${stop.arrivalTime}, Distance: ${stop.distanceFromStart} km",
              );
            }

            // ✅ Convert busData to json correctly for next screen
            final busJson = {
              '_id': busData.id,
              'date': busData.date?.toIso8601String(),
              'time': busData.time,
              'pricing': {
                'baseAmount': busData.pricing?.baseAmount ?? 0,
                'perKmRate': busData.pricing?.perKmRate ?? 0,
                'totalFare': busData.pricing?.totalFare ?? 0,
              },
              'bus': {
                '_id': busData.bus?.id ?? '',
                'busName': busData.bus?.busName ?? '',
                'busNumber': busData.bus?.busNumber ?? '',
                'seatCapacity': busData.bus?.seatCapacity ?? 0,
                'seatArchitecture': busData.bus?.seatArchitecture ?? '',
                'acType': busData.bus?.acType ?? '',
                'frontImage': busData.bus?.frontImage,
              },
              'route': {
                'name': busData.route.name,
                'startPoint': busData.route.startPoint,
                'finalDestination': busData.route.finalDestination,
                'originalDepartureTime': busData.route.originalDepartureTime,
                'stops': busData.route.stops
                    .map((s) => {
                  'name': s.name,
                  'arrivalTime': s.arrivalTime,
                  'distanceFromStart': s.distanceFromStart,
                })
                    .toList(),
              },
            };

            // ✅ Navigate to seat selection screen
            Get.to(() => SelectSeatsScreen(
              busData: model.OnboardBus.fromJson(busJson),
            ));
          },
        ),
      ),
    );
  }
}

