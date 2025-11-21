import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isLoading = true; // start with loading

  @override
  void initState() {
    super.initState();
    // Simulate loading delay (e.g., fetching from API)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // stop loading after delay
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
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
              "Last Updated: November 2025",
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
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
              "GR Tour & Travel (“we”, “our”, “us”) is committed to protecting your personal data and ensuring a safe user experience. "
                  "This Privacy Policy explains how we collect, use, store, and protect your information when you use our mobile application.",
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.6),
            ),
            const SizedBox(height: 20),

            _sectionTitle("1. Information We Collect"),
            _sectionText(
              "We collect the following types of information:\n"
                  "• Personal Information: Name, Email, Phone number (if required), Login credentials.\n"
                  "• Location Information: Pickup point, Destination, Live or approximate location (only if enabled by user).\n"
                  "• Usage Data: App activity, Selected route, Ticket details, Interactions with driver/contact feature.\n"
                  "• Device Information: Device type, Operating system, IP address.",
            ),

            _sectionTitle("2. How We Use Your Information"),
            _sectionText(
              "We use your information to:\n"
                  "• Create and manage your user account.\n"
                  "• Show available bus routes and timings.\n"
                  "• Confirm and manage ticket bookings.\n"
                  "• Allow you to contact the driver.\n"
                  "• Enhance app performance and security.\n"
                  "• Improve our services and customer experience.\n"
                  "• Provide customer support.",
            ),

            _sectionTitle("3. Payment Information"),
            _sectionText(
              "GR Tour & Travel does not collect or process digital payments inside the app. "
                  "All payments are made directly to the driver at the time of boarding. "
                  "We do not store any card, wallet, or banking details.",
            ),

            _sectionTitle("4. Sharing Your Information"),
            _sectionText(
              "We may share limited information with:\n"
                  "• Drivers, so they can contact you and manage pickups.\n"
                  "• Service providers who help us operate the app (analytics, servers, etc.).\n"
                  "We do not sell, rent, or trade your personal data with third parties.",
            ),

            _sectionTitle("5. Data Security"),
            _sectionText(
              "We use industry-standard measures to protect your data, including:\n"
                  "• Encrypted passwords\n"
                  "• Secure servers\n"
                  "• Limited data access controls\n"
                  "However, no system is 100% secure. By using our app, you accept this risk.",
            ),

            _sectionTitle("6. Data Retention"),
            _sectionText(
              "We retain your information as long as your account is active or as needed to provide services. "
                  "You may request account deletion anytime.",
            ),

            _sectionTitle("7. Children’s Privacy"),
            _sectionText(
              "Our app is not intended for children under 13 years. "
                  "We do not knowingly collect information from children.",
            ),

            _sectionTitle("8. Your Rights"),
            _sectionText(
              "You may request:\n"
                  "• Access to your data\n"
                  "• Correction or updates\n"
                  "• Account deletion\n"
                  "For any privacy-related request, contact us at:\n"
                  "📩 support@grtourtravel.com",
            ),

            _sectionTitle("9. Changes to Privacy Policy"),
            _sectionText(
              "We may update this Privacy Policy from time to time. Continued use of the app means you accept the updated policy.",
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
