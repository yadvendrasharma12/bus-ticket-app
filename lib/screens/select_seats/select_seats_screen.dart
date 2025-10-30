import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectSeatsScreen extends StatefulWidget {
  const SelectSeatsScreen({super.key});

  @override
  State<SelectSeatsScreen> createState() => _SelectSeatsScreenState();
}

class _SelectSeatsScreenState extends State<SelectSeatsScreen> {


  final int rows = 8;
  final int columns = 4;

  // store selected seats
  List<String> selectedSeats = [];

  // predefined booked seats
  final List<String> bookedSeats = ["1A", "2C", "3D", "4B", "6C"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),



      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                          child: Icon(Icons.arrow_back_ios,color: Colors.indigo.shade800,)),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 136),
                        child: Text(
                          "Select seats",
                          style: GoogleFonts.poppins(
                            color: Colors.indigo.shade900,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Moratuwa",
                          style: GoogleFonts.poppins(
                            color: Colors.indigo.shade900,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Icon(Icons.arrow_forward,color: Colors.grey),
                        Text(
                          "CoovaChilli",
                          style: GoogleFonts.poppins(
                            color: Colors.indigo.shade900,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],),
                  ),
                  SizedBox(height: 6,),
                  Container(
                    margin: EdgeInsets.only(left: 30,right: 30),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.indigo.shade800)
                          ),
                          child: Center(
                            child:      Text(
                              textAlign: TextAlign.center,
                              "Super Luxury",
                              style: GoogleFonts.poppins(
                                color: Colors.indigo.shade900,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(children: [
                            Icon(Icons.alarm,size: 12,color: Colors.indigo.shade800,) ,
                            SizedBox(width: 4,),
                            Center(
                              child:      Text(
                                textAlign: TextAlign.center,
                                "15:30",
                                style: GoogleFonts.poppins(
                                  color: Colors.indigo.shade900,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],),
                        ),
                        Container(
                          child: Row(children: [
                            Icon(Icons.date_range,size: 12,color: Colors.indigo.shade800,) ,
                            SizedBox(width: 4,),
                            Center(
                              child:      Text(
                                textAlign: TextAlign.center,
                                "23 Sep 2019",
                                style: GoogleFonts.poppins(
                                  color: Colors.indigo.shade900,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],),
                        ),
                      ],),
                  )
                ],
              ),

              const SizedBox(height: 33),

              Container(
                height: 600,
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(
                    horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo.shade800,width: 1.5),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 15,right: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.car_crash,
                            color: Colors.indigo.shade800, size: 30),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        height: 500,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),

                        ),
                        child: Column(
                          children: [

                            const SizedBox(height: 10),

                            SingleChildScrollView(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics:
                                const NeverScrollableScrollPhysics(), // scroll handled by parent
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio:
                                  0.9, // 👈 controls seat rectangle proportion
                                ),
                                itemCount: rows * columns,
                                itemBuilder: (context, index) {
                                  int row = (index ~/ columns) + 1;
                                  String seatLetter =
                                  String.fromCharCode(65 + (index % columns));
                                  String seatId = "$row$seatLetter";

                                  bool isBooked = bookedSeats.contains(seatId);
                                  bool isSelected = selectedSeats.contains(seatId);

                                  Color seatColor;
                                  if (isBooked) {
                                    seatColor = Colors.grey.shade400;
                                  } else if (isSelected) {
                                    seatColor = Colors.yellow.shade700;
                                  } else {
                                    seatColor = Colors.white;
                                  }

                                  return GestureDetector(
                                    onTap: isBooked
                                        ? null
                                        : () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedSeats.remove(seatId);
                                        } else {
                                          selectedSeats.add(seatId);
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 28, // 👈 smaller width
                                      height: 28, // 👈 smaller height
                                      decoration: BoxDecoration(
                                        color: seatColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.indigo.shade900,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          seatId,
                                          style: GoogleFonts.poppins(
                                            color: isBooked
                                                ? Colors.white
                                                : Colors.indigo.shade900,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10, // 👈 smaller font
                                          ),
                                        ),
                                      ),
                                    ),
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
              ),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.only(left: 20,top: 0,right: 0),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  "Seats",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "21.22M",
                  style: GoogleFonts.poppins(
                    color: Colors.indigo.shade900,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flore fare",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "2400.00 KLR",
                    style: GoogleFonts.poppins(
                      color: Colors.indigo.shade900,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              height: 80,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.yellow.shade800
              ),
              child: Center(
                child:    Text(
                  "Verify",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          )
        ],),
      ),
    );
  }
}


