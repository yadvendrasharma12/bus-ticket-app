import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/apis_url.dart';
import '../utils/shared_prefrance.dart';

class ProfileService {
  static Future<Map<String, dynamic>?> fetchProfile() async {
    print("🔹 [ProfileService] fetchProfile() called");

    try {
      // 🔸 Step 1: Get token from SharedPreferences
      final token = await MySharedPref.getToken();
      print("🟦 Token fetched from SharedPreferences: $token");

      if (token == null) {
        print("⚠️ No token found! User might not be logged in.");
        return null;
      }


      final url = Uri.parse(ApiUrls.profile);
      print("🌐 API URL: $url");


      print("📡 Sending GET request to $url ...");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // 🔸 Step 4: Log response
      print("📥 Response Status Code: ${response.statusCode}");
      print("📥 Raw Response Body: ${response.body}");

      // 🔸 Step 5: Handle success
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("✅ Profile data fetched successfully!");

        // 🔸 Optional: log specific user details
        if (data["data"]?["user"] != null) {
          final user = data["data"]["user"];
          print("👤 User Name: ${user["name"]}");
          print("📧 Email: ${user["email"]}");
          print("📱 Mobile: ${user["mobile"]}");
        }

        return data["data"]["user"];
      } else {
        print("❌ Failed to load profile! Status: ${response.statusCode}");
        print("❌ Error body: ${response.body}");
        return null;
      }
    } catch (e, stackTrace) {
      print("⚠️ Exception while fetching profile: $e");
      print("🪜 StackTrace: $stackTrace");
      return null;
    }
  }
}
