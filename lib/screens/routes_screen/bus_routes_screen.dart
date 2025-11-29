


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/booking_controller.dart';

import '../../models/upcomming_modal.dart';
import '../../serives/bus_api_service.dart';
import '../../widgets/custom_button.dart';


class BusRoutesScreen extends StatelessWidget {
  final UpCommingBus busData;
  final Map<String, dynamic> rawBusJson;

  const BusRoutesScreen({
    super.key,
    required this.busData,
    required this.rawBusJson,
  });

  Future<void> _openSeatSelection(BuildContext context) async {
    final scheduleId = busData.id;

    final data = await BusApiService.fetchScheduleDetail(scheduleId);

    if (data == null) return;

    Get.to(
          () => SelectSeatsScreen(
        busData: busData,
        onboardJson: data,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (busData.route == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("View routes")),
        body: const Center(child: Text("Route data not available")),
      );
    }

    final route = busData.route!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          route.name.isNotEmpty ? route.name : "View routes",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.indigo.shade900,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: route.stops.length,
          itemBuilder: (context, index) {
            final stop = route.stops[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.indigo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Arrival: ${stop.arrivalTime}  |  Distance: ${stop.distanceFromStart} km",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          backgroundColor: Colors.yellow.shade800,
          text: "Book Ticket",
          onPressed: () => _openSeatSelection(context),
        ),
      ),
    );
  }
}


class SelectSeatsScreen extends StatefulWidget {
  final UpCommingBus busData;
  final Map<String, dynamic> onboardJson;

  const SelectSeatsScreen({
    super.key,
    required this.busData,
    required this.onboardJson,
  });

  @override
  State<SelectSeatsScreen> createState() => _SelectSeatsScreenState();
}

class _SelectSeatsScreenState extends State<SelectSeatsScreen> {
  List<String> serverBookedSeats = [];
  final List<String> selectedSeats = [];

  Map<String, dynamic> get _seatLayout {
    try {
      final busId = widget.onboardJson['busId'] as Map<String, dynamic>?;
      final layout = busId?['seatLayout'];
      if (layout != null) {
        final casted =
        Map<String, dynamic>.from(layout as Map<dynamic, dynamic>);
        debugPrint("✅ seatLayout from onboardJson: $casted");
        return casted;
      }
    } catch (e) {
      debugPrint("⚠️ Error reading seatLayout from onboardJson: $e");
    }

    debugPrint("❌ seatLayout not found in onboardJson");
    return {
      "rows": 0,
      "columns": 0,
      "map": [],
    };
  }

  @override
  void initState() {
    super.initState();
    _initBookedSeatsFromOnboard();
  }

  void _initBookedSeatsFromOnboard() {
    try {
      final booked = widget.onboardJson['bookedSeats'];
      if (booked is List) {
        serverBookedSeats = booked.map((e) => e.toString()).toList();
        debugPrint("🪑 bookedSeats from onboardJson: $serverBookedSeats");
      } else {
        serverBookedSeats = [];
      }
    } catch (e) {
      debugPrint("⚠️ Error reading bookedSeats from onboardJson: $e");
      serverBookedSeats = [];
    }
    setState(() {});
  }

  double _totalPrice() {
    final farePerSeat = widget.busData.pricing?.totalFare.toDouble() ?? 0.0;
    return selectedSeats.length * farePerSeat;
  }

  @override
  Widget build(BuildContext context) {
    final bus = widget.busData;
    final layout = _seatLayout;
    final int rows = layout['rows'] ?? 0;
    final int cols = layout['columns'] ?? 0;
    final List<dynamic> seatMap = layout['map'] ?? [];

    if (rows == 0 || cols == 0 || seatMap.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(bus.bus?.busName ?? "Select Seats"),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.indigo),
        ),
        body: const Center(
          child: Text(
            "Seat layout not configured for this bus.\nPlease contact admin.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(bus.bus?.busName ?? "Select Seats"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                bus.route?.name.isNotEmpty == true
                    ? "Route: ${bus.route!.name}"
                    : "Route info not available",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: bus.route?.name.isNotEmpty == true
                      ? Colors.indigo.shade900
                      : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 8),
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


            Expanded(
              child: ListView.builder(
                itemCount: rows,
                itemBuilder: (context, rowIndex) {
                  final rowSeats =
                  rowIndex < seatMap.length ? seatMap[rowIndex] as List : [];

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

                        final String displayLabel =
                            seat['seatLabel']?.toString() ?? '';

                        final String seatId = displayLabel;

                        final bool isValidSeat =
                            enabled && displayLabel.trim().isNotEmpty;

                        final bool isBooked =
                            isValidSeat && serverBookedSeats.contains(seatId);
                        final bool isSelected =
                            isValidSeat && selectedSeats.contains(seatId);

                        if (!isValidSeat) {
                          return Container(
                            width: 55,
                            height: 55,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }

                        Color bgColor;
                        if (isBooked) {
                          bgColor = Colors.grey.shade400;
                        } else if (isSelected) {
                          bgColor = Colors.green;
                        } else {
                          bgColor = Colors.white;
                        }

                        return GestureDetector(
                          onTap: () {
                            if (isBooked) return;
                            setState(() {
                              if (isSelected) {
                                selectedSeats.remove(seatId);
                              } else {
                                selectedSeats.add(seatId);
                              }
                            });

                            debugPrint(
                              "🖱️ Tapped => label: $displayLabel, seatId: $seatId, selected: $selectedSeats",
                            );
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bgColor,
                              border: Border.all(
                                color: isBooked ? Colors.grey : Colors.indigo,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              enabled ? displayLabel : "X",
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

            CustomButton(
              backgroundColor: Colors.yellow.shade800,
              text: "Continue",
              onPressed: () {
                if (selectedSeats.isEmpty) {
                  Get.snackbar("Error", "Please select at least one seat");
                  return;
                }

                final farePerSeat =
                    widget.busData.pricing?.totalFare.toDouble() ?? 0.0;
                final travelDate = widget.busData.date ?? DateTime.now();

                debugPrint(
                    "✅ Going to passenger screen with seats: $selectedSeats");

                Get.to(
                      () => PassengerDetailsScreen(
                    selectedSeats: List.from(selectedSeats),
                    busData: widget.busData,
                    farePerSeat: farePerSeat,
                    travelDate: travelDate,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// -------------------- PASSENGER DETAILS SCREEN --------------------

class PassengerDetailsScreen extends StatefulWidget {
  final List<String> selectedSeats; // FF, JK, JII ...
  final UpCommingBus busData;
  final double farePerSeat;
  final DateTime travelDate;

  const PassengerDetailsScreen({
    super.key,
    required this.selectedSeats,
    required this.busData,
    required this.farePerSeat,
    required this.travelDate,
  });

  @override
  State<PassengerDetailsScreen> createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final bookingController = Get.find<BookingController>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final contactController = TextEditingController();
  final altContactController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  String? gender;

  String? _validateName(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return "Name is required";
    if (value.length < 3) return "Name must be at least 3 characters";
    final regex = RegExp(r"^[a-zA-Z ]+$");
    if (!regex.hasMatch(value)) {
      return "Name should contain only letters";
    }
    return null;
  }

  String? _validateAge(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return "Age is required";
    final age = int.tryParse(value);
    if (age == null) return "Age must be a number";
    if (age < 1 || age > 120) return "Enter a valid age";
    return null;
  }

  String? _validatePhoneRequired(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return "Contact number is required";
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value)) {
      return "Enter a valid 10 digit number";
    }
    return null;
  }

  String? _validatePhoneOptional(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return "Alternate contact is required";
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value)) {
      return "Enter a valid 10 digit number";
    }
    return null;
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return "Email is required";
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? _validateCityOrState(String? v, String fieldName) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return "$fieldName is required";
    if (value.length < 3) return "$fieldName must be at least 3 characters";
    final regex = RegExp(r"^[a-zA-Z ]+$");
    if (!regex.hasMatch(value)) {
      return "$fieldName should contain only letters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bus = widget.busData;

    final String source = bus.searchOrigin.isNotEmpty
        ? bus.searchOrigin
        : (bus.route?.startPoint ?? '');

    final String destination = bus.finalDestination.isNotEmpty
        ? bus.finalDestination
        : bus.searchDestination;

    final String safeSource =
    source.isNotEmpty ? source : (bus.route?.startPoint ?? '');
    final String safeDestination = destination.isNotEmpty
        ? destination
        : (bus.route?.finalDestination ?? '');

    final double totalFare =
        widget.farePerSeat * widget.selectedSeats.length.toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Passenger Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // realtime
          child: Column(
            children: [



              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Full Name *",
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Age *",
                ),
                validator: _validateAge,
              ),
              const SizedBox(height: 18),

              TextFormField(
                maxLength: 10,
                controller: contactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Contact Number *",
                ),
                validator: _validatePhoneRequired,
              ),
              const SizedBox(height: 18),

              TextFormField(
                maxLength: 10,
                controller: altContactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Alternate Contact *",
                ),
                validator: _validatePhoneOptional,
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Email *",
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "City *",
                ),
                validator: (v) => _validateCityOrState(v, "City"),
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "State *",
                ),
                validator: (v) => _validateCityOrState(v, "State"),
              ),
              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Gender *",
                ),
                value: gender,
                items: ["Male", "Female", "Other"]
                    .map(
                      (g) => DropdownMenuItem(
                    value: g,
                    child: Text(g),
                  ),
                )
                    .toList(),
                onChanged: (val) => setState(() => gender = val),
                validator: (v) => v == null ? "Select gender" : null,
              ),

              const SizedBox(height: 30),

              Obx(
                    () => bookingController.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomButton(
                  backgroundColor: Colors.yellow.shade800,
                  text: "Confirm Booking",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      debugPrint("🔍 searchOrigin: ${bus.searchOrigin}");
                      debugPrint(
                          "🔍 route.startPoint: ${bus.route?.startPoint}");
                      debugPrint(
                          "🔍 finalDestination: ${bus.finalDestination}");
                      debugPrint(
                          "🔍 searchDestination: ${bus.searchDestination}");
                      debugPrint(
                          "🔍 FINAL SENDING SEATS (IDs): ${widget.selectedSeats}");

                      bookingController.bookTicket(
                        passengerName: nameController.text,
                        age: int.parse(ageController.text),
                        contactNumber: contactController.text,
                        altContactNumber: altContactController.text,
                        gender: gender ?? '',
                        email: emailController.text,
                        city: cityController.text,
                        state: stateController.text,
                        scheduleId: bus.id,
                        source: safeSource,
                        destination: safeDestination,
                        fare: totalFare,
                        travelDate:
                        widget.travelDate.toIso8601String(),
                        seats: widget.selectedSeats, // ["FF","JI","JK"...]
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
