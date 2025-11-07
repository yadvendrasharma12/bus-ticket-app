
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/apis_url.dart';
import '../utils/shared_prefrance.dart';


class DriverService {
  static Future<List<dynamic>?> fetchDrivers() async {
    print("🔹 [DriverService] fetchDrivers() called");

    try {
      // Step 1: Get token
      final token = await MySharedPref.getToken();
      print("🟦 Token from SharedPreferences: $token");

      if (token == null) {
        print("⚠️ No token found! User may not be logged in.");
        return null;
      }

      // Step 2: API call
      final url = Uri.parse(ApiUrls.driversList);
      print("🌐 Fetching driver list from: $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Step 3: Log response
      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          print("✅ Drivers fetched successfully!");
          return data["data"];
        } else {
          print("❌ API returned success: false");
        }
      } else {
        print("❌ Failed to fetch drivers — ${response.statusCode}");
      }
      return null;
    } catch (e, st) {
      print("⚠️ Exception fetching drivers: $e");
      print(st);
      return null;
    }
  }
}
