import 'package:bus_booking_app/screens/bus_listing/ticket_details_scren.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final CancelBookingController cancelController =
  Get.put(CancelBookingController());

  final Map<String, bool> expandedTickets = {};

  @override
  void initState() {
    super.initState();
    controller.fetchTickets();
  }

  @override
  void dispose() {
    cancelController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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

        return  ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.tickets[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: // Inside ListView.builder -> Card -> Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ticket.travelDate,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.directions_bus,
                          color: Colors.indigo.shade900,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Time Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _timeColumn(ticket.departureTime, ticket.source),
                        Text(
                          ticket.travelDuration,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _timeColumn(ticket.arrivalTime, ticket.destination),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Price Row
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
                          "₹${ticket.price}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ✅ Rating (only if ride complete)
                    if (ticket.status.toLowerCase() == "completed") ...[
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            ticket.rating != null ? "${ticket.rating} / 5" : "Rate your ride",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => TicketDetailsScreen(
                                bookingId: ticket.bookingId,
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade800,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "View Ticket",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (ticket.status.toLowerCase() != "cancelled" &&
                                  ticket.status.toLowerCase() != "canceled") {
                                _handleCancelBooking(ticket);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              (ticket.status.toLowerCase() == "cancelled" ||
                                  ticket.status.toLowerCase() == "canceled")
                                  ? Colors.red.shade200
                                  : Colors.red.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Cancel Ticket",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade800,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Call Bus Staff",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),



                  ],
                ),

              ),
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

  // 🔘 Action Buttons
  Widget _actionButton(
      String label,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          textAlign: TextAlign.center,
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

  void _handleCancelBooking(dynamic ticket) {
    final status = ticket.status.toString().toLowerCase();

    if (status == "cancelled" || status == "canceled") {
      Get.snackbar(
        "Ticket Information",
        "Your ticket is already cancelled.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.95),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return;
    }

    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Cancel Booking",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: reasonController,

            decoration: InputDecoration(
              hintText: "Enter cancellation reason",

              contentPadding: const EdgeInsets.symmetric(

              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
            Obx(
                  () => cancelController.isLoading.value
                  ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
                  : TextButton(
                onPressed: () {
                  final reason = reasonController.text.trim();
                  if (reason.length < 5) {
                    Get.snackbar(
                      "Error",
                      "Reason must be at least 5 characters",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  cancelController
                      .cancelBooking(ticket.bookingId, reason)
                      .then((_) {
                    Navigator.pop(context);
                    controller.fetchTickets(); // refresh list
                  });
                },
                child: const Text("Confirm"),
              ),
            ),
          ],
        );
      },
    );
  }
}
