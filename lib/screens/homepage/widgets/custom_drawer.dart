import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../bus_listing/bus_list_screen.dart';
import '../../contect_support/contact_support_screen.dart';
import '../../driver/driver_screen.dart';
import '../../privacy_policy/privacy_policy_screen.dart';
import '../../terms_condition/terms_condition_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: Colors.white,
      child: _drawer(width),
    );
  }

  Widget _drawer(double width) {
    return Column(
      children: [
        // 🟡 Profile Header
        Container(
          padding: const EdgeInsets.only(top: 70),
          height: 120,
          width: double.infinity,
          color: Colors.yellow.shade800,

        ),

        // 🟢 Drawer Menu
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 25),
            child: Column(
              children: [
                _drawerItem(Icons.policy_outlined, "Privacy Policy", () {
                  Get.to(() => const PrivacyPolicyScreen());
                }),
                _drawerItem(Icons.description, "Terms & Conditions", () {
                  Get.to(() => const TermsConditionScreen());
                }),
                _drawerItem(Icons.drive_eta, "Driver", () {
                  Get.to(() => const DriverScreen());
                }),
                _drawerItem(Icons.bus_alert_rounded, "Bus", () {
                  Get.to(() =>  BusListScreen());
                }),
                _drawerItem(CupertinoIcons.person_alt_circle, "Contact Support",
                        () {
                      Get.to(() => const ContactSupportScreen());
                    }),

                const SizedBox(height: 30),

                // 🔴 Logout
                GestureDetector(
                  onTap: () => authController.logout(),
                  child: Container(
                    height: 45,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Log Out",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
