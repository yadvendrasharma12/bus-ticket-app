import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/booking_controller.dart';
import '../../models/onboard_bus_model.dart';
import '../../widgets/custom_button.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final OnboardBus busData;
  final List<String> selectedSeats;

  const PassengerDetailsScreen({
    super.key,
    required this.busData,
    required this.selectedSeats,
  });

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
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
  Widget build(BuildContext context) {
    final bus = widget.busData;

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
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: "Full Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: "Age"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: "Contact Number"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: altContactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: "Alternate Contact (optional)"),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: "Email"),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: "City"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: "State"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: "Gender"),
                value: gender,
                items: ["Male", "Female", "Other"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => gender = val),
                validator: (v) => v == null ? "Select gender" : null,
              ),
              const SizedBox(height: 40),


          Obx(() => bookingController.isLoading.value
              ? const CircularProgressIndicator()
              :CustomButton(
                backgroundColor: Colors.yellow.shade800,

                text: "Confirm Booking",

            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await bookingController.bookTicket(
                  passengerName: nameController.text.trim(),
                  age: int.parse(ageController.text.trim()),
                  contactNumber: contactController.text.trim(),
                  altContactNumber: altContactController.text.trim(),
                  gender: gender!,
                  email: emailController.text.trim(),
                  city: cityController.text.trim(),
                  state: stateController.text.trim(),

                  scheduleId: bus.id,
                  source: bus.route.startPoint,
                  destination: bus.route.finalDestination,
                  fare: (bus.pricing?.totalFare ?? 0).toDouble(),
                  travelDate: bus.date?.toIso8601String() ??
                      DateTime.now().toIso8601String(),
                  seats: widget.selectedSeats,
                );
              }
            },
              ),


          )],
          ),
        ),
      ),
    );
  }
}
