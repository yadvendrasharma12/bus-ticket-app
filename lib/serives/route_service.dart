import 'dart:convert';
import 'package:bus_booking_app/utils/apis_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/shared_prefrance.dart';

class RouteService {


  static Future<List<Map<String, dynamic>>> fetchStops(String query) async {
    final token = await MySharedPref.getToken();
    final url = Uri.parse("${ApiUrls.routesBaseUrl}?q=$query");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("🔹 Response Code: ${response.statusCode}");
      }
      print("🔹 Response Body: ${response.body}");

      final data = jsonDecode(response.body);
      if (data["success"] == true && data["data"] != null) {
        return List<Map<String, dynamic>>.from(data["data"]);
      }
    }

    return [];
  }
}
