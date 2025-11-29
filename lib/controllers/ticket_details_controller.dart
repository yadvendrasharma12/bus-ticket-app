import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ticket.dart';

class TicketDetailsController extends GetxController {
  var isLoading = true.obs;
  var ticket = Rxn<Ticket>();

  Future<void> fetchTicket(String bookingId) async {
    isLoading.value = true;
    final url = Uri.parse("https://api.grtourtravels.com/api/bookings/ticket/$bookingId");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      if (token.isEmpty) {
        Get.snackbar("Error", "Token not found. Please login.",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);
      print(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ticket.value = Ticket.fromJson(data['data']);
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to fetch ticket",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
