import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:bus_booking_app/screens/auth/login/login_screen.dart';
import 'package:bus_booking_app/screens/bus_listing/bus_list_screen.dart';
import 'package:bus_booking_app/screens/bus_listing/bus_listing_screen.dart';
import 'package:bus_booking_app/screens/contect_support/contact_support_screen.dart';
import 'package:bus_booking_app/screens/driver/driver_screen.dart';
import 'package:bus_booking_app/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:bus_booking_app/screens/terms_condition/terms_condition_screen.dart';
import 'package:bus_booking_app/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedOption = "Today";
  DateTime? selectedDate;

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedOption = "";
        selectedDate = picked;
      });
    }
  }
final AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(backgroundColor: Colors.white, child: _drawer()),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu_rounded, color: Colors.indigo),
          ),
        ),
        title: Text(
          "SLTB EXPRESS",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.indigo[900],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Previous booking",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.indigo[900],
              ),
            ),
            const SizedBox(height: 26),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _dateCard("February", "12"),
                  _dateCard("January", "03"),
                  _dateCard("December", "24"),
                  _dateCard("November", "18"),
                  _dateCard("October", "05"),
                ],
              ),
            ),

             const SizedBox(height: 32),



            // ---- Find a bus ----
            Container(
              padding: const EdgeInsets.only(top: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ✅ auto height
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Let’s find a bus",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ✅ From and To Fields with Swap Button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: _customTextField(
                                "From",
                                controller: fromController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.swap_vert_rounded,
                                  color: Colors.indigo,
                                  size: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final temp = fromController.text;
                                    fromController.text = toController.text;
                                    toController.text = temp;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _customTextField(
                                "To",
                                controller: toController,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ✅ Custom Selectable Date Row
                        Text(
                          "Date",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildSelectableChip("Today"),
                              _buildSelectableChip("Tomorrow"),

                              GestureDetector(
                                onTap: () => _pickDate(context),
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.indigo.shade900),
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: selectedDate == null
                                        ? Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.indigo.shade900,
                                      size: 22,
                                    )
                                        : Text(
                                      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    backgroundColor: Colors.yellow.shade800,
                    text: "Let's check!",
                    onPressed: () {
                      Get.to(BusListScreen());
                    },
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  // ---- Reusable Widgets ----

  Widget _dateCard(String month, String day) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.only(left: 12, top: 6),
      width: 100,
      height: 125,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo.shade800),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            month,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.indigo[900],
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            day,
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.indigo[900],
            ),
          ),
          Text(
            "Maharashtra",
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Delhi",
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Updated to include controller
  Widget _customTextField(
    String hint, {
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            style: GoogleFonts.poppins(color: Colors.indigo.shade900),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: Colors.indigo.shade900.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableChip(String label) {
    bool isSelected = selectedOption == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = label;
          selectedDate = null;
        });
      },
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.indigo.shade900),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawer() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 70),
          height: 260,
          width: double.infinity,
          color: Colors.yellow.shade800,
          child: Column(
            children: [
              CircleAvatar(
                radius: 46,
                backgroundImage: NetworkImage(
                  "https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg?semt=ais_hybrid&w=740&q=80",
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Yadvendra Sharma",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 3),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "New delhi",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            children: [

              GestureDetector(
                onTap: () {
                  Get.to(PrivacyPolicyScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.policy_outlined),
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Privacy policy",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26),
              GestureDetector(
                onTap: () {
                  Get.to(TermsConditionScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_tennis),
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Terms & Condition",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26),
              GestureDetector(
                onTap: () {
                  Get.to(DriverScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.drive_eta),
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Driver",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26),
              GestureDetector(
                onTap: () {
                  Get.to(BusListScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.bus_alert_rounded),
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Bus",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26),
              GestureDetector(
                onTap: (){
                  Get.to(ContactSupportScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.person_alt_circle),
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Contact support",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: (){
                 authController.logout();
                },
                child: Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Log Out",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
