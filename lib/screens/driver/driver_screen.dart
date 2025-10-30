import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  // Dummy driver data list
  final List<Map<String, dynamic>> drivers = [
    {
      "image":
      "https://img.freepik.com/free-photo/handsome-smiling-delivery-man-wearing-cap_171337-15921.jpg?w=740",
      "name": "Ramesh Kumar",
      "experience": "6 Years",
      "designation": "Senior Driver",
    },
    {
      "image":
      "https://img.freepik.com/free-photo/portrait-handsome-young-man-smiling-standing-crossed-arms_171337-1057.jpg?w=740",
      "name": "Suresh Singh",
      "experience": "3 Years",
      "designation": "Assistant Driver",
    },
    {
      "image":
      "https://img.freepik.com/free-photo/young-delivery-man-holding-cardboard-box-smiling-uniform_171337-5103.jpg?w=740",
      "name": "Ankit Sharma",
      "experience": "5 Years",
      "designation": "Express Route Driver",
    },
    {
      "image":
      "https://img.freepik.com/free-photo/portrait-smiling-delivery-man-with-crossed-arms_171337-20250.jpg?w=740",
      "name": "Deepak Patel",
      "experience": "8 Years",
      "designation": "VIP Route Driver",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Driver List",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.indigo[900],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: drivers.length,
        itemBuilder: (context, index) {
          final driver = drivers[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // 🧑‍✈️ Driver Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    driver["image"],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),

                // 📄 Driver Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver["name"],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        driver["designation"],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            driver["experience"],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
