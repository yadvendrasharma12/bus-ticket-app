// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../controllers/booking_controller.dart';
// import '../../models/onboard_bus_model.dart';
// import '../../models/upcomming_modal.dart';
// import '../../widgets/custom_button.dart';
//
// class PassengerDetailsScreen extends StatefulWidget {
//   final OnboardBus busData;
//   final List<String> selectedSeats;
//   final double farePerSeat;
//   final DateTime travelDate;
//
//
//   const PassengerDetailsScreen({
//     super.key,
//     required this.busData,
//     required this.selectedSeats,
//     required this.farePerSeat,
//     required this.travelDate,
//   });
//
//   @override
//   State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
// }
//
// class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final bookingController = Get.find<BookingController>();
//
//   final nameController = TextEditingController();
//   final ageController = TextEditingController();
//   final contactController = TextEditingController();
//   final altContactController = TextEditingController();
//   final emailController = TextEditingController();
//   final cityController = TextEditingController();
//   final stateController = TextEditingController();
//   String? gender;
//
//   // ------------ VALIDATORS -------------
//
//   String? _validateName(String? v) {
//     final value = v?.trim() ?? '';
//     if (value.isEmpty) return "Name is required";
//     if (value.length < 3) return "Name must be at least 3 characters";
//     final regex = RegExp(r"^[a-zA-Z ]+$");
//     if (!regex.hasMatch(value)) {
//       return "Name should contain only letters";
//     }
//     return null;
//   }
//
//   String? _validateAge(String? v) {
//     final value = v?.trim() ?? '';
//     if (value.isEmpty) return "Age is required";
//     final age = int.tryParse(value);
//     if (age == null) return "Age must be a number";
//     if (age < 1 || age > 120) return "Enter a valid age";
//     return null;
//   }
//
//   String? _validatePhoneRequired(String? v) {
//     final value = v?.trim() ?? '';
//     if (value.isEmpty) return "Contact number is required";
//     final regex = RegExp(r'^[0-9]{10}$');
//     if (!regex.hasMatch(value)) {
//       return "Enter a valid 10 digit number";
//     }
//     return null;
//   }
//
//   String? _validatePhoneOptional(String? v) {
//     final value = v?.trim() ?? '';
//     if (value.isEmpty) return null; // optional
//     final regex = RegExp(r'^[0-9]{10}$');
//     if (!regex.hasMatch(value)) {
//       return "Enter a valid 10 digit number";
//     }
//     return null;
//   }
//
//   String? _validateEmail(String? v) {
//     final value = v?.trim() ?? '';
//     if (value.isEmpty) return null; // optional
//     final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
//     if (!regex.hasMatch(value)) {
//       return "Enter a valid email address";
//     }
//     return null;
//   }
//
//   String? _validateCityOrState(String? v, String fieldName) {
//     final value = v?.trim() ?? '';
//     if (value.isEmpty) return "$fieldName is required";
//     if (value.length < 3) return "$fieldName must be at least 3 characters";
//     final regex = RegExp(r"^[a-zA-Z ]+$");
//     if (!regex.hasMatch(value)) {
//       return "$fieldName should contain only letters";
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bus = widget.busData;
//
//     // ✅ Source / Destination resolve (RouteData.finalDestination hata diya)
//     final String source =
//     bus.searchOrigin.isNotEmpty ? bus.searchOrigin : bus.route.startPoint;
//
//     final String destination = bus.finalDestination.isNotEmpty
//         ? bus.finalDestination
//         : bus.searchDestination;
//
//     // Extra safety (agar kuch bhi empty ho)
//     final String safeSource =
//     source.isNotEmpty ? source : bus.route.startPoint;
//     final String safeDestination =
//     destination.isNotEmpty ? destination : bus.searchDestination;
//
//     final double totalFare =
//         widget.farePerSeat * widget.selectedSeats.length.toDouble();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Passenger Details",
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.indigo),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Full Name
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelText: "Full Name",
//                 ),
//                 validator: _validateName,
//               ),
//               const SizedBox(height: 18),
//
//               // Age
//               TextFormField(
//                 controller: ageController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelText: "Age",
//                 ),
//                 validator: _validateAge,
//               ),
//               const SizedBox(height: 18),
//
//               // Contact Number
//               TextFormField(
//                 maxLength: 10,
//                 controller: contactController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   counterText: '',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelText: "Contact Number",
//                 ),
//                 validator: _validatePhoneRequired,
//               ),
//               const SizedBox(height: 18),
//
//               // Alternate Contact (optional)
//               TextFormField(
//                 maxLength: 10,
//                 controller: altContactController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   counterText: '',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelText: "Alternate Contact (optional)",
//                 ),
//                 validator: _validatePhoneOptional,
//               ),
//               const SizedBox(height: 18),
//
//               // Email (optional)
//               TextFormField(
//                 controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelText: "Email",
//                 ),
//                 validator: _validateEmail,
//               ),
//               const SizedBox(height: 18),
//
//               // City
//               TextFormField(
//                 controller: cityController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelText: "City",
//                 ),
//                 validator: (v) => _validateCityOrState(v, "City"),
//               ),
//               const SizedBox(height: 18),
//
//               // State
//               TextFormField(
//                 controller: stateController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelText: "State",
//                 ),
//                 validator: (v) => _validateCityOrState(v, "State"),
//               ),
//               const SizedBox(height: 18),
//
//               // Gender
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelText: "Gender",
//                 ),
//                 value: gender,
//                 items: ["Male", "Female", "Other"]
//                     .map(
//                       (g) => DropdownMenuItem(
//                     value: g,
//                     child: Text(g),
//                   ),
//                 )
//                     .toList(),
//                 onChanged: (val) => setState(() => gender = val),
//                 validator: (v) => v == null ? "Select gender" : null,
//               ),
//
//
//
//               const SizedBox(height: 30),
//
//
//               Obx(
//                     () => bookingController.isLoading.value
//                     ? const CircularProgressIndicator()
//                     : CustomButton(
//                   backgroundColor: Colors.yellow.shade800,
//                   text: "Confirm Booking",
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       // Debug prints
//                       print(
//                           "🔍 searchOrigin: ${widget.busData.searchOrigin}");
//                       print(
//                           "🔍 route.startPoint: ${widget.busData.route.startPoint}");
//                       print(
//                           "🔍 finalDestination: ${widget.busData.finalDestination}");
//                       print(
//                           "🔍 searchDestination: ${widget.busData.searchDestination}");
//
//                       bookingController.bookTicket(
//                         passengerName: nameController.text,
//                         age: int.parse(ageController.text),
//                         contactNumber: contactController.text,
//                         altContactNumber: altContactController.text,
//                         gender: gender ?? '',
//                         email: emailController.text,
//                         city: cityController.text,
//                         state: stateController.text,
//                         scheduleId: widget.busData.id,
//                         source: safeSource,
//                         destination: safeDestination,
//                         fare: widget.farePerSeat *
//                             widget.selectedSeats.length,
//                         travelDate:
//                         widget.travelDate.toIso8601String(),
//                         seats: widget.selectedSeats,
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/booking_controller.dart';
import '../../models/onboard_bus_model.dart';
import '../../widgets/custom_button.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final OnboardBus busData;
  final List<String> selectedSeats;
  final double farePerSeat;
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

    final String source =
    bus.searchOrigin.isNotEmpty ? bus.searchOrigin : bus.route.startPoint;

    final String destination = bus.finalDestination.isNotEmpty
        ? bus.finalDestination
        : bus.searchDestination;

    final String safeSource =
    source.isNotEmpty ? source : bus.route.startPoint;
    final String safeDestination =
    destination.isNotEmpty ? destination : bus.searchDestination;

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
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$safeSource → $safeDestination",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Seats: ${widget.selectedSeats.join(", ")}  |  Total Fare: ₹$totalFare",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),

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

              // Alternate Contact (also mandatory as per your request)
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

              // Email (mandatory now)
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

              // City
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

              // State
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

              // Gender
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

              // Confirm Button
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
                        fare: totalFare,
                        travelDate:
                        widget.travelDate.toIso8601String(),
                        seats: widget.selectedSeats,
                      );
                    } else {
                      // Optional: auto-scroll to first error
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
