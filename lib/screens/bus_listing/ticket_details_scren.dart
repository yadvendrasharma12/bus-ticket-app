import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/ticket_details_controller.dart';
import '../../models/ticket.dart';
import '../../serives/rating_services.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String bookingId;
  final bool openRatingDirectly;

  const TicketDetailsScreen({
    super.key,
    required this.bookingId,
    this.openRatingDirectly = false,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  late TicketDetailsController controller;
  bool _hasShownRatingDialog = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TicketDetailsController());
    controller.fetchTicket(widget.bookingId);

    ever(controller.ticket, (ticket) {
      if (ticket == null) return;

      final status = ticket.bookingDetails.status.toLowerCase();
      final rating = ticket.bookingDetails.rating ?? 0;

      final bool isConfirmed = status == "confirmed";

      // अगर rating पहले ही दी जा चुकी या dialog पहले ही दिखा दिया गया
      if (_hasShownRatingDialog || rating > 0) return;

      if (isConfirmed) {
        _hasShownRatingDialog = true; // dialog सिर्फ एक बार show होगा
        if (widget.openRatingDirectly) {
          _showRatingDialog(ticket);
        } else {
          Future.delayed(const Duration(milliseconds: 300), () {
            _showRatingDialog(ticket);
          });
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ticket Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ticket = controller.ticket.value;
        if (ticket == null) {
          return const Center(child: Text("No ticket details found."));
        }

        final seatCount = ticket.bookingDetails.seats.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("🎟 Ticket Information"),
              _infoText("Booking ID", _formatBookingId(ticket.bookingId)),
              _infoText(
                "Schedule ID",
                ticket.scheduleId.isNotEmpty
                    ? ticket.scheduleId
                    : "Not available",
              ),
              _infoText("Reference", ticket.bookingReference),
              _infoText(
                "Status",
                ticket.bookingDetails.status,
                color: (ticket.bookingDetails.status.toLowerCase() ==
                    "active" ||
                    ticket.bookingDetails.status.toLowerCase() ==
                        "confirmed")
                    ? Colors.green
                    : Colors.red,
              ),
              _infoText(
                "Seats Booked",
                ticket.bookingDetails.seats.join(", "),
              ),
              _infoText(
                "Total Tickets",
                "$seatCount ticket${seatCount > 1 ? 's' : ''}",
              ),
              _infoText("Fare", "₹${ticket.bookingDetails.fare}"),
              const SizedBox(height: 20),

              _sectionTitle("🧍 Passenger Information"),
              _infoText("Name", ticket.passenger.name),
              _infoText("Age", ticket.passenger.age.toString()),
              _infoText("Gender", ticket.passenger.gender),
              _infoText("Contact", ticket.passenger.contactNumber),
              _infoText("Alt Contact", ticket.passenger.altContactNumber),
              _infoText("Email", ticket.passenger.email),
              _infoText("City", ticket.passenger.city),
              _infoText("State", ticket.passenger.state),
              const SizedBox(height: 20),

              _sectionTitle("🚌 Bus Information"),
              _infoText("Bus Name", ticket.bus.busName),
              _infoText("Bus Number", ticket.bus.busNumber),
              _infoText(
                  "Seats Capacity", ticket.bus.seatCapacity.toString()),
              _infoText("AC Type", ticket.bus.acType),
              const SizedBox(height: 20),

              _sectionTitle("👨‍✈️ Bus Staff Information"),
              _infoText("Driver", ticket.crew.driverName),
              _infoText("Conductor", ticket.crew.conductorName),
              const SizedBox(height: 20),

              _sectionTitle("🛣 Travel Information"),
              _infoText("From", ticket.travel.source),
              _infoText("To", ticket.travel.destination),
              _infoText("Route", ticket.travel.routeName),
              _infoText("Departure", ticket.travel.departureTime),
              _infoText("Arrival", ticket.travel.arrivalTime),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  String _formatBookingId(String id) {
    if (id.length <= 4) return id.toUpperCase();
    return id.substring(0, 4).toUpperCase();
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(Ticket ticket) {
    final status = ticket.bookingDetails.status.toLowerCase();
    final rating = ticket.bookingDetails.rating ?? 0;


    if (status != "confirmed") return;
    if (rating > 0) return;

    int selectedRating = 1;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange.shade400,
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Rate your ride",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Stars
                    Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isFilled = starIndex <= selectedRating;
                        return GestureDetector(
                          onTap: () =>
                              setStateDialog(() => selectedRating = starIndex),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                              isFilled
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 32,
                              color: Colors.orange.shade400,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Comments (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _hasShownRatingDialog = true;
                            Get.back();
                          },
                          child: const Text("Skip"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final scheduleId = ticket.scheduleId;
                            if (scheduleId.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Schedule ID not found",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            final success = await RatingService.submitRating(
                              scheduleId: scheduleId,
                              rating: selectedRating,
                              comments: commentController.text.trim(),
                            );

                            if (success) {
                              Get.back();
                              Get.snackbar(
                                "Thank you!",
                                "Your rating has been submitted.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.withOpacity(0.95),
                                colorText: Colors.white,
                              );
                              controller.fetchTicket(widget.bookingId);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
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
      },
    );
  }
}
