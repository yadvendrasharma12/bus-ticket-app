import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/onboard_bus_model.dart';
import '../../widgets/custom_button.dart';
import '../select_seats/select_seats_screen.dart';

class BusRoutesScreen extends StatelessWidget {
  final OnboardBus busData;         // required main bus data

  const BusRoutesScreen({super.key, required this.busData,});

  @override
  Widget build(BuildContext context) {
    final route = busData.route;
    return Scaffold(
      appBar: AppBar(
        title: Text(route.name.isNotEmpty ? route.name : "Bus Route", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.indigo.shade900)),
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
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.indigo),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stop.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.indigo.shade900)),
                      const SizedBox(height: 4),
                      Text("Arrival: ${stop.arrivalTime} | Distance: ${stop.distanceFromStart} km", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(bottom: 60, left: 16, right: 16),
        child: CustomButton(
          backgroundColor: Colors.yellow.shade800,
          text: "Book Ticket",
          onPressed: () {
            Get.to(() => SelectSeatsScreen(busData: busData));
          },
        ),
      ),
    );
  }
}
