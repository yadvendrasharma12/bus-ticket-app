import 'package:bus_booking_app/screens/bus_listing/ticket_details_scren.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/cancle_booking_controller.dart';
import '../../controllers/ticket_controller.dart';
import '../../serives/rating_services.dart';

class TicketBookingScreen extends StatefulWidget {
  const TicketBookingScreen({super.key});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  final TicketController controller = Get.put(TicketController());
  final CancelBookingController cancelController = Get.put(CancelBookingController());

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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.tickets[index];

            final status = ticket.status.toString().toLowerCase();
            final num rating = (ticket.rating ?? 0);

            final bool isCancelled = status == "cancelled" || status == "canceled";
            final bool isActive = status == "active";
            final bool isConfirmed = status == "confirmed";

            final bool canShowPostReviewButton = isConfirmed && (ticket.rating ?? 0) == 0;
            final bool canEditReviewButton = isConfirmed && (ticket.rating ?? 0) > 0;


            /// Active / Cancelled par Cancel Ticket
            final bool canShowCancelButton = isActive || isCancelled;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
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

                    // Buttons Row
                    Column(
                      children: [

                        Row(
                          children: [

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                        () => TicketDetailsScreen(
                                      bookingId: ticket.bookingId,
                                      openRatingDirectly: true,
                                          ratingId: ticket.ratingId,

                                    ),
                                  );
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

                            // Middle Button Logic
                            if (canShowPostReviewButton || canEditReviewButton) ...[
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Post ya Edit dono yahi function se handle hoga
                                    _showEditRatingDialog(ticket);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: canShowPostReviewButton
                                        ? Colors.green.shade700
                                        : Colors.blue.shade700,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    canShowPostReviewButton ? "Post Review" : "Edit Review",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ] else if (canShowCancelButton) ...[
                              // Cancel Ticket button
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _handleCancelBooking(ticket);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade700,
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
                            ] else
                              const SizedBox.shrink(), // Hide middle button

                            const SizedBox(width: 8),

                            // Call bus staff - hamesha
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final phoneNumber = ticket.driverNumber;

                                  if (phoneNumber != null && phoneNumber.isNotEmpty) {
                                    _callBusStaff(phoneNumber);
                                  } else {
                                    Get.snackbar(
                                      "Not Available",
                                      "Driver number not available",
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
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
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Time column
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

  // Cancel booking dialog
  void _handleCancelBooking(dynamic ticket) {
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
            decoration: const InputDecoration(
              hintText: "Enter cancellation reason",
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

                  cancelController.cancelBooking(ticket.bookingId, reason).then((_) {
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

  // Call bus staff
  void _callBusStaff(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot make a call")),
      );
    }
  }


  void _showEditRatingDialog(dynamic ticket) async {
    if (ticket.ratingId == null) return;


    int selectedRating = 1;
    final commentController = TextEditingController();


    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                "Edit Rating",
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
                        onPressed: () => setStateDialog(() => selectedRating = starIndex),
                        icon: Icon(
                          starIndex <= selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    final success = await RatingService.updateRating(
                      ratingId: ticket.ratingId!,
                      rating: selectedRating,
                      comments: commentController.text.trim(),
                    );

                    if (success) {
                      Navigator.pop(context);
                      Get.snackbar(
                        "Success",
                        "Rating updated successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.95),
                        colorText: Colors.white,
                      );

                      // Refresh tickets if needed
                      controller.fetchTickets();
                    } else {
                      Get.snackbar(
                        "Error",
                        "Failed to update rating. Try again.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.95),
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }



}
