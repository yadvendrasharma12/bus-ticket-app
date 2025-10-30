import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent, // 👈 ye zaruri hai
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        automaticallyImplyLeading: false,
        title: Text(
          "Privacy Policy",
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
              "This Privacy Policy explains how we collect, use, and protect your personal information when you use our bus booking application. By using SLTB Express, you agree to the terms described in this policy.",
              style: GoogleFonts.poppins(
                color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 20),

            _sectionTitle("1. Information We Collect"),
            _sectionText(
              "• Personal details such as your name, email address, and phone number when you register or book a ticket.\n"
                  "• Payment information such as credit/debit card details (processed securely through our payment partner).\n"
                  "• Location data when you use features like ‘Find Nearby Bus’ (with your consent).\n"
                  "• Device and usage information for improving app performance and user experience.",
            ),

            _sectionTitle("2. How We Use Your Information"),
            _sectionText(
              "• To process and confirm your bus bookings.\n"
                  "• To send booking confirmations, updates, or cancellations.\n"
                  "• To provide customer support and improve our services.\n"
                  "• To send promotional messages (only if you opt-in).",
            ),

            _sectionTitle("3. Data Security"),
            _sectionText(
              "We implement industry-standard security practices to protect your information from unauthorized access, misuse, or disclosure. "
                  "Your payment information is handled through secure, encrypted gateways — we do not store card details on our servers.",
            ),

            _sectionTitle("4. Data Sharing"),
            _sectionText(
              "We do not sell or rent your data. Information may be shared only with:\n"
                  "• Bus operators for booking confirmation.\n"
                  "• Trusted third-party payment processors.\n"
                  "• Legal authorities if required by law.",
            ),

            _sectionTitle("5. Your Rights"),
            _sectionText(
              "You have the right to:\n"
                  "• Access or update your account information.\n"
                  "• Delete your account permanently.\n"
                  "• Withdraw consent for receiving promotional messages.",
            ),

            _sectionTitle("6. Changes to This Policy"),
            _sectionText(
              "We may update this Privacy Policy from time to time. Any changes will be reflected on this page with an updated date.",
            ),

            _sectionTitle("7. Contact Us"),
            _sectionText(
              "If you have any questions or concerns about this Privacy Policy, please contact our support team at:\n"
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
          fontWeight: FontWeight.w700,
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
        color: Colors.black,
        fontWeight: FontWeight.w500,
        height: 1.6,
      ),
    );
  }
}
