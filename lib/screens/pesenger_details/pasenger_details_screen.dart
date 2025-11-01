import 'package:bus_booking_app/screens/bus_listing/bus_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PassengerDetailsScreen extends StatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController altContactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.indigo.shade800),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Passenger Details",
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Passenger Name*", nameController, true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Passenger Name";
                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return "Name must contain only letters";
                      }
                      return null;
                    }),
                _buildTextField("Age*", ageController, true,
                    keyboardType: TextInputType.number, validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Age";
                      } else if (int.tryParse(value) == null) {
                        return "Enter a valid number";
                      }
                      return null;
                    }),
                _buildTextField("Contact Number*", contactController, true,
                    keyboardType: TextInputType.phone, validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Contact Number";
                      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return "Contact number must be 10 digits";
                      }
                      return null;
                    }),
                _buildTextField(
                    "Alt Contact Number (Optional)", altContactController, false,
                    keyboardType: TextInputType.phone, validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "Alt contact number must be 10 digits";
                  }
                  return null;
                }),
                const SizedBox(height: 10),
                Text("Gender*",
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Radio<String>(
                      value: "Male",
                      groupValue: gender,
                      activeColor: Colors.indigo.shade800,
                      onChanged: (val) => setState(() => gender = val),
                    ),
                    const Text("Male"),
                    Radio<String>(
                      value: "Female",
                      groupValue: gender,
                      activeColor: Colors.indigo.shade800,
                      onChanged: (val) => setState(() => gender = val),
                    ),
                    const Text("Female"),
                    Radio<String>(
                      value: "Other",
                      groupValue: gender,
                      activeColor: Colors.indigo.shade800,
                      onChanged: (val) => setState(() => gender = val),
                    ),
                    const Text("Other"),
                  ],
                ),
                _buildTextField("Email ID (Optional)", emailController, false,
                    keyboardType: TextInputType.emailAddress, validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          !RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    }),
                _buildTextField("City*", cityController, true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter City";
                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return "City name must contain only letters";
                      }
                      return null;
                    }),
                _buildTextField("State*", stateController, true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter State";
                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return "State name must contain only letters";
                      }
                      return null;
                    }),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (gender == null) {
                          Get.snackbar("Error", "Please select gender",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white);
                        } else {
                          _showCongratsPopup(context);
                        }
                      }
                    },
                    child: Text(
                      "Confirm Booking",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      bool required, {
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo.shade800),
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  void _showCongratsPopup(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 70),
              const SizedBox(height: 20),
              Text(
                "Congratulations!",
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                "Your booking has been confirmed successfully!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.back(); // close dialog
                  Get.offAll(BusListingScreen()); // navigate to tickets screen
                },
                child: Text(
                  "Go to My Tickets",
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
