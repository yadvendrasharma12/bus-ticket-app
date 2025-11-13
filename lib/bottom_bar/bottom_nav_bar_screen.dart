import 'package:bus_booking_app/screens/bus_listing/ticket_booking.dart';
import 'package:bus_booking_app/screens/homepage/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/profile/profile_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    CupertinoIcons.home,
    Icons.confirmation_num_outlined,
    Icons.person_outline,
  ];

  final List<String> _labels = ["Home", "Tickets", "Profile"];

  // ---------- Screen list ----------
  final List<Widget> _screens = [
    const HomeScreen(),
    const TicketBookingScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(

        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        height: 68,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1333),
          borderRadius: BorderRadius.circular(40),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (index) {
            final bool isSelected = _selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(
                      _icons[index],
                      color: isSelected
                          ? const Color(0xFF0D1333)
                          : Colors.white,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        _labels[index],
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0D1333),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}



