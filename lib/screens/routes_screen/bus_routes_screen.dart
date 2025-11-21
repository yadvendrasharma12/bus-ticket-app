

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';


import '../../models/upcomming_modal.dart';
import '../../widgets/custom_button.dart';



class BusRoutesScreen extends StatelessWidget {
  final UpCommingBus busData;               // Upcoming API ka model
  final Map<String, dynamic> rawBusJson;

  const BusRoutesScreen({
    super.key,
    required this.busData,
    required this.rawBusJson,
  });

  @override
  Widget build(BuildContext context) {
    if (busData.route == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("View routes")),
        body: const Center(child: Text("Route data not available")),
      );
    }

    final route = busData.route!;

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
            // Get.to(
            //       () => SelectSeatsScreen(
            //
            //     rawBusJson: rawBusJson, busData:  null,
            //   ),
            // );
          },
        ),
      ),
    );
  }
}

