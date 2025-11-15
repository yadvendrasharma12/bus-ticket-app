
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/ticket_controller.dart';
import '../../controllers/ticket_details_controller.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String bookingId;

  const TicketDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final TicketDetailsController controller = Get.put(TicketDetailsController());

    controller.fetchTicket(bookingId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket Details", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ticket Info

              _sectionTitle("🎟 Ticket Information"),
              _infoText("Booking ID", ticket.bookingId),
              _infoText("Reference", ticket.bookingReference),
              _infoText("Status", ticket.bookingDetails.status,
                color: ticket.bookingDetails.status.toLowerCase() == "active"
                    ? Colors.green
                    : Colors.red,
              ),
              _infoText("Seats", ticket.bookingDetails.seats.join(", ")),
              _infoText("Fare", "₹${ticket.bookingDetails.fare}"),
              const SizedBox(height: 20),

              // Passenger Info
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

              // Bus Info
              _sectionTitle("🚌 Bus Information"),
              _infoText("Bus Name", ticket.bus.busName),
              _infoText("Bus Number", ticket.bus.busNumber),
              _infoText("Seats Capacity", ticket.bus.seatCapacity.toString()),
              _infoText("AC Type", ticket.bus.acType),
              const SizedBox(height: 20),

              // Crew Info
              _sectionTitle("👨‍✈️ Bus Staff Information"),
              _infoText("Driver", ticket.crew.driverName),
              _infoText("Conductor", ticket.crew.conductorName),
              const SizedBox(height: 20),

              // Travel Info
              _sectionTitle("🛣 Travel Information"),
              _infoText("From", ticket.travel.source),
              _infoText("To", ticket.travel.destination),
              _infoText("Route", ticket.travel.routeName),
              _infoText("Departure", ticket.travel.departureTime),
              _infoText("Arrival", ticket.travel.arrivalTime),

              SizedBox(height: 30,)
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.indigo.shade900),
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
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black, // Use color if provided, else black
            ),
          ),
        ],
      ),
    );
  }

}

