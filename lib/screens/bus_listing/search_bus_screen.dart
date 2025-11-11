import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/bus_search_controller.dart';

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
            final isAc = (busId['acType'] ?? '').toString().toLowerCase() == 'ac';

            return GestureDetector(
              onTap: () {
                final busObj = OnboardBus.fromJson(bus); // local model
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
                      Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: isAc
                              ? Colors.indigo.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_bus_rounded,
                          color: isAc ? Colors.indigo : Colors.orange,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bus Name
                            Text(
                              bus['busName'] ?? "Unknown Bus",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo.shade900,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Bus Number & Seats
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Text(
                                  "Bus No - ",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                Text(
                                  "$busNumber",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Text(
                                  "Seats - ",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                Text(
                                  "$seatCapacity",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Route
                            Row(
                              children: [
                                Text(
                                  "Route - ",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    "${bus['searchOrigin']} → ${bus['searchDestination']}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Timing Row
                            Row(
                              children: [
                                Text(
                                  "Time - ",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                const SizedBox(width: 4),
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

                            // Fare + AC Tag
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  backgroundColor: isAc
                                      ? Colors.indigo.shade50
                                      : Colors.orange.shade50,
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

// ================== LOCAL MODEL ==================
class OnboardBus {
  final String busName;
  final RouteData route;

  OnboardBus({required this.busName, required this.route});

  factory OnboardBus.fromJson(Map<String, dynamic> json) {
    return OnboardBus(
      busName: json['busName'] ?? '',
      route: RouteData.fromJson(json['routeId'] ?? {}),
    );
  }
}

class RouteData {
  final String name;
  final List<Stop> stops;

  RouteData({required this.name, required this.stops});

  factory RouteData.fromJson(Map<String, dynamic> json) {
    final stopsJson = json['stops'] as List<dynamic>? ?? [];
    return RouteData(
      name: json['name'] ?? '',
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

// ================== BUS ROUTES SCREEN ==================
class BusRoutesScreen extends StatelessWidget {
  final OnboardBus busData;
  const BusRoutesScreen({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    final route = busData.route;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          route.name,
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
      body: ListView.builder(
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
                            fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
