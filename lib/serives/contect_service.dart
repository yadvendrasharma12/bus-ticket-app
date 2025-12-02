import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/contect_info_model.dart';
import '../utils/apis_url.dart';
import '../utils/shared_prefrance.dart';

class ContactService {

  static Future<ContactInfo?> fetchContactInfo() async {
    if (kDebugMode) {
      print("🔹 [ContactService] fetchContactInfo() called");
    }

    try {
      // Get token from SharedPreferences
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

      final url = Uri.parse(ApiUrls.contactInfo);
      if (kDebugMode) {
        print("🌐 Fetching contact info from: $url");
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
        print("📥 Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          if (kDebugMode) {
            print("✅ Contact info fetched successfully!");
          }
          return ContactInfo.fromJson(data["data"]);
        } else {
          if (kDebugMode) {
            print("❌ API returned success: false");
          }
        }
      } else {
        if (kDebugMode) {
          print("❌ Failed to fetch contact info — ${response.statusCode}");
        }
      }
      return null;
    } catch (e, st) {
      if (kDebugMode) {
        print("⚠️ Exception fetching contact info: $e");
        print(st);
      }
      return null;
    }
  }
}
