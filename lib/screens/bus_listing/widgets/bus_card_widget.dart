import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/onboard_bus_model.dart';

class BusCardWidget extends StatelessWidget {
  final OnboardBus bus;
  final VoidCallback onTap;

  const BusCardWidget({
    super.key,
    required this.bus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Safe image handling
    final imageUrl = (bus.bus.frontImage != null &&
        bus.bus.frontImage!.trim().isNotEmpty)
        ? bus.bus.frontImage!
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image or Placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _placeholderImage(),
              )
                  : _placeholderImage(),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Bus Name & AC Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(bus.bus.busName,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo[900])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: bus.bus.acType.toLowerCase() == "ac"
                              ? Colors.indigo[100]
                              : Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          bus.bus.acType.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: bus.bus.acType.toLowerCase() == "ac"
                                ? Colors.indigo[900]
                                : Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 🔹 Route
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _routeText("From", bus.route.startPoint),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                      _routeText("To", bus.route.finalDestination),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Info Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _info(Icons.access_time, bus.time),
                      _info(Icons.route, "${bus.route.totalDistance} km"),
                      _info(Icons.timer, "${bus.route.estimatedTravelTime} min"),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 🔹 Seats and Fare
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Seats: ${bus.bus.seatCapacity}",
                          style: GoogleFonts.poppins(fontSize: 13)),
                      Text("Fare: ₹${bus.pricing.totalFare}",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Default placeholder for missing image
  Widget _placeholderImage() {
    return Container(
      height: 160,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.directions_bus, size: 50, color: Colors.white70),
      ),
    );
  }

  Widget _routeText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
      ],
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.indigo[800]),
        const SizedBox(width: 4),
        Text(text,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
