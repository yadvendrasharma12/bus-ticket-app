
// lib/services/onboard_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/apis_url.dart';



class OnboardServices {
  static Future<Map<String, dynamic>?> getOnboardData({
    required String scheduleId,
    required String token,
  }) async {
    try {
      final url = Uri.parse("${ApiUrls.onboard}/$scheduleId");

      debugPrint("🚍 [OnboardService] Fetching onboard detail for: $scheduleId");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("🧾 [OnboardService] status: ${response.statusCode}");
      debugPrint("🧾 [OnboardService] body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = json['data'] as Map<String, dynamic>?;
        if (data == null) {
          debugPrint("⚠️ [OnboardService] data null aya");
          return null;
        }
        return data;
      } else {
        debugPrint(
            "❌ [OnboardService] Failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ [OnboardService] Exception: $e");
      return null;
    }
  }
}
