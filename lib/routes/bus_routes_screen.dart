import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusRoutesScreen extends StatefulWidget {
  const BusRoutesScreen({super.key});

  @override
  State<BusRoutesScreen> createState() => _BusRoutesScreenState();
}

class _BusRoutesScreenState extends State<BusRoutesScreen> {
  final List<Map<String, dynamic>> busStops = [
    {"stop": "Pune Station", "time": "07:00 AM", "distance": "0 km", "reached": true},
    {"stop": "Wakad Bridge", "time": "07:30 AM", "distance": "15 km", "reached": true},
    {"stop": "Lonavala", "time": "08:15 AM", "distance": "60 km", "reached": false},
    {"stop": "Panvel", "time": "09:10 AM", "distance": "100 km", "reached": false},
    {"stop": "Mumbai Central", "time": "10:00 AM", "distance": "120 km", "reached": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.indigo.shade800,)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Where is my Bus? Track and view your route details below 👇",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),


            Expanded(
              child: ListView.builder(
                itemCount: busStops.length,
                itemBuilder: (context, index) {
                  final stop = busStops[index];
                  final isLast = index == busStops.length - 1;
                  final reached = stop["reached"] as bool;

                  return Stack(
                    children: [

                      if (!isLast)
                        Positioned(
                          left: 27,
                          top: 40,
                          bottom: 0,
                          child: Container(
                            width: 2,
                            color: reached ? Colors.green : Colors.grey.shade400,
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔸 Circle Indicator
                            Column(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: reached
                                        ? Colors.green
                                        : Colors.grey.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: reached
                                      ? const Icon(Icons.check,
                                      size: 12, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),

                            // 🔹 Stop Details
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        _infoText(
                                          "🕒 Time: ",
                                          stop["time"],
                                        ),
                                        _infoText(
                                          "📍 Distance: ",
                                          stop["distance"],
                                        ),
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
            ),
          ],
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
