
import 'package:bus_booking_app/bottom_bar/bottom_nav_bar_screen.dart';
import 'package:bus_booking_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Success Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 25),

                // 🎉 Title
                Text(
                  "Booking Confirmed!",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade900,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Your ticket has been successfully booked.\n"
                      "If you’d like to view your booking details, please tap the button below.",
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),



                const SizedBox(height: 40),

               CustomButton(
                 backgroundColor: Colors.yellow.shade800,
                   text: "Check Ticket", onPressed: (){
                   Get.to(BottomNavBarScreen());
               })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade900),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
