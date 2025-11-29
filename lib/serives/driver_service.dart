
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/apis_url.dart';
import '../utils/shared_prefrance.dart';


class DriverService {
  static Future<List<dynamic>?> fetchDrivers() async {
    if (kDebugMode) {
      print("🔹 [DriverService] fetchDrivers() called");
    }

    try {
      final token = await MySharedPref.getToken();
      if (kDebugMode) {
        print("🟦 Token from SharedPreferences: $token");
      }

      if (token == null) {
        if (kDebugMode) {
          print("⚠️ No token found! User may not be logged in.");
        }
        return null;
      }

      final url = Uri.parse(ApiUrls.driversList);
      if (kDebugMode) {
        print("🌐 Fetching driver list from: $url");
      }

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (kDebugMode) {
        print("📥 Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("📥 Response: ${response.body}");
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("🔹 Response Code: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("🔹 Response Body: ${response.body}");
        }

        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          if (kDebugMode) {
            print("✅ Drivers fetched successfully!");
          }
          return data["data"];
        } else {
          if (kDebugMode) {
            print("❌ API returned success: false");
          }
        }
      } else {
        if (kDebugMode) {
          print("❌ Failed to fetch drivers — ${response.statusCode}");
        }
      }
      return null;
    } catch (e, st) {
      if (kDebugMode) {
        print("⚠️ Exception fetching drivers: $e");
      }
      if (kDebugMode) {
        print(st);
      }
      return null;
    }
  }
}
