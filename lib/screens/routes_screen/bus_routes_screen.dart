import 'package:bus_booking_app/screens/select_seats/select_seats_screen.dart';
import 'package:bus_booking_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BusRoutesScreen extends StatefulWidget {
  const BusRoutesScreen({super.key});

  @override
  State<BusRoutesScreen> createState() => _BusRoutesScreenState();
}

class _BusRoutesScreenState extends State<BusRoutesScreen> {
  final List<Map<String, dynamic>> busStops = [
    {"stop": "Pune Station", "time": "07:00 AM", "distance": "0 km"},
    {"stop": "Wakad Bridge", "time": "07:30 AM", "distance": "15 km"},
    {"stop": "Lonavala", "time": "08:15 AM", "distance": "60 km"},
    {"stop": "Panvel", "time": "09:10 AM", "distance": "100 km"},
    {"stop": "Mumbai Central", "time": "10:00 AM", "distance": "120 km"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.indigo.shade800),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Step 1: View Bus Route",
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 🔹 Route Title
              Text(
                "Bus Route Details",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade900,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Bus Stops
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: busStops.length,
                itemBuilder: (context, index) {
                  final stop = busStops[index];
                  final isLast = index == busStops.length - 1;

                  return Stack(
                    children: [
                      // Route line
                      if (!isLast)
                        Positioned(
                          left: 27,
                          top: 30,
                          bottom: 0,
                          child: Container(
                            width: 2,
                            color: Colors.indigo.shade300,
                          ),
                        ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Circle indicator (same color)
                            Column(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),

                            // Stop details
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stop["stop"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _infoText("🕒 Time: ", stop["time"]),
                                        _infoText("📍 Distance: ", stop["distance"]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 25),

              // ✅ Book Button
              Center(
                child: CustomButton(
                  backgroundColor: Colors.yellow.shade800,
                  textColor: Colors.white,
                  text: "Book Tickets!",
                  onPressed: () {
                    Get.to(() => const SelectSeatsScreen());
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: label,
        style: GoogleFonts.poppins(
          color: Colors.grey.shade700,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
