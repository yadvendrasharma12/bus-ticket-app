import 'package:bus_booking_app/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:  Icon(Icons.arrow_back_ios,color: AppColors.textBlack,),
        ),
        title: Text(
          "Terms & Conditions",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme:  IconThemeData(color: Colors.indigo),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.indigo,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last updated: November 2025",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome to GR Tour & Travel!",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "By using our mobile application, you agree to the following Terms & Conditions. Please read them carefully.",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14,
                  height: 1.6),
            ),
            const SizedBox(height: 20),

            _sectionTitle("1. User Account"),
            _sectionText(
              "• Users must register with a valid email and password.\n"
                  "• You are responsible for maintaining account confidentiality.\n"
                  "• Any activity performed through your account will be considered your responsibility.",
            ),

            _sectionTitle("2. Use of the App"),
            _sectionText(
              "The GR Tour & Travel app allows you to:\n"
                  "• Search available routes and bus schedules\n"
                  "• Book tickets\n"
                  "• View bus timing, route, and driver details\n"
                  "• Contact the driver\n"
                  "• Make payment directly in the bus\n"
                  "You agree not to misuse the app or attempt unauthorized access.",
            ),

            _sectionTitle("3. Ticket Booking"),
            _sectionText(
              "• Booking a ticket through the app reserves your seat on the selected bus and route.\n"
                  "• Bookings are subject to bus availability and timing.\n"
                  "• You must reach the pickup location on time.\n"
                  "• The app only facilitates booking; actual travel is provided by the operator (driver/transport provider).",
            ),

            _sectionTitle("4. Payment Terms"),
            _sectionText(
              "• All payments must be made in the bus directly to the driver.\n"
                  "• The app does not support online payment.\n"
                  "• The driver or bus operator is responsible for issuing the ticket receipt (if applicable).",
            ),

            _sectionTitle("5. Cancellation & Refunds"),
            _sectionText(
              "• If you miss the bus or cancel, refunds are not guaranteed and depend on operator policies.\n"
                  "• GR Tour & Travel is not liable for refunds issued (or not issued) by drivers/operators.",
            ),

            _sectionTitle("6. Communication With Driver"),
            _sectionText(
              "You may contact the assigned driver only for:\n"
                  "• Pickup coordination\n"
                  "• Bus location\n"
                  "• Timing or route clarification\n"
                  "Misuse of driver contact details may lead to account suspension.",
            ),

            _sectionTitle("7. Travel Responsibility"),
            _sectionText(
              "GR Tour & Travel acts as a platform only.\n"
                  "We are not responsible for:\n"
                  "• Delays, route changes, or cancellations\n"
                  "• Driver behavior or service quality\n"
                  "• Lost items\n"
                  "• Accidents or travel-related incidents\n"
                  "All travel is at the user’s own risk.",
            ),

            _sectionTitle("8. Prohibited Activities"),
            _sectionText(
              "Users may not:\n"
                  "• Provide false booking information\n"
                  "• Harass drivers or other passengers\n"
                  "• Abuse or misuse the contact feature\n"
                  "• Attempt to hack, damage, or disrupt the app\n"
                  "Violation can result in immediate account termination.",
            ),

            _sectionTitle("9. Limitation of Liability"),
            _sectionText(
              "GR Tour & Travel is not responsible for:\n"
                  "• Technical errors\n"
                  "• Server issues\n"
                  "• App downtime\n"
                  "• Any indirect or incidental damages\n"
                  "Your use of the app is entirely at your own risk.",
            ),

            _sectionTitle("10. Termination of Service"),
            _sectionText(
              "We may suspend or terminate your account if:\n"
                  "• You violate these Terms\n"
                  "• You misuse the platform\n"
                  "• You engage in illegal activity using the app",
            ),

            _sectionTitle("11. Changes to Terms"),
            _sectionText(
              "We may update these Terms anytime. Continued use means you accept the updated terms.",
            ),

            _sectionTitle("12. Contact Us"),
            _sectionText(
              "For support or legal questions:\n"
                  "📩 support@grtourtravel.com",
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                "© 2025 GR Tour & Travel. All rights reserved.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.indigo.shade900,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.6,
      ),
    );
  }
}
