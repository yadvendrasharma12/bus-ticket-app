import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bus_booking_app/utils/apis_url.dart';
import '../controllers/auth_controllers.dart';

class RatingService {


  static Future<String?> submitRating({
    required String scheduleId,
    required int rating,
    required String comments,
  }) async {
    try {
      debugPrint("🟡 [POST] submitRating CALLED");

      final authController = Get.find<AuthController>();
      if (authController.token.value.isEmpty) {
        await authController.loadToken();
      }

      final token = authController.token.value;
      final uri = Uri.parse(ApiUrls.ratings);

      final bodyMap = {
        "scheduleId": scheduleId,
        "rating": rating,
        "comments": comments,
      };

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(bodyMap),
      );

      debugPrint("✅ STATUS: ${response.statusCode}");
      debugPrint("📩 RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final String ratingId = decoded['data']['_id'];

        debugPrint("✅ NEW RATING ID: $ratingId");
        return ratingId; // ✅ VERY IMPORTANT
      }

      return null;
    } catch (e, s) {
      debugPrint("❌ submitRating ERROR: $e");
      debugPrint("📛 $s");
      return null;
    }
  }


  static const baseUrl = 'https://api.grtourtravels.com/api/ratings';
  static Future<bool> updateRating({
    required String ratingId,
    required int rating,
    required String comments,
  }) async {
    final authController = Get.find<AuthController>();
    if (authController.token.value.isEmpty) {
      await authController.loadToken();
    }
    final token = authController.token.value;

    final url = Uri.parse('$baseUrl/$ratingId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 🔹 TOKEN ADDED
        },
        body: jsonEncode({
          "rating": rating,
          "comments": comments,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print(response.body);
        print(response.statusCode);
        return data['success'] == true;
      } else {
        debugPrint('❌ Update failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error updating rating: $e');
      return false;
    }
  }


}
