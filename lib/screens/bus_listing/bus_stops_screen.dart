
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/bus_search_controller.dart';
import '../../models/onboard_bus_model.dart';
import '../../widgets/custom_button.dart';
import '../select_seats/select_seats_screen.dart';

class BusStopsScreen extends StatelessWidget {
  final OnboardBus busData;
  final double farePerSeat;
  const BusStopsScreen({super.key, required this.busData, required this.farePerSeat});

  @override
  Widget build(BuildContext context, ) {
    final route = busData.route;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          route.name.isNotEmpty ? route.name : "View routes",
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...route.stops.map((stop) {
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
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          backgroundColor: Colors.yellow.shade800,
          text: "Book Ticket",
          onPressed: () {

            Get.to(
                  () => SelectSeatsScreen(
                busData: busData,
                rawBusJson: {
                  "pricing": {
                    "baseAmount": busData.pricing?.baseAmount ?? 0,
                    "perKmRate": busData.pricing?.perKmRate ?? 0,
                    "totalFare": busData.pricing?.totalFare ?? 0,
                  },
                  "routeId": {
                    "startPoint": busData.route.startPoint,
                    "stops": busData.route.stops.asMap().entries.map((entry) {
                      final i = entry.key;
                      final stop = entry.value;


                      final prevDistance = i == 0
                          ? 0
                          : (stop.distanceFromStart -
                          busData.route.stops[i - 1].distanceFromStart);

                      return {
                        "name": stop.name,
                        "distanceFromPrev": prevDistance,
                      };
                    }).toList(),
                  },
                  "searchOrigin": busData.searchOrigin,
                  "searchDestination": busData.searchDestination,
                  "busId": {
                    "seatLayout": busData.bus?.seatLayout ?? {},
                  },
                },
                onboardJson: {}, farePerSeat: farePerSeat,
              ),
            );
          },
        ),
      ),
    );
  }
}
