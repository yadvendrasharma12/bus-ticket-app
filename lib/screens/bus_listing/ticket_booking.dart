import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class TicketBookingScreen extends StatefulWidget {
  const TicketBookingScreen({super.key});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  final List<Map<String, dynamic>> buses = [
    {
      "date": "Thu, 12 Apr 2025",
      "startTime": "07:15 AM",
      "endTime": "11:00 AM",
      "from": "Piramide, Roma",
      "to": "Florence, Portal ai",
      "price": "₹1,625",
      "expanded": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Available Tickets",
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

          return Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(
                    bottom: bus["expanded"] ? 60 : 40, top: 10),
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
                    // 🔹 Date Row
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
                        Icon(Icons.directions_bus,
                            color: Colors.indigo.shade900),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // 🔹 Time Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _timeColumn(bus["startTime"], bus["from"]),
                        Text(
                          "3h 45m",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _timeColumn(bus["endTime"], bus["to"]),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          bus["price"],
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                      ],
                    ),

                    // 🔹 Expanded Section (Ticket + Passenger + Bus + Staff Info)
                    if (bus["expanded"]) ...[
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Ticket Info
                      _sectionTitle("🎟 Ticket Information"),
                      _infoText("Ticket ID", "#TCKT874512"),
                      _infoText("Booking Date", "10 Apr 2025"),
                      _infoText("Travel Start", "12 Apr 2025, 07:15 AM"),
                      _infoText("Travel End", "12 Apr 2025, 11:00 AM"),
                      _infoText("Pickup Location", "Piramide, Roma"),
                      _infoText("Drop Location", "Florence, Portal ai"),
                      _infoText("Ticket Status", "Active", color: Colors.green),
                      _infoText("Distance", "275 km"),
                      _infoText("Duration", "3h 45m"),
                      _infoText("Total Fare", "₹1,625"),
                      _infoText("Seat", "A1, A2, A4"),

                      const SizedBox(height: 16),
                      _sectionTitle("🧍 Passenger Information"),
                      _infoText("Passenger Name", "Amit Sharma"),
                      _infoText("Age", "28"),
                      _infoText("Gender", "Male"),
                      _infoText("Contact", "9876543210"),
                      _infoText("Alt. Contact", "9998887777"),
                      _infoText("Email", "amit.sharma@example.com"),
                      _infoText("City", "Jaipur"),
                      _infoText("State", "Rajasthan"),
                      _infoText("Total Passenger", "3"),

                      const SizedBox(height: 16),
                      _sectionTitle("🚌 Bus Information"),
                      _infoText("Bus Name", "Rajdhani Express"),
                      _infoText("Bus Number", "RJ14-AB-1234"),

                      const SizedBox(height: 16),
                      _sectionTitle("👨‍✈️ Bus Staff Information"),
                      _infoText("Name", "Pramod Kumar"),
                      _infoText("Experience", "12 years"),
                      _infoText("Position", "Driver"),

                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.call, color: Colors.white),
                          label: Text(
                            "Call Bus Staff",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade800,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // TODO: Add Call Functionality
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _actionButton("Download Ticket", Icons.download, Colors.indigo.shade800, () {
                            // TODO: Download Ticket Action
                          }),
                          SizedBox(width: 8,),
                          _actionButton("Cancel Booking", Icons.cancel, Colors.red.shade700, () {
                            // TODO: Cancel Booking Action
                          }),
                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  ],
                ),
              ),

              // 🔹 Floating “View More / Less” Button
              Positioned(
                bottom: bus["expanded"] ? 30 : 16,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        bus["expanded"] = !bus["expanded"];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade800,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        bus["expanded"] ? "View Less" : "View More",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ⏰ Time Column
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

  // ℹ️ Info Text
  Widget _infoText(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.indigo.shade900,
        ),
      ),
    );
  }

  // 🔘 Action Buttons
  Widget _actionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
