
// lib/services/booking_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/auth_controllers.dart';

class BookingService {
  /// Schedule ke liye booked seats laane wali API
  static Future<List<String>> fetchBookedSeats(String scheduleId) async {
    try {
      final authController = Get.find<AuthController>();

      if (authController.token.isEmpty) {
        await authController.loadToken();
      }

      final token = authController.token.value;
      if (token.isEmpty) {
        debugPrint("❌ Token empty while fetching booked seats");
        return [];
      }

      final url = Uri.parse(
        "https://api.grtourtravels.com/api/bookings/bookedSeats/$scheduleId",
      );

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("🧾 bookedSeats code: ${response.statusCode}");
      debugPrint("🧾 bookedSeats body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['bookedSeats'];

        if (list is List) {
          return list.map((e) => e.toString()).toList();
        } else {
          return [];
        }
      } else {
        debugPrint("⚠️ Failed to fetch booked seats: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error in BookingService.fetchBookedSeats: $e");
      return [];
    }
  }
}
