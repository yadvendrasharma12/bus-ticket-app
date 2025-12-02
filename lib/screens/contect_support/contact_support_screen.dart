import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/contect_info_model.dart';
import '../../serives/contect_service.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  bool isLoading = true;
  ContactInfo? contactInfo;

  // Example social URLs (replace with your API values)
  final String facebookUrl = "https://facebook.com";
  final String instagramUrl = "https://instagram.com";
  final String youtubeUrl = "https://youtube.com";
  final String xUrl = "https://x.com";
  final String linkedinUrl = "https://linkedin.com";
  final String mediaUrl = "https://wa.me/9876543210";

  @override
  void initState() {
    super.initState();
    _loadContactInfo();
  }

  Future<void> _loadContactInfo() async {
    final data = await ContactService.fetchContactInfo();
    setState(() {
      contactInfo = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (contactInfo == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load contact info")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text("Contact Support", style: GoogleFonts.poppins(
          color: Colors.white
        )),
        backgroundColor: Colors.indigo.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      contactInfo!.businessName,
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildContactRow(
                    title: "Phone",
                    value: contactInfo!.contactNumber,
                    icon: Icons.call,
                    buttonText: "Call",
                    onPressed: () => _makePhoneCall(contactInfo!.contactNumber),
                  ),
                  const Divider(),
                  _buildContactRow(
                    title: "WhatsApp",
                    value: contactInfo!.whatsappNumber,
                    icon: FontAwesomeIcons.whatsapp,
                    buttonText: "Chat",
                    buttonColor: Colors.green,
                    onPressed: () => _openWhatsApp(contactInfo!.whatsappNumber),
                  ),
                  const Divider(height: 30),
                  Text("Address Details",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildAddressField(
                      "Address Line 1", contactInfo!.address.addressLine1),
                  _buildAddressField("City", contactInfo!.address.city),
                  _buildAddressField("State", contactInfo!.address.state),
                  _buildAddressField("Pincode", contactInfo!.address.pincode),
                  _buildAddressField("Country", contactInfo!.address.country),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        double buttonWidth = (screenWidth - 60) / 3;

                        return Wrap(
                          spacing: 20,
                          runSpacing: 15,
                          alignment: WrapAlignment.center,
                          children: [
                            _socialButton("Facebook", facebookUrl,
                                Colors.blueAccent, FontAwesomeIcons.facebook, buttonWidth),
                            _socialButton("Instagram", instagramUrl,
                                Colors.indigo.shade800, FontAwesomeIcons.instagram, buttonWidth),
                            _socialButton("YouTube", youtubeUrl,
                                Colors.red, FontAwesomeIcons.youtube, buttonWidth),
                            _socialButton("X", xUrl,
                                Colors.black, FontAwesomeIcons.xTwitter, buttonWidth),
                            _socialButton("LinkedIn", linkedinUrl,
                                Colors.blue, FontAwesomeIcons.linkedin, buttonWidth),
                            _socialButton("WhatsApp", mediaUrl,
                                Colors.green, FontAwesomeIcons.whatsapp, buttonWidth),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(
      String name, String link, Color color, IconData icon, double width) {
    return InkWell(
      onTap: () => _openLink(link),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 15)),
      trailing: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(buttonText,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
      ),
    );
  }

  Widget _buildAddressField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  Future<void> _openWhatsApp(String number) async {
    final Uri url = Uri.parse("https://wa.me/${number.replaceAll('+', '')}");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) throw 'Could not open WhatsApp';
  }

  Future<void> _openLink(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) throw 'Could not launch $link';
  }
}
