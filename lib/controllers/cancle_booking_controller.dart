import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CancelBookingController extends GetxController {
  var isLoading = false.obs;

  Future<void> cancelBooking(String bookingId, String reason) async {
    isLoading.value = true;
    final url = Uri.parse(
        "https://api.grtourtravels.com/api/bookings/ticket/$bookingId/cancel");

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
        if (kDebugMode) {
          print("❌ Token Missing!");
        }
        return;
      }

      if (kDebugMode) {
        print("🔐 Token: $token");
      }
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"reason": reason}),
      );

      if (kDebugMode) {
        print("🔹 HTTP Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("🔹 Raw Response Body: ${response.body}");
      }

      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print("🔹 Parsed Response: $data");
      }

      if (response.statusCode == 200 && data['success'] == true) {
        if (kDebugMode) {
          print("✅ Ticket cancelled successfully");
        }
        Get.snackbar("Success", "Ticket cancelled successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        if (kDebugMode) {
          print("❌ Error: ${data['message'] ?? 'Something went wrong'}");
        }
        Get.snackbar("Error", data['message'] ?? "Something went wrong",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Exception occurred: $e");
      }
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
      if (kDebugMode) {
        print("🔹 Cancel Booking Request Ended");
      }
    }
  }

}


