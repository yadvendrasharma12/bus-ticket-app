import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/ticket_model.dart';


class TicketController extends GetxController {
  var tickets = <TicketModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchTickets() async {
    try {
      isLoading.value = true;

      // 🔥 Token Load
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      if (token.isEmpty) {
        print("❌ Token Missing!");
        return;
      }

      print("🔐 Token: $token");

      final response = await http.get(
        Uri.parse("https://api.grtourtravels.com/api/bookings/history"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      final data = json.decode(response.body);

      if (data["success"] == true) {
        tickets.value = List.from(data["data"])
            .map((e) => TicketModel.fromJson(e))
            .toList();
      } else {
        print("❌ API Failed: ${data["message"]}");
      }

    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}

