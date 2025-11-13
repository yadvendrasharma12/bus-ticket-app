import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../models/onboard_bus_model.dart';
import '../../widgets/custom_button.dart';
import '../pesenger_details/pasenger_details_screen.dart';

class SelectSeatsScreen extends StatefulWidget {
  final OnboardBus busData;

  const SelectSeatsScreen({super.key, required this.busData});

  @override
  State<SelectSeatsScreen> createState() => _SelectSeatsScreenState();
}

class _SelectSeatsScreenState extends State<SelectSeatsScreen> {
  List<String> serverBookedSeats = [];
  final List<String> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    fetchBookedSeats();


  }

  Future<void> fetchBookedSeats() async {
    try {
      final scheduleId = widget.busData.id;
      final url = Uri.parse("https://fleetbus.onrender.com/api/bookings/bookedSeats/$scheduleId");
      final response = await http.get(url, headers: {"Authorization": "Bearer ${Get.find<String>()}"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          serverBookedSeats = List<String>.from(data['bookedSeats']);
        });
      } else {
        Get.snackbar("Error", "Failed to fetch booked seats");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bus = widget.busData;

    List<String> seatLabels = [];
    const rows = 8;
    const seatsPerRow = 4;
    for (int i = 0; i < rows; i++) {
      seatLabels.addAll(["${i + 1}A", "${i + 1}B", "${i + 1}C", "${i + 1}D"]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(bus.bus?.busName ?? "Select Seats", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(bus.route.name.isNotEmpty ? "Route: ${bus.route.name}" : "No Route Info", style: GoogleFonts.poppins(fontSize: 15, color: Colors.indigo.shade900)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: rows,
                itemBuilder: (context, rowIndex) {
                  final seatRow = seatLabels.skip(rowIndex * seatsPerRow).take(seatsPerRow).toList();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: seatRow.map((seatNo) {
                        final isBooked = serverBookedSeats.contains(seatNo);
                        final isSelected = selectedSeats.contains(seatNo);
                        return GestureDetector(
                          onTap: () {
                            if (isBooked) return;
                            setState(() {
                              isSelected ? selectedSeats.remove(seatNo) : selectedSeats.add(seatNo);
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isBooked ? Colors.grey.shade400 : isSelected ? Colors.green : Colors.white,
                              border: Border.all(color: isBooked ? Colors.grey : Colors.indigo, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(seatNo, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: isBooked ? Colors.black54 : Colors.indigo.shade900)),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              backgroundColor: Colors.yellow.shade800,
              text: "Continue",
              onPressed: () {
                if (selectedSeats.isEmpty) {
                  Get.snackbar("Error", "Please select at least one seat");
                } else {
                  Get.to(() => PassengerDetailsScreen(busData: widget.busData, selectedSeats: selectedSeats));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
