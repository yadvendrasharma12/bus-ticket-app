import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final String companyName = "GR Tour & Travel";
  final String contactNumber = "+91 9876543210";
  final String whatsappNumber = "+91 9876543210";

  final TextEditingController addressLineController =
  TextEditingController(text: "123, Tech Park Building");
  final TextEditingController cityController =
  TextEditingController(text: "New Delhi");
  final TextEditingController stateController =
  TextEditingController(text: "Delhi");
  final TextEditingController pinCodeController =
  TextEditingController(text: "110001");

  final String facebookUrl = "https://facebook.com";
  final String instagramUrl = "https://instagram.com";
  final String youtubeUrl = "https://youtube.com";
  final String xUrl = "https://x.com";
  final String linkedinUrl = "https://linkedin.com";
  final String mediaUrl = "https://whatsapp.com";

  // 📞 Call
  Future<void> _makePhoneCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  // 💬 WhatsApp
  Future<void> _openWhatsApp(String number) async {
    final Uri url = Uri.parse("https://wa.me/${number.replaceAll('+', '')}");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not open WhatsApp';
    }
  }

  // 🌐 Open Social Link
  Future<void> _openLink(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $link';
    }
  }

  // ✅ Validation methods
  bool _isValidCity(String city) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(city);
  bool _isValidState(String state) => RegExp(r'^[a-zA-Z\s]+$').hasMatch(state);
  bool _isValidPin(String pin) => RegExp(r'^[0-9]{6}$').hasMatch(pin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Contact Support",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 🏢 Company Name
            Center(
              child: Text(
                companyName,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 25),

            // ☎️ Contact Number
            _buildContactRow(
              title: "Contact Number",
              value: contactNumber,
              icon: Icons.call,
              buttonText: "Call",
              onPressed: () => _makePhoneCall(contactNumber),
            ),
            const Divider(),

            // 💬 WhatsApp Number
            _buildContactRow(
              title: "WhatsApp Number",
              value: whatsappNumber,
              icon: FontAwesomeIcons.whatsapp,
              buttonText: "Chat",
              buttonColor: Colors.green,
              onPressed: () => _openWhatsApp(whatsappNumber),
            ),
            const Divider(height: 30),

            // 📍 Address Section
            Text(
              "Address Details",
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildInputField(
              "Address Line 1",
              controller: addressLineController,
              hint: "Enter address (letters, numbers, symbols)",
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,.-/]'))
              ],
            ),
            const SizedBox(height: 10),

            _buildInputField(
              "State",
              controller: stateController,
              hint: "Enter state (letters only)",
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
              ],
              validator: _isValidState,
            ),
            const SizedBox(height: 10),

            _buildInputField(
              "City",
              controller: cityController,
              hint: "Enter city (letters only)",
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
              ],
              validator: _isValidCity,
            ),
            const SizedBox(height: 10),

            _buildInputField(
              "Pincode",
              controller: pinCodeController,
              hint: "Enter 6-digit pincode",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              validator: _isValidPin,
            ),
            const Divider(height: 30),

            // 🌐 Social Media
            Text(
              "Follow us on",
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.center,
              child: Wrap(
                spacing: 20,
                runSpacing: 15,
                children: [
                  _socialButton("Facebook", facebookUrl, Colors.blueAccent,
                      FontAwesomeIcons.facebook),
                  _socialButton("Instagram", instagramUrl, Colors.indigo.shade800,
                      FontAwesomeIcons.instagram),
                  _socialButton("YouTube", youtubeUrl, Colors.red,
                      FontAwesomeIcons.youtube),
                  _socialButton("X", xUrl, Colors.pink,
                      FontAwesomeIcons.xbox),
                  _socialButton("LinkedIn", linkedinUrl, Colors.blue,
                      FontAwesomeIcons.linkedin),
                  _socialButton("WhatsApp", mediaUrl, Colors.green,
                      FontAwesomeIcons.whatsapp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Contact Row Widget
  Widget _buildContactRow({
    required String title,
    required String value,
    required IconData icon,
    required String buttonText,
    required VoidCallback onPressed,
    Color buttonColor = Colors.indigo,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: buttonColor, size: 28),
      title: Text(title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 15)),
      trailing: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(buttonText,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
      ),
    );
  }

  // 🧩 Address Field Widget
  Widget _buildInputField(
      String label, {
        required TextEditingController controller,
        required String hint,
        required TextInputType keyboardType,
        required List<TextInputFormatter> inputFormatters,
        bool Function(String)? validator,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: (value) {
            if (validator != null && !validator(value)) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text("Invalid $label entered."),
              ));
            }
          },
        ),
      ],
    );
  }

  // 🧩 Social Button Widget
  Widget _socialButton(
      String name, String link, Color color, IconData icon) {
    return InkWell(
      onTap: () => _openLink(link),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(name,
                style: GoogleFonts.poppins(
                    color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
