import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllBussesScreen extends StatefulWidget {
  const AllBussesScreen({super.key});

  @override
  State<AllBussesScreen> createState() => _AllBussesScreenState();
}

class _AllBussesScreenState extends State<AllBussesScreen> {
  // 🔹 Dummy bus data (you can replace this with API data later)
  final List<Map<String, dynamic>> allBuses = [
    {
      "busName": "Sharma Travels",
      "busNumber": "RJ14 AB 1234",
      "type": "AC Sleeper",
      "seats": 40,
      "route": "Jaipur → Delhi",
      "time": "10:00 PM - 5:00 AM"
    },
    {
      "busName": "Cityline Express",
      "busNumber": "DL10 XY 5678",
      "type": "Non-AC Seater",
      "seats": 35,
      "route": "Delhi → Agra",
      "time": "06:00 AM - 10:00 AM"
    },
    {
      "busName": "Royal Travels",
      "busNumber": "MH12 CD 4321",
      "type": "Volvo AC",
      "seats": 45,
      "route": "Pune → Mumbai",
      "time": "08:00 AM - 12:00 PM"
    },
    {
      "busName": "GreenLine Tours",
      "busNumber": "UP16 EF 7890",
      "type": "AC Sleeper",
      "seats": 38,
      "route": "Lucknow → Varanasi",
      "time": "09:00 PM - 6:00 AM"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "All Buses",
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade800,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: allBuses.length,
            itemBuilder: (context, index) {
              final bus = allBuses[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Bus Name + Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bus["busName"],
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            bus["type"],
                            style: GoogleFonts.poppins(
                              color: Colors.indigo.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // 🔹 Bus Number
                    Text(
                      "Bus No: ${bus["busNumber"]}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🔹 Route
                    Row(
                      children: [
                        const Icon(Icons.route_outlined, color: Colors.green, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            bus["route"],
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 🔹 Timing
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Colors.orange, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          bus["time"],
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 🔹 Seats info
                    Row(
                      children: [
                        const Icon(Icons.event_seat_outlined, color: Colors.blue, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "${bus["seats"]} Seats",
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(height: 12),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: ElevatedButton.icon(
                    //     onPressed: () {
                    //       // 👉 Navigate to bus details screen
                    //     },
                    //     icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    //     label: const Text("View Details"),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.indigo.shade700,
                    //       foregroundColor: Colors.white,
                    //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
