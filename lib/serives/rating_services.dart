import 'dart:convert';
import 'package:bus_booking_app/utils/apis_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../controllers/auth_controllers.dart';

class RatingService {
  static Future<bool> submitRating({
    required String scheduleId,
    required int rating,
    required String comments,
  }) async {
    try {
      print("📝 RatingService: submitRating called");
      print("   scheduleId: $scheduleId");
      print("   rating: $rating");
      print("   comments: $comments");


      if (scheduleId.isEmpty) {
        print("❌ Error: scheduleId is empty. Cannot submit rating.");
        return false;
      }

      // Get AuthController
      final authController = Get.find<AuthController>();
      print("🔐 AuthController found");

      // Load token if empty
      if (authController.token.isEmpty) {
        print("ℹ️ Token is empty. Loading token...");
        await authController.loadToken();
      }
      final token = authController.token.value;
      print("✅ Token retrieved: ${token.isNotEmpty ? 'AVAILABLE' : 'EMPTY'}");

      // Prepare request
      final uri = Uri.parse(ApiUrls.ratings);
      final bodyMap = {
        "scheduleId": scheduleId,
        "rating": rating,
        "comments": comments,
      };

      print("📡 Sending POST request to Rating API...");
      print("   URL  : $uri");
      print("   Body : ${jsonEncode(bodyMap)}");
      print("   Headers: Authorization Bearer token");

      // Send HTTP POST
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(bodyMap),
      );

      print("📶 Response received");
      print("   Status code: ${response.statusCode}");
      print("   Body       : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Rating submitted successfully!");
        return true;
      } else if (response.statusCode == 400) {
        final respBody = jsonDecode(response.body);
        if (kDebugMode) {
          print("⚠️ Cannot submit rating: ${respBody['message']}");
        }
        Get.snackbar(
          padding: EdgeInsets.symmetric(horizontal: 13,vertical: 8),
          "Attention",
          respBody['message'] ?? "Cannot submit rating",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.yellow.shade800,
          colorText: Colors.white,
        );
        return false;
      } else {

        return false;
      }
    } catch (e, stackTrace) {
      print("❌ Exception in RatingService.submitRating:");
      print("   Error: $e");
      print("   StackTrace: $stackTrace");
      Get.snackbar(
        "Error",
        "An unexpected error occurred while submitting rating",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.95),
        colorText: Colors.white,
      );
      return false;
    }
  }
}
