import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/bus_search_controller.dart';
import '../../models/onboard_bus_model.dart';
import '../../widgets/custom_button.dart';
import '../select_seats/select_seats_screen.dart';
class SearchBusScreen extends StatefulWidget {
  const SearchBusScreen({super.key});

  @override
  State<SearchBusScreen> createState() => _SearchBusScreenState();
}

class _SearchBusScreenState extends State<SearchBusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BusSearchController busController = Get.find<BusSearchController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
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
      ),
      body: Obx(() {
        final buses = busController.busList;

        if (busController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (buses.isEmpty) {
          return _emptyState();
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildBusList(buses), // ALL
            _buildBusList(
              buses.where((b) => b.bus?.acType.toLowerCase() == 'ac').toList(),
            ), // AC
            _buildBusList(
              buses.where((b) => b.bus?.acType.toLowerCase() == 'non-ac').toList(),
            ), // NON AC
          ],
        );
      }),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_bus_filled_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No buses available",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We couldn’t find any buses for this route on the selected date.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Search Again",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusList(List<OnboardBus> list) {
    if (list.isEmpty) {
      return const Center(child: Text("No upcoming buses found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final bus = list[index];
        final route = bus.route;
        final pricing = bus.pricing;

        // ✅ From / To
        final from = (bus.searchOrigin.isNotEmpty)
            ? bus.searchOrigin
            : route.startPoint;

        final to = (bus.finalDestination.isNotEmpty)
            ? bus.finalDestination
            : bus.searchDestination.isNotEmpty
            ? bus.searchDestination
            : route.finalDestination;

        // ✅ Departure Time
        final departureTime = bus.originalDepartureTime.isNotEmpty
            ? bus.originalDepartureTime
            : route.originalDepartureTime;

        // ✅ Distance & Duration
        final totalDistance = route.totalDistance;
        final totalMinutes = route.estimatedTravelTime;
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;
        final durationText = "${hours}h ${minutes}m";

        // ✅ Stops summary
        final stopNames = route.stops.map((s) => s.name).toList();
        final stopsText = stopNames.join(" • ");

        return GestureDetector(
          onTap: () => Get.to(
                () => BusRoutesScreen(
              busData: bus,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bus image / icon
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
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.route,
                      size: 16,
                      color: Colors.grey,
                    ),
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
                  "Distance: ${totalDistance} km",
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


class BusRoutesScreen extends StatelessWidget {
  final OnboardBus busData;

  const BusRoutesScreen({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    final route = busData.route;
    final bus = busData.bus;

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
                  "busId": {
                    "seatLayout": busData.bus?.seatLayout ?? {},
                  },
                }, onboardJson: {},
              ),
            );
          },
        ),


      ),
    );
  }
}

