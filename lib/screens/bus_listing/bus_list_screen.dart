import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/onboard_controller.dart';
import '../../models/upcomming_modal.dart';
import '../routes_screen/bus_routes_screen.dart';

class BusListScreen extends StatelessWidget {
  BusListScreen({super.key});

  final OnboardController controller = Get.put(OnboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.indigo.shade900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Upcoming Buses",
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade900,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.allBuses.isEmpty) {
          return const Center(child: Text("No upcoming buses found"));
        }

        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: Colors.indigo.shade900,
                  labelColor: Colors.indigo.shade900,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: "ALL"),
                    Tab(text: "AC"),
                    Tab(text: "NON AC"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _busList(controller.allBuses),
                    _busList(controller.acBuses),
                    _busList(controller.nonAcBuses),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _busList(List<UpCommingBus> list) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final bus = list[index];
        final route = bus.route;
        final pricing = bus.pricing;

        final from = bus.searchOrigin.isNotEmpty
            ? bus.searchOrigin
            : route?.startPoint ?? '';
        final to = bus.finalDestination.isNotEmpty
            ? bus.finalDestination
            : bus.searchDestination.isNotEmpty
            ? bus.searchDestination
            : route?.finalDestination ?? '';

        final departureTime = bus.originalDepartureTime.isNotEmpty
            ? bus.originalDepartureTime
            : route?.originalDepartureTime ?? '';

        final totalDistance = route?.totalDistance ?? 0;
        final totalMinutes = route?.estimatedTravelTime ?? 0;
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;
        final durationText = "${hours}h ${minutes}m";

        final stopsText = route?.stops.map((s) => s.name).join(" • ") ?? '';

        return GestureDetector(
          onTap: () => Get.to(
                () => BusRoutesScreen(
              busData: bus,
              rawBusJson: {},
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [Colors.indigo.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        image: bus.bus?.frontImage != null
                            ? DecorationImage(
                          image: NetworkImage(bus.bus!.frontImage!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: bus.bus?.frontImage == null
                          ? const Icon(
                        Icons.directions_bus,
                        color: Colors.indigo,
                        size: 30,
                      )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bus.bus?.busName ?? "Unknown Bus",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bus.bus?.busNumber ?? "N/A",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Seats: ${bus.bus?.seatCapacity ?? 0}",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "$from → $to",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    departureTime,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "• $durationText",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "₹${pricing?.totalFare ?? 0}",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo.shade900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.route, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        stopsText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Distance: $totalDistance km",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}