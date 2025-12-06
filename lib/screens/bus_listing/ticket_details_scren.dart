import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/ticket_details_controller.dart';
import '../../models/ticket.dart';
import '../../serives/rating_services.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String bookingId;
  final bool openRatingDirectly;
  final String? ratingId;

  const TicketDetailsScreen({
    super.key,
    required this.bookingId,
    this.openRatingDirectly = false, this.ratingId,
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
    print("✅ PASSED ratingId from previous screen = ${widget.ratingId}");

    ever(controller.ticket, (ticket) {
      if (ticket == null) return;

      final status = ticket.bookingDetails.status.toLowerCase();
      final ticketRatingId = ticket.ratingId;

      final bool isConfirmed = status == "confirmed";

      if (_hasShownRatingDialog || ticketRatingId != null && ticketRatingId.isNotEmpty) return;

      if (isConfirmed) {
        _hasShownRatingDialog = true;

        Future.delayed(const Duration(milliseconds: 300), () {
          _showRatingOrEditDialog(ticket);
        });
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


  void _showRatingOrEditDialog(Ticket ticket) async {
    final status = ticket.bookingDetails.status.toLowerCase();
    final String? ratingId = widget.ratingId;

    if (status != "confirmed" ) return;

    int selectedRating = 1;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                ratingId == null ? "Rate Your Ride" : "Edit Rating",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return IconButton(
                        onPressed: () =>
                            setStateDialog(() => selectedRating = starIndex),
                        icon: Icon(
                          starIndex <= selectedRating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: Colors.orange,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Comments",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool success = false;


                    if (ratingId != null && ratingId.isNotEmpty) {
                      success = await RatingService.updateRating(
                        ratingId: ratingId,
                        rating: selectedRating,
                        comments: commentController.text.trim(),
                      );
                    }


                    else {
                      final newRatingId = await RatingService.submitRating(
                        scheduleId: ticket.scheduleId,
                        rating: selectedRating,
                        comments: commentController.text.trim(),
                      );

                      success = newRatingId != null;
                    }

                    if (success) {
                      Navigator.pop(context);

                      Get.snackbar(
                        "Success",
                        ratingId == null
                            ? "Rating submitted successfully!"
                            : "Rating updated successfully!",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,

                      );

                      controller.fetchTicket(widget.bookingId); // ✅ REFRESH
                    } else {
                      Get.snackbar(
                        "Error",
                        "Something went wrong. Try again.",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: Text(ratingId == null ? "Submit" : "Update"), // ✅ AUTO TEXT
                ),
              ],
            );
          },
        );
      },
    );
  }

}
