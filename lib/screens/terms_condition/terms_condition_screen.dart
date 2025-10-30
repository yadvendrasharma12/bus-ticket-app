import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent, // 👈 ye zaruri hai
        elevation: 0,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Terms & Conditions",
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade900,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,

        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last updated: October 2025",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome to SLTB Express!",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Please read these Terms and Conditions carefully before using the SLTB Express bus booking app. By accessing or using this application, you agree to be bound by these terms.",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14, height: 1.6),
            ),

            _sectionTitle("1. Use of the Application"),
            _sectionText(
              "• You must be at least 18 years old to use this app.\n"
                  "• You agree to use this app only for lawful purposes such as booking bus tickets.\n"
                  "• You shall not use this app to post, share, or distribute any harmful or unauthorized content.",
            ),

            _sectionTitle("2. Booking & Payments"),
            _sectionText(
              "• All bus bookings are subject to seat availability and operator confirmation.\n"
                  "• Once payment is successfully made, a digital ticket will be issued.\n"
                  "• In case of cancellation or rescheduling, refund or changes will follow the bus operator’s policies.",
            ),

            _sectionTitle("3. Cancellations & Refunds"),
            _sectionText(
              "• Cancellation requests must be made before the scheduled departure time.\n"
                  "• Refunds will be processed after deducting applicable service or cancellation fees.\n"
                  "• No refunds will be given for ‘No Show’ passengers.",
            ),

            _sectionTitle("4. User Responsibilities"),
            _sectionText(
              "• Ensure all entered passenger details are accurate.\n"
                  "• Carry a valid ID proof during travel.\n"
                  "• Reach the boarding point at least 15 minutes before departure.",
            ),

            _sectionTitle("5. Limitation of Liability"),
            _sectionText(
              "SLTB Express acts as an online ticketing platform and is not responsible for bus operations, delays, or cancellations caused by the bus operator. "
                  "Our liability is limited to the value of the booking amount paid by the user.",
            ),

            _sectionTitle("6. Modifications to Service"),
            _sectionText(
              "We reserve the right to modify, suspend, or discontinue any part of the service at any time without prior notice.",
            ),

            _sectionTitle("7. Updates to Terms"),
            _sectionText(
              "We may update these Terms and Conditions from time to time. Continued use of the app after updates implies your acceptance of the new terms.",
            ),

            _sectionTitle("8. Contact Us"),
            _sectionText(
              "For any questions regarding these Terms & Conditions, please contact:\n"
                  "support@sltbexpress.com",
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                "© 2025 SLTB Express. All rights reserved.",
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
