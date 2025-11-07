
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/apis_url.dart';
import '../utils/shared_prefrance.dart';


class OnboardService {
  static Future<List<Map<String, dynamic>>> fetchUpcomingBuses() async {
    final token = await MySharedPref.getToken();

    if (token == null) {
      throw Exception("No token found. Please login again.");
    }

    final url = Uri.parse("${ApiUrls.onboardBaseUrl}/upcoming");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == true && data["data"] is List) {
        return List<Map<String, dynamic>>.from(data["data"]);
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Failed to fetch buses: ${response.body}");
    }
  }
}
