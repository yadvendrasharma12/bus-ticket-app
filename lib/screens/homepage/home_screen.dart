import 'package:bus_booking_app/screens/bus_listing/bus_listing_screen.dart';
import 'package:bus_booking_app/widgets/custom_button.dart';
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

  // ✅ Added controllers for From and To fields
  final TextEditingController fromController = TextEditingController(text: "Madara");
  final TextEditingController toController = TextEditingController(text: "Colombo");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: Colors.indigo),
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
            const SizedBox(height: 14),

            // ---- Top Date Cards ----
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

            // ---- Payment Section ----
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 7),
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
              height: 60,
              width: double.infinity,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Awaiting payment",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "1350.00 LKR",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 45),

            // ---- Find a bus ----
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: 450,
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
                                "Madara",
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
                                "Colombo",
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
                        Row(
                          children: [
                            _buildSelectableChip("Today"),
                            _buildSelectableChip("Tomorrow"),
                            GestureDetector(
                              onTap: () => _pickDate(context),
                              child: Container(
                                height: 50,
                                width: 125,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.indigo.shade900),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    backgroundColor: Colors.yellow.shade800,
                    text: "Let's check!",
                    onPressed: () {
                      Get.to(BusListingScreen());
                    },
                  ),
                ],
              ),
            ),
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
          )
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
  Widget _customTextField(String label, String hint,
      {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.indigo.shade900,
          ),
        ),
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
            style: GoogleFonts.poppins(
              color: Colors.indigo.shade900,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
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
}
