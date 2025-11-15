import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CancelBookingController extends GetxController {
  var isLoading = false.obs;

  // Cancel Booking API
  Future<void> cancelBooking(String bookingId, String reason) async {
    isLoading.value = true;
    final url = Uri.parse(
        "https://fleetbus.onrender.com/api/bookings/ticket/$bookingId/cancel");

    if (kDebugMode) {
      print("🔹 Cancel Booking Request Started");
    }
    if (kDebugMode) {
      print("URL: $url");
    }
    if (kDebugMode) {
      print("Booking ID: $bookingId");
    }
    if (kDebugMode) {
      print("Reason: $reason");
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      if (token.isEmpty) {
        print("❌ Token Missing!");
        return;
      }

      print("🔐 Token: $token");
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"reason": reason}),
      );

      print("🔹 HTTP Status Code: ${response.statusCode}");
      print("🔹 Raw Response Body: ${response.body}");

      final data = jsonDecode(response.body);
      print("🔹 Parsed Response: $data");

      if (response.statusCode == 200 && data['success'] == true) {
        print("✅ Ticket cancelled successfully");
        Get.snackbar("Success", "Ticket cancelled successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print("❌ Error: ${data['message'] ?? 'Something went wrong'}");
        Get.snackbar("Error", data['message'] ?? "Something went wrong",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("❌ Exception occurred: $e");
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
      print("🔹 Cancel Booking Request Ended");
    }
  }

}


