import 'package:bus_booking_app/screens/bus_listing/ticket_details_scren.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../controllers/cancle_booking_controller.dart';
import '../../controllers/ticket_controller.dart';

class TicketBookingScreen extends StatefulWidget {
  const TicketBookingScreen({super.key});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {

  final TicketController controller = Get.put(TicketController());
  final CancelBookingController cancelController = Get.put(CancelBookingController());

  final Map<String, bool> expandedTickets = {};



  @override
  void initState() {
    super.initState();
    controller.fetchTickets();
  }

  @override
  void dispose() {
    // TODO: implement dispose
     cancelController.dispose();
     controller.dispose();
    super.dispose();
  }
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tickets.isEmpty) {
          return const Center(child: Text("No Tickets Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.tickets[index];
            expandedTickets[ticket.bookingId] ??= false;

            bool isExpanded = expandedTickets[ticket.bookingId]!;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(bottom: isExpanded ? 60 : 40, top: 10),
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
                      // Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ticket.travelDate,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500)),
                          Icon(Icons.directions_bus, color: Colors.indigo.shade900)
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _timeColumn(ticket.departureTime, ticket.source),
                          Text(ticket.travelDuration,
                              style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          _timeColumn(ticket.arrivalTime, ticket.destination),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)),
                          Text("₹${ticket.price}",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo.shade900)),
                        ],
                      ),

                      // Expanded Section
                      if (isExpanded) ...[
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 10),
                        // _sectionTitle("🎟 Ticket Information"),
                        // _infoText("Ticket ID", ticket.bookingId),
                        // _infoText("Reference", ticket.bookingReference),
                        // _infoText("Status", ticket.status),
                        // _infoText("Duration", ticket.travelDuration),
                        // _infoText("Price", "₹${ticket.price}"),
                        // _infoText("From", ticket.source),
                        // _infoText("To", ticket.destination),
                        // _infoText("Status", ticket.status, color: Colors.green),
                        // const SizedBox(height: 16),
                        // _sectionTitle("🧍 Passenger Information"),
                        // _infoText("Passenger Name", "Amit Sharma"),
                        // _infoText("Age", "28"),
                        // _infoText("Gender", "Male"),
                        // _infoText("Contact", "9876543210"),
                        // _infoText("Alt. Contact", "9998887777"),
                        // _infoText("Email", "amit.sharma@example.com"),
                        // _infoText("City", "Jaipur"),
                        // _infoText("State", "Rajasthan"),
                        // _infoText("Total Passenger", "3"),
                        // const SizedBox(height: 16),
                        // _sectionTitle("🚌 Bus Information"),
                        // _infoText("Bus Name", "Rajdhani Express"),
                        // _infoText("Bus Number", "RJ14-AB-1234"),
                        // const SizedBox(height: 16),
                        // _sectionTitle("👨‍✈️ Bus Staff Information"),
                        // _infoText("Name", "Pramod Kumar"),
                        // _infoText("Experience", "12 years"),
                        // _infoText("Position", "Driver"),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.call, color: Colors.white),
                            label: Text("Call Bus Staff",
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow.shade800,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _actionButton("View Ticket Info"
                                "", Icons.download_done,
                                Colors.indigo.shade800, () {
                                  Get.to(() => TicketDetailsScreen(bookingId: ticket.bookingId));
                                }),
                            const SizedBox(width: 8),
                            _actionButton("Cancel Booking", Icons.cancel,
                                Colors.red.shade700, () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        TextEditingController reasonController =
                                        TextEditingController();
                                        return AlertDialog(
                                          title: const Text("Cancel Booking"),
                                          content: TextField(
                                            controller: reasonController,
                                            decoration: const InputDecoration(
                                                hintText: "Enter cancellation reason"),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Cancel")),
                                            Obx(() => cancelController.isLoading.value
                                                ? const CircularProgressIndicator()
                                                : TextButton(
                                              onPressed: () {
                                                final reason =
                                                reasonController.text.trim();
                                                if (reason.length < 5) {
                                                  Get.snackbar(
                                                      "Error",
                                                      "Reason must be at least 5 characters",
                                                      snackPosition:
                                                      SnackPosition.BOTTOM);
                                                  return;
                                                }
                                                cancelController
                                                    .cancelBooking(
                                                    ticket.bookingId,
                                                    reason)
                                                    .then((_) =>
                                                    Navigator.pop(context));
                                              },
                                              child: const Text("Confirm"),
                                            )),
                                          ],
                                        );
                                      });
                                }),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),

                // View More / Less button
                Positioned(
                  bottom: isExpanded ? 30 : 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedTickets[ticket.bookingId] = !isExpanded;

                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          isExpanded ? "View Less" : "View More",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
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
