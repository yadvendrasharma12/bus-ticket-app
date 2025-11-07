import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../serives/onboard_service.dart';

import '../routes_screen/bus_routes_screen.dart';


class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key, required List busList});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<dynamic> allBuses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchUpcomingBuses();
  }

  Future<void> fetchUpcomingBuses() async {
    try {
      final result = await OnboardService.fetchUpcomingBuses();
      setState(() {
        allBuses = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.indigo.shade900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          margin: const EdgeInsets.only(right: 10),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.indigo.shade900, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7),
            child: Text(
              "Upcoming Buses",
              style: GoogleFonts.poppins(
                color: Colors.indigo.shade900,
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.indigo.shade900,
            labelColor: Colors.indigo.shade900,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildBusList(allBuses),
          _buildBusList(allBuses
              .where((bus) => (bus["bus"]["acType"] ?? "").toLowerCase() == "ac")
              .toList()),
          _buildBusList(allBuses
              .where((bus) => (bus["bus"]["acType"] ?? "").toLowerCase() == "non-ac")
              .toList()),
        ],
      ),
    );
  }

  Widget _buildBusList(List<dynamic> list) {
    if (list.isEmpty) {
      return const Center(child: Text("No upcoming buses found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final busData = list[index];
        final bus = busData["bus"] ?? {};
        final route = busData["route"] ?? {};
        final pricing = busData["pricing"] ?? {};

        return GestureDetector(
          onTap: () => Get.to(() => const BusRoutesScreen()),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Bus name and icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bus["busName"] ?? "Unknown Bus",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo[900],
                      ),
                    ),
                    Icon(Icons.directions_bus, color: Colors.indigo[800]),
                  ],
                ),
                const SizedBox(height: 10),

                // 🔹 Route info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _timeBox("Start", route["startPoint"] ?? "-"),
                    Icon(Icons.arrow_forward, color: Colors.grey[700]),
                    _timeBox("End", route["finalDestination"] ?? "-"),
                  ],
                ),
                const SizedBox(height: 12),

                // 🔹 Additional info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Seats: ${bus["seatCapacity"] ?? 'N/A'}",
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.black87)),
                    _infoItem(Icons.timer_outlined,
                        "${route["estimatedTravelTime"] ?? 0} mins"),
                    _infoItem(Icons.map_outlined,
                        "${route["totalDistance"] ?? 0} km"),
                  ],
                ),
                const SizedBox(height: 8),

                Text("Fare: ₹${pricing["totalFare"] ?? 0}",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700])),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _timeBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ],
    );
  }

  Widget _infoItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.indigo[800]),
        const SizedBox(width: 4),
        Text(value,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
