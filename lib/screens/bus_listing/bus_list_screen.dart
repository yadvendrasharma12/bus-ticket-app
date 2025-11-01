
import 'package:bus_booking_app/screens/all_bus/all_busses_screen.dart';
import 'package:bus_booking_app/screens/bus_listing/bus_listing_screen.dart';
import 'package:bus_booking_app/screens/driver/driver_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes_screen/bus_routes_screen.dart';



class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> buses = [
    {
      "busName": "SLTB Express",
      "startTime": "06:30 AM",
      "endTime": "11:15 AM",
      "date": "30 Oct 2025",
      "journeyTime": "4h 45m",
      "distance": "320 km"
    },
    {
      "busName": "Blue Line Travels",
      "startTime": "08:00 AM",
      "endTime": "01:00 PM",
      "date": "30 Oct 2025",
      "journeyTime": "5h 00m",
      "distance": "340 km"
    },
    {
      "busName": "Green Go Express",
      "startTime": "09:15 AM",
      "endTime": "02:45 PM",
      "date": "30 Oct 2025",
      "journeyTime": "5h 30m",
      "distance": "360 km"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          margin:  EdgeInsets.only(right: 10),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.indigo.shade900, width: 2),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 7),
            child: Text(
              "Colombo → Kandy , 30 Oct 2025",
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBusList(buses),
          _buildBusList(buses.where((bus) => bus["busName"]!.contains("AC")).toList()),
          _buildBusList(buses.where((bus) => !bus["busName"]!.contains("AC")).toList()),
        ],
      ),
    );
  }

  Widget _buildBusList(List<Map<String, String>> list) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final bus = list[index];
        return GestureDetector(
          onTap: (){
            Get.to(BusRoutesScreen());
          },
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
                // Bus Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bus["busName"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo[900],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Get.to(AllBussesScreen());
                      },
                        child: Icon(Icons.directions_bus, color: Colors.indigo[800])),
                  ],
                ),
                const SizedBox(height: 10),

                // Time Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _timeBox("Start", bus["startTime"]!),
                    Icon(Icons.arrow_forward, color: Colors.grey[700]),
                    _timeBox("End", bus["endTime"]!),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("10 Seats",style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),),
                    _infoItem(Icons.timer_outlined, bus["journeyTime"]!),
                    _infoItem(Icons.map_outlined, bus["distance"]!),
                  ],
                ),
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
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _infoItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.indigo[800]),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}
