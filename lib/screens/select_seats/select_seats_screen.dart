import 'dart:convert';
import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:bus_booking_app/screens/pesenger_details/pasenger_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../models/onboard_bus_model.dart';
import '../../widgets/custom_button.dart';

class SelectSeatsScreen extends StatefulWidget {
  final OnboardBus busData;
  final Map<String, dynamic> rawBusJson;

  const SelectSeatsScreen({
    super.key,
    required this.busData,
    required this.rawBusJson,
  });

  @override
  State<SelectSeatsScreen> createState() => _SelectSeatsScreenState();
}

class _SelectSeatsScreenState extends State<SelectSeatsScreen> {
  List<String> serverBookedSeats = [];
  final List<String> selectedSeats = [];

  Map<String, dynamic> get _seatLayout {
    final dynamic seatLayout =
        widget.rawBusJson['bus']?['seatLayout'] ??
            widget.rawBusJson['busId']?['seatLayout'];

    if (seatLayout is Map<String, dynamic>) {
      return seatLayout;
    }

    return {'rows': 0, 'columns': 0, 'map': []};
  }

  @override
  void initState() {
    super.initState();
    fetchBookedSeats();
  }

  Future<void> fetchBookedSeats() async {
    try {
      final authController = Get.find<AuthController>();
      if (authController.token.isEmpty) await authController.loadToken();
      final token = authController.token.value;
      if (token.isEmpty) return;

      final scheduleId = widget.busData.id;
      final url = Uri.parse(
          "https://fleetbus.onrender.com/api/bookings/bookedSeats/$scheduleId");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          serverBookedSeats = List<String>.from(data['bookedSeats'] ?? []);
        });
      } else {
        setState(() {
          serverBookedSeats = [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching booked seats: $e");
    }
  }

  num _totalPrice() {
    final farePerSeat = widget.busData.bus?.fare?.toDouble() ??
        widget.busData.pricing?.totalFare.toDouble() ??
        0.0;
    return selectedSeats.length * farePerSeat;
  }

  @override
  Widget build(BuildContext context) {
    final bus = widget.busData;
    final layout = _seatLayout;
    final rows = layout['rows'] ?? 0;
    final cols = layout['columns'] ?? 0;
    final List<dynamic> map = layout['map'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          bus.bus?.busName ?? "Select Seats",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Route
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                bus.route.name.isNotEmpty
                    ? "Route: ${bus.route.name}"
                    : "Route information not available",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: bus.route.name.isNotEmpty
                      ? Colors.indigo.shade900
                      : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Selected seats
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Selected Seats: ${selectedSeats.length}    Total Price: ₹${_totalPrice()}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Seat layout
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, rowIndex) {
                  final rowSeats = rowIndex < map.length
                      ? map[rowIndex] as List<dynamic>
                      : [];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (colIndex) { // 4 columns fixed
                        Map<String, dynamic> seat = {};
                        if (colIndex < rowSeats.length) {
                          seat = rowSeats[colIndex] as Map<String, dynamic>;
                        }

                        final enabled = seat['enabled'] ?? false;
                        final label = seat['seatLabel']?.toString() ?? '';
                        final isBooked = serverBookedSeats.contains(label);
                        final isSelected = selectedSeats.contains(label);

                        Color backgroundColor;
                        if (isBooked) {
                          backgroundColor = Colors.grey.shade400;
                        } else if (isSelected) {
                          backgroundColor = Colors.green;
                        } else if (!enabled) {
                          backgroundColor = Colors.grey.shade200;
                        } else {
                          backgroundColor = Colors.white;
                        }

                        return GestureDetector(
                          onTap: () {
                            if (!enabled || isBooked) return;
                            setState(() {
                              if (isSelected) {
                                selectedSeats.remove(label);
                              } else {
                                selectedSeats.add(label);
                              }
                            });
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                  color: isBooked ? Colors.grey : Colors.indigo,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              enabled ? label : "X",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isBooked
                                    ? Colors.black54
                                    : Colors.indigo.shade900,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            // Continue
            CustomButton(
              backgroundColor: Colors.yellow.shade800,
              text:
              "Continue (${selectedSeats.length} Seats | ₹${_totalPrice()})",
              onPressed: () {
                if (selectedSeats.isEmpty) {
                  Get.snackbar("Error", "Please select at least one seat");
                } else {
                  final double farePerSeat =
                      widget.busData.pricing?.totalFare.toDouble() ?? 0.0;
                  final DateTime travelDate =
                      widget.busData.date ?? DateTime.now();

                  Get.to(() => PassengerDetailsScreen(
                    busData: widget.busData,
                    selectedSeats: List<String>.from(selectedSeats),
                    farePerSeat: farePerSeat,
                    travelDate: travelDate,
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockedSeatBox() {
    return Container(
      width: 55,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "X",
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}
