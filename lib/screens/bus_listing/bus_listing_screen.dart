import 'package:bus_booking_app/screens/select_seats/select_seats_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class BusListingScreen extends StatefulWidget {
  const BusListingScreen({super.key});

  @override
  State<BusListingScreen> createState() => _BusListingScreenState();
}

class _BusListingScreenState extends State<BusListingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> busList = [
    {
      "departure": "14:15",
      "arrival": "Starting",
      "duration": "19:30",
      "seats": "8 seats",
      "time": "4h 33m",
      "price": "1200.00",

    },
    {
      "departure": "16:45",
      "arrival": "Starting",
      "duration": "30:30",
      "seats": "12 seats ",
      "time": "7h 40m",
      "price": "950.00",
    },
    {
      "departure": "18:00",
      "arrival": "Starting",
      "duration": "10:15",
      "seats": "5 seats ",
      "time": "12h 3m",
      "price": "1000.00",
    },
    {
      "departure": "20:15",
      "arrival": "Starting",
      "duration": "23:45",
      "seats": "3 seats",
      "time": "4h 33m",
      "price": "1800.00",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // ✅ FIXED
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF5F7FA),

      appBar: AppBar(
        titleSpacing: 0,

        elevation: 0,
        backgroundColor: Colors.white,

        title: Container(
          margin: EdgeInsets.only(right: 10),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.indigo.shade900, width: 2),
          ),

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Colombo → Kandy , 23 Sep 2019",
              style: GoogleFonts.poppins(
                color: Colors.indigo.shade900,
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.indigo.shade900),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            indicatorColor: Colors.indigo.shade900,
            controller: _tabController,
            labelColor: Colors.indigo.shade900,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,

            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            tabs: const [
              Tab(text: "STANDARD"),
              Tab(text: "SEMI LUXURY"),
              Tab(text: "SUPER LUXURY"),
            ],
          ),
        ),
      ),

      // ---------- Body ----------
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBusList(),
                  _buildBusList(),
                  _buildBusList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Reusable Bus List Builder ----------
  Widget _buildBusList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4),
      itemCount: busList.length,
      itemBuilder: (context, index) {
        final bus = busList[index];
        return GestureDetector(
          onTap: (){
            Get.to(SelectSeatsScreen());
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus["departure"],
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        bus["arrival"],
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 26,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.settings, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              "8.9",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Center(child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(Icons.arrow_forward, color: Colors.grey, size: 24),
                )),

                // Middle section
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus["duration"],
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        bus["seats"],
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "*****",
                        style: GoogleFonts.poppins(
                          color: Colors.indigo,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right section
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bus["time"],
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          bus["price"],
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Last 10 min",
                          style: GoogleFonts.poppins(
                            color: Colors.red.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
