

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/auth_controllers.dart';

class BusApiService {

  static Future<Map<String, dynamic>?> fetchScheduleDetail(String scheduleId) async {
    final token = Get.find<AuthController>().token.value;

    try {
      final url = Uri.parse(
        "https://api.grtourtravels.com/api/onboard/$scheduleId",
      );

      debugPrint("🚍 Fetching schedule detail for: $scheduleId");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("🧾 schedule detail code: ${response.statusCode}");
      debugPrint("🧾 schedule detail body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'] as Map<String, dynamic>?;
        if (data == null) {
          Get.snackbar("Error", "Invalid data from server");
          return null;
        }
        return data;
      } else {
        Get.snackbar(
          "Error",
          "Failed to load seat layout. (${response.statusCode})",
        );
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error while fetching schedule detail: $e");
      Get.snackbar("Error", "Something went wrong while loading seats");
      return null;
    }
  }
}
