import 'package:bus_booking_app/screens/select_seats/select_seats_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/onboard_bus_model.dart';

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
          return GestureDetector(
            onTap: (){
              Get.to(SelectSeatsScreen());
            },
            child: Container(
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
            ),
          );
        },
      ),
    );
  }
}
