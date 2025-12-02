import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/booking_controller.dart';
import '../../models/onboard_bus_model.dart';
import '../../widgets/custom_button.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final OnboardBus busData;
  final List<String> selectedSeats;
  final double farePerSeat; // 👈 yahi use karenge
  final DateTime travelDate;

  const PassengerDetailsScreen({
    super.key,
    required this.busData,
    required this.selectedSeats,
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

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    contactController.dispose();
    altContactController.dispose();
    emailController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }

  // ------------ VALIDATORS -------------
  String? _validateName(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return "Full name is required";
    if (value.length < 3) return "Name must be at least 3 characters";
    final regex = RegExp(r"^[a-zA-Z ]+$");
    if (!regex.hasMatch(value)) {
      return "Name should contain only alphabets";
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

  String? _validatePhone(String? v, {bool isRequired = true}) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) {
      if (isRequired) return "This field is required";
      return null;
    }
    final regex = RegExp(r'^[6-9][0-9]{9}$');
    if (!regex.hasMatch(value)) {
      return "Enter a valid 10 digit mobile number";
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
      return "$fieldName should contain only alphabets";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bus = widget.busData;

    // Source / Destination resolve (ye sirf display + API ke liye)
    final String source =
    bus.searchOrigin.isNotEmpty ? bus.searchOrigin : bus.route.startPoint;

    final String destination = bus.finalDestination.isNotEmpty
        ? bus.finalDestination
        : bus.searchDestination;

    final String safeSource =
    source.isNotEmpty ? source : bus.route.startPoint;
    final String safeDestination =
    destination.isNotEmpty ? destination : bus.searchDestination;

    /// ✅ Ab yaha koi distance-based calculation nahi –
    /// seedha SelectSeatsScreen se aaya hua per seat price use karenge
    final double legFarePerSeat = widget.farePerSeat;
    final double totalFare =
        legFarePerSeat * widget.selectedSeats.length.toDouble();

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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Summary
              Text(
                "$safeSource → $safeDestination",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo.shade900,
                ),
              ),

              const SizedBox(height: 4),
         Row(children: [
           Text(
             "Seats: ${widget.selectedSeats.join(", ")}",
             style: GoogleFonts.poppins(
               fontSize: 13,
               fontWeight: FontWeight.w600,
               color: Colors.green.shade700,
             ),
           ),

           const SizedBox(width:6),
           Text(
             "Total: ₹${totalFare.toStringAsFixed(0)}",
             style: GoogleFonts.poppins(
               fontSize: 13,
               fontWeight: FontWeight.w600,
               color: Colors.green.shade700,
             ),
           ),

         ],),
              const SizedBox(height: 20),

              // --- Form fields ---
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Primary Contact Number *",
                ),
                validator: (v) => _validatePhone(v, isRequired: true),
              ),
              const SizedBox(height: 18),

              TextFormField(
                maxLength: 10,
                controller: altContactController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Alternate Contact Number *",
                ),
                validator: (v) => _validatePhone(v, isRequired: true),
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                  backgroundColor: Colors.yellow.shade800,
                  text: "Confirm Booking",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bookingController.bookTicket(
                        passengerName: nameController.text.trim(),
                        age: int.parse(ageController.text.trim()),
                        contactNumber: contactController.text.trim(),
                        altContactNumber:
                        altContactController.text.trim(),
                        gender: gender ?? '',
                        email: emailController.text.trim(),
                        city: cityController.text.trim(),
                        state: stateController.text.trim(),
                        scheduleId: widget.busData.id,
                        source: safeSource,
                        destination: safeDestination,
                        fare: totalFare, // ✅ yahi final total fare
                        travelDate:
                        widget.travelDate.toIso8601String(),
                        seats: widget.selectedSeats,
                      );
                    } else {
                      Get.snackbar(
                        "Invalid details",
                        "Please fix the errors in the form",
                        snackPosition: SnackPosition.BOTTOM,
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
