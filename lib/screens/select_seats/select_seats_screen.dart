import 'package:bus_booking_app/screens/pesenger_details/pasenger_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/onboard_bus_model.dart';
import '../../serives/booking_service.dart';
import '../../widgets/custom_button.dart';

class SelectSeatsScreen extends StatefulWidget {
  final OnboardBus busData;
  final Map<String, dynamic> rawBusJson;
  final Map<String, dynamic> onboardJson;
  final double farePerSeat; // 👈 yahi 223 aa raha hai

  const SelectSeatsScreen({
    super.key,
    required this.busData,
    required this.rawBusJson,
    required this.onboardJson,
    required this.farePerSeat,
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
    serverBookedSeats = List<String>.from(widget.busData.bookedSeats);
    _loadBookedSeats();
  }

  Future<void> _loadBookedSeats() async {
    final scheduleId = widget.busData.id;
    final seatsFromApi = await BookingService.fetchBookedSeats(scheduleId);

    if (!mounted) return;

    setState(() {
      serverBookedSeats = {
        ...serverBookedSeats,
        ...seatsFromApi,
      }.map((e) => e.trim().toUpperCase()).toSet().toList();
    });

    debugPrint("✅ Final booked seats in screen: $serverBookedSeats");
  }

  num _totalPrice() {
    final farePerSeat = widget.farePerSeat;
    return selectedSeats.length * farePerSeat;
  }

  @override
  Widget build(BuildContext context) {
    final bus = widget.busData;
    final layout = _seatLayout;
    final int rows = layout['rows'] ?? 0;
    final int cols = layout['columns'] ?? 0;
    final List<dynamic> map = layout['map'] ?? [];

    final double farePerSeat = widget.farePerSeat; // 👈 yehi aage pass hoga

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
            /// Route Name
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

            /// Fare per seat
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Fare per seat (segment): ₹${farePerSeat.toStringAsFixed(0)}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 4),

            /// Selected seats info
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Selected Seats: ${selectedSeats.length}    Total Price: ₹${_totalPrice().toStringAsFixed(0)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Seat layout
            Expanded(
              child: ListView.builder(
                itemCount: rows,
                itemBuilder: (context, rowIndex) {
                  final rowSeats = rowIndex < map.length
                      ? map[rowIndex] as List<dynamic>
                      : [];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(cols, (colIndex) {
                        Map<String, dynamic> seat = {};
                        if (colIndex < rowSeats.length) {
                          seat = rowSeats[colIndex] as Map<String, dynamic>;
                        }

                        final bool enabled = seat['enabled'] ?? false;
                        final String rawLabel =
                            seat['seatLabel']?.toString() ?? '';

                        final String label = rawLabel.trim().toUpperCase();

                        final bool isBooked =
                        serverBookedSeats.contains(label);

                        final bool isSelected =
                        selectedSeats.contains(label);

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
                            margin:
                            const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                color: isBooked
                                    ? Colors.grey
                                    : Colors.indigo,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              enabled ? rawLabel : "X",
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

            /// Continue Button
            CustomButton(
              backgroundColor: Colors.yellow.shade800,
              text: "Continue",
              onPressed: () {
                if (selectedSeats.isEmpty) {
                  Get.snackbar("Error", "Please select at least one seat");
                } else {
                  final DateTime travelDate =
                      widget.busData.date ?? DateTime.now();

                  Get.to(
                        () => PassengerDetailsScreen(
                      busData: widget.busData,
                      selectedSeats: List<String>.from(selectedSeats),
                      farePerSeat: farePerSeat,
                      travelDate: travelDate,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
