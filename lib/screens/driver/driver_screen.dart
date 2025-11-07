import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../serives/driver_service.dart';


class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  List<dynamic> _drivers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    print("🚀 Loading drivers...");
    final data = await DriverService.fetchDrivers();

    if (mounted) {
      setState(() {
        _drivers = data ?? [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Drivers & Conductors",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.indigo[900],
          ),
        ),
      ),body: _loading
        ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
        : _drivers.isEmpty
        ? const Center(child: Text("No drivers found"))
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _drivers.length,
      itemBuilder: (context, index) {
        final driver = _drivers[index];
        final imageUrl = driver["profileImage"];

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
              // ✅ Profile image or fallback icon
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: imageUrl != null && imageUrl.toString().isNotEmpty
                    ? Image.network(
                  imageUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _defaultIcon(),
                )
                    : _defaultIcon(),
              ),

              const SizedBox(width: 16),

              // ✅ Driver info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver["name"] ?? "Unknown",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo[900],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver["role"] ?? "Unknown Role",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "${driver["experience"] ?? 0} Years Experience",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            overflow: TextOverflow.ellipsis,
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
  Widget _defaultIcon() {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: 40,
        color: Colors.indigo,
      ),
    );
  }
}
