
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../serives/route_service.dart';

class BusRoutesScreen extends StatefulWidget {
  const BusRoutesScreen({super.key});

  @override
  State<BusRoutesScreen> createState() => _BusRoutesScreenState();
}

class _BusRoutesScreenState extends State<BusRoutesScreen> {
  List<Map<String, dynamic>> busStops = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBusStops("delhi");
  }


  Future<void> fetchBusStops(String query) async {
    setState(() => isLoading = true);

    try {
      final stops = await RouteService.fetchStops(query);
      setState(() {
        busStops = stops;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching stops: $e");
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.indigo.shade800),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Step 1: View Bus Route",
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),


      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : busStops.isEmpty
          ? const Center(child: Text("No stops found"))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: busStops.length,
        itemBuilder: (context, index) {
          final stop = busStops[index];


          final stopName = stop["displayName"]?.toString().trim().isNotEmpty == true
              ? stop["displayName"]
              : (stop["name"]?.toString().trim().isNotEmpty == true
              ? stop["name"]
              : "Unknown Stop");

          final usageCount = stop["usageCount"]?.toString() ?? "0";

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: ListTile(

              title: Text(
                stopName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                usageCount,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: label,
        style: GoogleFonts.poppins(
          color: Colors.grey.shade700,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
