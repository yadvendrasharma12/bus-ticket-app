import 'package:bus_booking_app/screens/select_seats/select_seats_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class BusListingScreen extends StatefulWidget {
  const BusListingScreen({super.key});

  @override
  State<BusListingScreen> createState() => _BusListingScreenState();
}

class _BusListingScreenState extends State<BusListingScreen> {
  // List of bus data
  final List<Map<String, dynamic>> buses = [
    {
      "date": "Thu, 12 Apr 2025",
      "startTime": "07:15",
      "endTime": "11:00",
      "from": "Pune",
      "to": "Mumbai",
      "price": "₹16.25",
      "seatsLeft": "15 Seats left",
      "expanded": false,
    },
    {
      "date": "Thu, 15 Apr 2025",
      "startTime": "13:00",
      "endTime": "16:45",
      "from": "Delhi",
      "to": "Agra",
      "price": "₹11.55",
      "seatsLeft": "12 Seats left",
      "expanded": false,
    },
    {
      "date": "Fri, 15 Apr 2025",
      "startTime": "16:00",
      "endTime": "19:45",
      "from": "Jaipur",
      "to": "Udaipur",
      "price": "₹13.55",
      "seatsLeft": "8 Seats left",
      "expanded": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Available Buses",
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade900,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Top Row - Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bus["date"],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.directions_bus, color: Colors.indigo.shade900),
                  ],
                ),
                const SizedBox(height: 15),

                // 🔹 Time & Route
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _timeColumn(bus["startTime"], bus["from"]),
                    Padding(
                      padding: const EdgeInsets.only(right: 80,bottom: 25),
                      child: Text("3h 33m",style: GoogleFonts.poppins(
                        color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500
                      ),),
                    ),
                    _timeColumn(bus["endTime"], bus["to"]),
                  ],
                ),
                const SizedBox(height: 10),

                // 🔹 Bottom Row Info
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event_seat, size: 19, color: Colors.indigo.shade900),
                        const SizedBox(width: 5),
                        Text(
                          bus["seatsLeft"],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      bus["price"],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),


                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellow.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onPressed: () {
                      setState(() {
                        bus["expanded"] = !bus["expanded"];
                      });
                    },
                    child: Text(
                      bus["expanded"] ? "View Less" : "View More",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // 🔹 Expanded Section
                if (bus["expanded"]) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                              _iconInfo(Icons.wifi, "Wi-Fi"),
                                SizedBox(height: 20,),
                              _iconInfo(Icons.ac_unit, "AC"),
                            ],),
                          SizedBox(height: 30,),
                          Column(
                            children: [
                            _iconInfo(Icons.chair_alt, "Sleeper"),
                              SizedBox(height: 20,),
                            _iconInfo(Icons.usb, "Charging"),
                          ],)

                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade800,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.to(SelectSeatsScreen());
                      },
                      child: Text(
                        "Select Seats",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper: time column
  Widget _timeColumn(String time, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          city,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // Helper: amenities icons
  Widget _iconInfo(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 26, color: Colors.indigo.shade900),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
              fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
