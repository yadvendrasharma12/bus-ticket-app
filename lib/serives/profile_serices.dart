import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/apis_url.dart';
import '../utils/shared_prefrance.dart';

class ProfileService {
  static Future<Map<String, dynamic>?> fetchProfile() async {
    if (kDebugMode) {
      print("🔹 [ProfileService] fetchProfile() called");
    }

    try {

      final token = await MySharedPref.getToken();
      if (kDebugMode) {
        print("🟦 Token fetched from SharedPreferences: $token");
      }

      if (token == null) {
        if (kDebugMode) {
          print("⚠️ No token found! User might not be logged in.");
        }
        return null;
      }


      final url = Uri.parse(ApiUrls.profile);
      if (kDebugMode) {
        print("🌐 API URL: $url");
      }


      if (kDebugMode) {
        print("📡 Sending GET request to $url ...");
      }
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );


      if (kDebugMode) {
        print("📥 Response Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("📥 Raw Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("🔹 Response Code: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("🔹 Response Body: ${response.body}");
        }

        final Map<String, dynamic> data = jsonDecode(response.body);
        if (kDebugMode) {
          print("✅ Profile data fetched successfully!");
        }

        if (data["data"]?["user"] != null) {
          final user = data["data"]["user"];
          if (kDebugMode) {
            print("👤 User Name: ${user["name"]}");
          }
          if (kDebugMode) {
            print("📧 Email: ${user["email"]}");
          }
          if (kDebugMode) {
            print("📱 Mobile: ${user["mobile"]}");
          }
        }

        return data["data"]["user"];
      } else {
        if (kDebugMode) {
          print("❌ Failed to load profile! Status: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("❌ Error body: ${response.body}");
        }
        return null;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("⚠️ Exception while fetching profile: $e");
      }
      if (kDebugMode) {
        print("🪜 StackTrace: $stackTrace");
      }
      return null;
    }
  }
}
