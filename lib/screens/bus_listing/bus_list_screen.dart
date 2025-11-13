import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/onboard_bus_model.dart';
import '../../serives/onboard_service.dart';
import '../routes_screen/bus_routes_screen.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<OnboardBus> allBuses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchUpcomingBuses();
  }

  Future<void> fetchUpcomingBuses() async {
    try {
      final response = await OnboardService.fetchUpcomingBuses();

      setState(() {
        allBuses = response.map((e) => OnboardBus.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.indigo.shade900),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.indigo.shade900,
            labelColor: Colors.indigo.shade900,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 13),
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
              .where((b) => b.bus?.acType.toLowerCase() == "ac")
              .toList()),
          _buildBusList(allBuses
              .where((b) => b.bus?.acType.toLowerCase() == "non-ac")
              .toList()),
        ],
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

        return GestureDetector(
          onTap: () => Get.to(() => BusRoutesScreen(busData: bus,)),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      ? const Icon(Icons.directions_bus,
                      color: Colors.indigo, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),


                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        bus.bus!.busName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bus.bus!.busNumber,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      Text(
                        "Seats: ${bus.bus?.seatCapacity}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),

                      const SizedBox(height: 6),
                      Text(
                        "${route.startPoint} → ${route.finalDestination}",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.grey[700]),
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
                                route.originalDepartureTime,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "₹${pricing?.totalFare}",
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
          ),
        );
      },
    );
  }
}
